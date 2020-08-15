//
//  ViewController.swift
//  TinderDemo
//
//  Created by Dennis Vera on 7/9/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import JGProgressHUD

final class HomeViewController: UIViewController {
  
  // MARK: - Properties
  
  private let cardsDeckView: UIView = {
    let view = UIView()
    return view
  }()
  
  private let topNavigationStackView = TopNavigationStackView()
  private let bottomControlsStackView = HomeBottomControlStackView()
  
  // MARK: -
  
  private var user: User?
  private var lastFetchedUser: User?
  private var viewModel = [CardViewViewModel]()
  private let progressHud = JGProgressHUD(style: .dark)
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    setupButtonTargets()
    fetchCurrentUser()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    showRegistrationViewController()
  }
  
  // MARK: - Helper Methods
  
  private func setupView() {
    view.backgroundColor = .white
    
    let mainStackView = UIStackView(arrangedSubviews: [topNavigationStackView, cardsDeckView, bottomControlsStackView])
    mainStackView.axis = .vertical
    
    view.addSubview(mainStackView)
    mainStackView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
    
    mainStackView.bringSubviewToFront(cardsDeckView)
    
    // Set constraints Relative to the SuperView Margins
    mainStackView.isLayoutMarginsRelativeArrangement = true
    mainStackView.layoutMargins = .init(top: Layout.zero,
                                        left: Layout.leadingMarging,
                                        bottom: Layout.zero,
                                        right: Layout.leadingMarging)
  }
  
  private func fetchCurrentUser() {
    // Show ProgressHud
    showProgressHud()
    
    cardsDeckView.subviews.forEach { $0.removeFromSuperview() }
    
    Firestore.firestore().fetchCurrentUser { [weak self] (user, error) in
      guard let strongSelf = self else { return }
      
      // Dismiss ProgressHud
      strongSelf.progressHud.dismiss()
      
      if let error = error {
        print("Failed to Fetch User:", error)
        return
      }
      
      // Fetch current user
      strongSelf.user = user
      
      // Fetch all users
      strongSelf.fetchUsersFromFirestore()
    }
  }
  
  private func fetchUsersFromFirestore() {
    guard let minAge = user?.minSeekingAge, let maxAge = user?.maxSeekingAge else { return }
    
    let query = Firestore.firestore()
      .collection("users")
      .whereField("age", isGreaterThanOrEqualTo: minAge)
      .whereField("age", isLessThanOrEqualTo: maxAge)
    
    query.getDocuments { [weak self] (snapshot, error) in
      guard let strongSelf = self else { return }
      
      strongSelf.progressHud.dismiss()
      
      if let error = error {
        print("Failed to Fetch User:", error)
        return
      }
      
      // Fecth user documents
      snapshot?.documents.forEach({ documentSnapshot in
        let userDictionary = documentSnapshot.data()
        let user = User(dictionary: userDictionary)
        
        // Do not display the current user
        // *Current user does not need to see its own profile
        if user.uid != Auth.auth().currentUser?.uid {
          strongSelf.setupCard(with: user)
        }
      })
    }
  }
  
  private func setupCard(with user: User) {
    let cardView = CardView(frame: .zero)
    cardView.viewModel = user.toCardViewModel()
    cardView.delegate = self
    
    cardsDeckView.addSubview(cardView)
    cardsDeckView.sendSubviewToBack(cardView)
    cardView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func showRegistrationViewController() {
    // Check if the currentUser is logged out.
    // If user is logged out, present the RegistrationViewController
    if Auth.auth().currentUser == nil {
      let registrationViewController = RegistrationViewController()
      registrationViewController.delegate = self
      
      // Navigate to the RegistrationViewController
      let navigationController = UINavigationController(rootViewController: registrationViewController)
      navigationController.modalPresentationStyle = .fullScreen
      present(navigationController, animated: true)
    }
  }
  
  private func showProgressHud() {
    progressHud.textLabel.text = "Loading ..."
    progressHud.show(in: view)
  }
  
  // MARK: - Actions
  
  private func setupButtonTargets() {
    topNavigationStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
    bottomControlsStackView.refreshButton.addTarget(self, action: #selector(handleResfresh), for: .touchUpInside)
  }
  
  @objc private func handleSettings() {
    // Initialize SettingsViewController
    let settingsViewController = SettingsViewController()
    
    // Instantiate the SettingsViewControllerDelegate
    settingsViewController.deleagate = self
    
    // Navigate to the SettingsViewController
    let navigationController = UINavigationController(rootViewController: settingsViewController)
    navigationController.modalPresentationStyle = .fullScreen
    present(navigationController, animated: true)
  }
  
  @objc private func handleResfresh() {
    fetchUsersFromFirestore()
  }
}

// MARK: - LoginViewControllerDelegate

extension HomeViewController: LoginViewControllerDelegate {
  
  func didFinishLoggingIn() {
    fetchCurrentUser()
  }
}

// MARK: - SettingsViewControllerDelegate

extension HomeViewController: SettingsViewControllerDelegate {
  
  func didSaveSettings() {
    fetchCurrentUser()
  }
}

// MARK: - CardViewDelegate

extension HomeViewController: CardViewDelegate {
  
  func didTapMoreInfoButton() {
    let profileDetailViewController = ProfileDetailViewController()
    profileDetailViewController.modalPresentationStyle = .fullScreen
    
    present(profileDetailViewController, animated: true)
  }
}

// MARK: - Layout

extension HomeViewController {
  
  // MARK: - Types
  
  enum Layout {
    static let zero: CGFloat = 0
    static let leadingMarging: CGFloat = 8
  }
}
