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

class HomeViewController: UIViewController {
  
  // MARK: - Properties
  
  private let cardsDeckView: UIView = {
    let view = UIView()
    return view
  }()
  
  private let topNavigationStackView = TopNavigationStackView()
  private let bottomControlStackView = HomeBottomControlStackView()
  
  // MARK: -
  
  private var viewModel = [CardViewViewModel]()
    
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    topNavigationStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
    
    setupView()
    setupUserCardView()
    fetchUsersFromFirebaseStore()
  }
  
  // MARK: - Helper Methods
  
  private func setupView() {
    view.backgroundColor = .white
    
    let mainStackView = UIStackView(arrangedSubviews: [topNavigationStackView, cardsDeckView, bottomControlStackView])
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
  
  private func setupUserCardView() {
    viewModel.forEach { viewModel in
      let cardView = CardView()
      cardView.viewModel = viewModel
      
      cardsDeckView.addSubview(cardView)
      cardView.snp.makeConstraints { make in
        make.edges.equalToSuperview()
      }
    }
  }
  
  private func fetchUsersFromFirebaseStore() {
    let query = Firestore.firestore().collection("users")
    
    query.getDocuments { [weak self] (snapshot, error) in
      if let error = error {
        print("failed to fethc user:", error)
        return
      }
      
      // Fecth user documents
      snapshot?.documents.forEach({ [weak self] documentSnapshot in
        let userDictionary = documentSnapshot.data()
        let user = User(dictionary: userDictionary)
        
        guard let strongSelf = self else { return }
        strongSelf.viewModel.append(user.toCardViewModel())
      })
      
      guard let strongSelf = self else { return }
      strongSelf.setupUserCardView()
    }
  }
  
  @objc private func handleSettings() {
    let registrationController = RegistrationViewController()
    present(registrationController, animated: true)
  }
}

extension HomeViewController {
  
  // MARK: - Types
  
  enum Layout {
    static let zero: CGFloat = 0
    static let leadingMarging: CGFloat = 8
  }
}
