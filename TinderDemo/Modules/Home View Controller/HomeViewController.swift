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
  
  private var lastFetchedUser: User?
  private var viewModel = [CardViewViewModel]()
  private let hud = JGProgressHUD(style: .light)
    
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    setupButtonTargets()
    fetchUsersFromFirebaseStore()
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
  
  private func fetchUsersFromFirebaseStore() {
    showHud()
    
    let query = Firestore.firestore()
      .collection("users")
      .order(by: "uid")
      .start(after: [lastFetchedUser?.uid ?? ""])
      .limit(to: 2)
    
    query.getDocuments { [weak self] (snapshot, error) in
      guard let strongSelf = self else { return }
      strongSelf.hud.dismiss()

      if let error = error {
        print("failed to fethc user:", error)
        return
      }
      
      // Fecth user documents
      snapshot?.documents.forEach({ documentSnapshot in
        let userDictionary = documentSnapshot.data()
        let user = User(dictionary: userDictionary)
        
        strongSelf.viewModel.append(user.toCardViewModel())
        
        // Hold on to the last fetched user
        strongSelf.lastFetchedUser = user
        
        strongSelf.setupCard(with: user)
      })
    }
  }
  
  private func setupCard(with user: User) {
    let cardView = CardView(frame: .zero)
    cardView.viewModel = user.toCardViewModel()
    
    cardsDeckView.addSubview(cardView)
    cardsDeckView.sendSubviewToBack(cardView)
    cardView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func showHud() {
    hud.textLabel.text = "Fetching ..."
    hud.show(in: view)
  }
  
  // MARK: - Actions
  
  private func setupButtonTargets() {
    topNavigationStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
    bottomControlsStackView.refreshButton.addTarget(self, action: #selector(handleResfresh), for: .touchUpInside)
  }
  
  @objc private func handleSettings() {
    let settingsViewController = SettingsViewController()
    let navigationController = UINavigationController(rootViewController: settingsViewController)
    navigationController.modalPresentationStyle = .fullScreen
    present(navigationController, animated: true)
  }
  
  @objc private func handleResfresh() {
    fetchUsersFromFirebaseStore()
  }
}

extension HomeViewController {
  
  // MARK: - Types
  
  enum Layout {
    static let zero: CGFloat = 0
    static let leadingMarging: CGFloat = 8
  }
}
