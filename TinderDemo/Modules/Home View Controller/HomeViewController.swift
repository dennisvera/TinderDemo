//
//  ViewController.swift
//  TinderDemo
//
//  Created by Dennis Vera on 7/9/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit
import JGProgressHUD
import Firebase

final class HomeViewController: UIViewController {
  
  // MARK: - Properties
  
  private let topNavigationStackView = TopNavigationStackView()
  private let bottomControlsStackView = HomeBottomControlStackView()
  
  private let cardsDeckView: UIView = {
    let view = UIView()
    return view
  }()
  
  // MARK: -

  private var cardViewModel = [CardViewViewModel]()
  private let progressHud = JGProgressHUD(style: .dark)
  
  // MARK: -
  
  private var viewModel: HomeViewModel?
  
  // MARK: -
  
  private var topCardView: CardView?
  private var previousCardView: CardView?
    
  // MARK: - Initialization
  
  init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    
    super.init(nibName: nil, bundle: .main)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    setupButtonTargets()
    fetchCurrentUser()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    showRegistration()
  }
  
  // MARK: - Helper Methods
  
  private func setupView() {
    view.backgroundColor = .white
    navigationController?.navigationBar.isHidden = true
    
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
    progressHud.textLabel.text = Strings.loading
    progressHud.show(in: view)
    
    cardsDeckView.subviews.forEach { $0.removeFromSuperview() }
    
    if Auth.auth().currentUser != nil {
      viewModel?.fetchCurrentUser { [weak self] in
        guard let strongSelf = self else { return }
        
        // Fetch Swiped Users
        strongSelf.fetchSwipedUsers()
      }
    } else {
      showRegistration()
    }
  }
  
  private func fetchSwipedUsers() {
    viewModel?.fetchSwipedUsers { [weak self] in
      guard let strongSelf = self else { return }
      
      // Fetch All Users
      strongSelf.fetchUsersFromFirestore()
    }
  }
  
  private func fetchUsersFromFirestore() {
    topCardView = nil
    
    viewModel?.fetchUsersFromFirestore(completion: { [weak self] snapshot in
      guard let strongSelf = self else { return }
      
      // Dismiss ProgressHud
      strongSelf.progressHud.dismiss()
      
      // Fecth user documents
      snapshot?.documents.forEach({ documentSnapshot in
        let userDictionary = documentSnapshot.data()
        let user = User(dictionary: userDictionary)
        
        strongSelf.viewModel?.users[user.uid ?? ""] = user
        
        // Check that the user.uid is not the current user.
        // Current user does not need to see it's own profile.
        let isNotCurrentUser = user.uid != strongSelf.viewModel?.currentUser
        //        let hasNotSwipedBefore = strongSelf.swipes[user.uid ?? ""] == nil
        let hasNotSwipedBefore = true
        
        if isNotCurrentUser && hasNotSwipedBefore {
          let cardView = strongSelf.setupCardView(with: user)
          
          // Set up the next Card
          strongSelf.previousCardView?.nextCardView = cardView
          strongSelf.previousCardView = cardView
          
          if strongSelf.topCardView == nil {
            strongSelf.topCardView = cardView
          }
        }
      })
    })
  }
  
  private func setupCardView(with user: User) -> CardView {
    let cardView = CardView(frame: .zero)
    cardView.viewModel = user.toCardViewModel()
    cardView.delegate = self
    
    // BUG: calling this function is causing the card to show images from other users on the card.
    // cardView.viewModel = user.toCardViewModel()
    
    cardsDeckView.addSubview(cardView)
    cardsDeckView.sendSubviewToBack(cardView)
    cardView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    return cardView
  }
  
  private func saveSwipeToFireStore(didLike: Int) {
    guard let cardUid = topCardView?.viewModel.uid else { return }
    
    viewModel?.saveSwipeToFireStore(with: cardUid, didLike: didLike, completion: { [weak self]  didLike in
      guard let strongSelf = self else { return }
      
      if didLike == 1 {
        strongSelf.checkIfMatchExists(cardUid: cardUid)
      }
    })
  }
  
  private func checkIfMatchExists(cardUid: String) {
    viewModel?.checkIfMatchExists(cardUid: cardUid, completion: { [weak self] hasMatched in
      guard let strongSelf = self else { return }
      
      if hasMatched {
        strongSelf.presentMatchView(with: cardUid)
        strongSelf.saveMatchedUserInfo(with: cardUid)
        strongSelf.saveMatchedCurrentUserInfo(with: cardUid)
      }
    })
  }
  
  private func presentMatchView(with cardUid: String) {
    let matchView = MatchView()
    matchView.matchedUserUid = cardUid
    matchView.currentUser = viewModel?.user
    
    view.addSubview(matchView)
    matchView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func saveMatchedCurrentUserInfo(with cardUid: String) {
    viewModel?.saveMatchedCurrentUserInfo(with: cardUid)
  }
  
  private func saveMatchedUserInfo(with cardUid: String) {
    viewModel?.saveMatchedUserInfo(with: cardUid)
  }
  
  private func performSwipeAnimation(transform: CGFloat, angle: CGFloat) {
    let translationKeyPath = "position.x"
    let rotationKeyPath = "transform.rotation.z"
    let duration = 0.5
    
    let translationAnimation = CABasicAnimation(keyPath: translationKeyPath)
    translationAnimation.toValue = transform
    translationAnimation.duration = duration
    translationAnimation.fillMode  = .forwards
    translationAnimation.isRemovedOnCompletion = false
    translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
    
    let rotationAnimation = CABasicAnimation(keyPath: rotationKeyPath)
    rotationAnimation.toValue = angle * CGFloat.pi / 180
    rotationAnimation.duration = duration
    
    let cardView = topCardView
    topCardView = cardView?.nextCardView
    
    CATransaction.setCompletionBlock {
      cardView?.removeFromSuperview()
    }
    
    cardView?.layer.add(translationAnimation, forKey: translationKeyPath)
    cardView?.layer.add(rotationAnimation, forKey: rotationKeyPath)
    
    CATransaction.commit()
  }
  
  private func showRegistration() {
    // Check if the currentUser is logged out.
    // If user is logged out, present the RegistrationViewController
    if Auth.auth().currentUser == nil {
      let viewModel = RegistrationViewModel(firestoreService: FirestoreService())
      let registrationViewController = RegistrationViewController(viewModel: viewModel)
      registrationViewController.delegate = self
      
      // Navigate to the RegistrationViewController
      let navigationController = UINavigationController(rootViewController: registrationViewController)
      navigationController.modalPresentationStyle = .fullScreen
      present(navigationController, animated: true)
    }
  }
  
  // MARK: - Actions
  
  private func setupButtonTargets() {
    topNavigationStackView.settingsButton.addTarget(self, action: #selector(handleSettingsButton), for: .touchUpInside)
    topNavigationStackView.messagesButton.addTarget(self, action: #selector(handleMessagesButton), for: .touchUpInside)
    bottomControlsStackView.refreshButton.addTarget(self, action: #selector(handleResfreshButton), for: .touchUpInside)
    bottomControlsStackView.likeButton.addTarget(self, action: #selector(handleLikeButton), for: .touchUpInside)
    bottomControlsStackView.dislikeButton.addTarget(self, action: #selector(handleDisLikeButton), for: .touchUpInside)
  }
  
  @objc private func handleSettingsButton() {
    viewModel?.showSettings()
  }
  
  @objc private func handleMessagesButton() {
    viewModel?.showMessages()
  }
  
  @objc private func handleResfreshButton() {
    cardsDeckView.subviews.forEach({ $0.removeFromSuperview() })
    fetchUsersFromFirestore()
  }
  
  @objc private func handleLikeButton() {
    saveSwipeToFireStore(didLike: 1)
    performSwipeAnimation(transform: 700, angle: -15)
  }
  
  @objc private func handleDisLikeButton() {
    saveSwipeToFireStore(didLike: 0)
    performSwipeAnimation(transform: -700, angle: -15)
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
  
  func didSwipeRight() {
    handleLikeButton()
  }
  
  func didSwipeLeft() {
    handleDisLikeButton()
  }
  
  func didRemoveCard(cardView: CardView) {
    topCardView?.removeFromSuperview()
    
    // Set the next card view to be the top card
    topCardView = self.topCardView?.nextCardView
  }
  
  func didTapMoreInfoButton(with cardViewmodel: CardViewViewModel) {
    viewModel?.showProfile(with: cardViewmodel)
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
