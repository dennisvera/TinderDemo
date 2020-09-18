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
  private var users = [String: User]()
  private var lastFetchedUser: User?
  private var viewModel = [CardViewViewModel]()
  private let progressHud = JGProgressHUD(style: .dark)
  
  // MARK: -
  
  private var topCardView: CardView?
  private var previousCardView: CardView?
  
  // MARK: -
  
  private var swipes = [String: Int]()
  
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
    progressHud.textLabel.text = "Loading"
    progressHud.show(in: view)
    
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
      
      // Fetch Swiped Users
      strongSelf.fetchSwipedUsers()
    }
  }
  
  private func fetchSwipedUsers() {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    Firestore.firestore()
      .collection(FireStoreConstants.swipes)
      .document(uid)
      .getDocument { [weak self] snapshot, error in
        guard let strongSelf = self else { return }
        
        if let error = error {
          print("Failed to Fetch Swip History for Currently Logged User:", error)
          return
        }
        
        guard let data = snapshot?.data() as? [String: Int] else { return }
        strongSelf.swipes = data
        
        // Fetch All Users
        strongSelf.fetchUsersFromFirestore()
    }
  }
  
  private func fetchUsersFromFirestore() {
    let minSeekingAge = user?.minSeekingAge ?? SettingsViewController.defaultMinSeekingAge
    let maxSeekingAge = user?.maxSeekingAge ?? SettingsViewController.defaultMinSeekingAge
    
    let query = Firestore.firestore()
      .collection("users")
      .whereField("age", isGreaterThanOrEqualTo: minSeekingAge)
      .whereField("age", isLessThanOrEqualTo: maxSeekingAge)
      .limit(to: 10)
    
    topCardView = nil
    
    query.getDocuments { [weak self] (snapshot, error) in
      guard let strongSelf = self else { return }
      
      // Dismiss ProgressHud
      strongSelf.progressHud.dismiss()
      
      if let error = error {
        print("Failed to Fetch User:", error)
        return
      }
      
      // Fecth user documents
      snapshot?.documents.forEach({ documentSnapshot in
        let userDictionary = documentSnapshot.data()
        let user = User(dictionary: userDictionary)
        
        strongSelf.users[user.uid ?? ""] = user
        
        // Check that the user.uid is not the current user.
        // Current user does not need to see it's own profile.
        let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
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
    }
  }
  
  private func setupCardView(with user: User) -> CardView {
    let cardView = CardView(frame: .zero)
    cardView.viewModel = user.toCardViewModel()
    cardView.delegate = self
    
    /// `BUG:` calling this function is causing the card to show images from other users on the card.
//    cardView.viewModel = user.toCardViewModel()

    cardsDeckView.addSubview(cardView)
    cardsDeckView.sendSubviewToBack(cardView)
    cardView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    return cardView
  }
  
  private func saveSwipeToFireStore(didLike: Int) {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    guard let cardUid = topCardView?.viewModel.uid else { return }
    
    let documentData = [cardUid: didLike]
    
    Firestore.firestore()
      .collection(FireStoreConstants.swipes)
      .document(uid)
      .getDocument { [weak self] (snapshot, error) in
        guard let strongSelf = self else { return }
        
        if let error = error {
          print("Unable to Fetch Swipe Document:", error)
          return
        }
        
        if snapshot?.exists == true {
          Firestore.firestore()
            .collection(FireStoreConstants.swipes)
            .document(uid)
            .updateData(documentData) { error in
              
              if let error = error {
                print("Failed to Update Data:", error)
                return
              }
              
              if didLike == 1 {
                strongSelf.checkIfMatchExists(cardUid: cardUid)
              }
          }
        } else {
          Firestore.firestore()
            .collection(FireStoreConstants.swipes)
            .document(uid)
            .setData(documentData) { [weak self] error in
              guard let strongSelf = self else { return }

              if let error = error {
                print("Failed to Save Swipe Data:", error)
                return
              }
              
              if didLike == 1 {
                strongSelf.checkIfMatchExists(cardUid: cardUid)
              }
          }
        }
     }
  }
  
  private func checkIfMatchExists(cardUid: String) {
    Firestore.firestore()
      .collection(FireStoreConstants.swipes)
      .document(cardUid)
      .getDocument { [weak self] snapshot, error in
        guard let strongSelf = self else { return }
        
        if let error = error {
          print("Failed to Fetch Document for Card User:", error)
          return
        }
        
        guard let data = snapshot?.data() else { return }
        print(data)
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let hasMatched = data[uid] as? Int == 1
        
        if hasMatched {
          strongSelf.presentMatchView(with: cardUid)
          strongSelf.saveMatchedUserInfo(with: cardUid)
          strongSelf.saveMatchedCurrentUserInfo(with: cardUid)
        }
    }
  }
  
  private func presentMatchView(with cardUid: String) {
    let matchView = MatchView()
    matchView.matchedUserUid = cardUid
    matchView.currentUser = user
    
    view.addSubview(matchView)
    matchView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func saveMatchedCurrentUserInfo(with cardUid: String) {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    
    // Get the current user name and image url
    guard let currentUser = user else { return }
    
    let currentUserData: [String: Any] = ["uid": currentUser.uid ?? "",
                                          "name": currentUser.name ?? "",
                                          "profileImageUrl": currentUser.imageUrl1 ?? "",
                                          "timeStamp": Timestamp(date: Date())]
    
    // Save the current user info to FireStore
    Firestore.firestore()
      .collection("matches_messages")
      .document(cardUid)
      .collection("matches")
      .document(uid)
      .setData(currentUserData) { error in
        if let error = error {
          print("Unable to Save Current User Info:", error)
        }
    }
  }
  
  private func saveMatchedUserInfo(with cardUid: String) {
    guard let uid = Auth.auth().currentUser?.uid else { return }

    // Get the mathed user name and image url
    guard let matchedUser = users[cardUid] else { return }
    
    let matchedUserdata: [String: Any] = ["uid": matchedUser.uid ?? "",
                                          "name": matchedUser.name ?? "",
                                          "profileImageUrl": matchedUser.imageUrl1 ?? "",
                                          "timeStamp": Timestamp(date: Date())]
    
    // Save the matched user info to FireStore
    Firestore.firestore()
      .collection("matches_messages")
      .document(uid)
      .collection("matches")
      .document(cardUid)
      .setData(matchedUserdata) { error in
        if let error = error {
          print("Unable to Save Matched User Info:", error)
        }
    }
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
  
  // MARK: - Actions
  
  private func setupButtonTargets() {
    topNavigationStackView.settingsButton.addTarget(self, action: #selector(handleSettingsButton), for: .touchUpInside)
    topNavigationStackView.messagesButton.addTarget(self, action: #selector(handleMessagesButton), for: .touchUpInside)
    bottomControlsStackView.refreshButton.addTarget(self, action: #selector(handleResfreshButton), for: .touchUpInside)
    bottomControlsStackView.likeButton.addTarget(self, action: #selector(handleLikeButton), for: .touchUpInside)
    bottomControlsStackView.dislikeButton.addTarget(self, action: #selector(handleDisLikeButton), for: .touchUpInside)
  }
  
  @objc private func handleSettingsButton() {
    // Initialize SettingsViewController
    let settingsViewController = SettingsViewController()
    
    // Instantiate the SettingsViewControllerDelegate
    settingsViewController.deleagate = self
    
    // Navigate to the SettingsViewController
    let navigationController = UINavigationController(rootViewController: settingsViewController)
    navigationController.modalPresentationStyle = .fullScreen
    present(navigationController, animated: true)
  }
  
  @objc private func handleMessagesButton() {
    let messagesViewController = MessagesViewController()    
    navigationController?.pushViewController(messagesViewController, animated: true)
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
    let profileDetailViewController = ProfileDetailViewController()
    profileDetailViewController.cardViewModel = cardViewmodel
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
  
  enum FireStoreConstants {
    static let swipes = "swipes"
  }
}
