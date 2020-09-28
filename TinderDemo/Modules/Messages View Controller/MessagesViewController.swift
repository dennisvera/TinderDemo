//
//  MessagesViewController.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/16/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

final class MessagesViewController: UIViewController {
  
  // MARK: - Properties
  
  private let messagesNavigationBar = MessagesNavigationBar()
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  // MARK: -
  
  private var recentMessages = [RecentMessage]()
  private var recentMessagesDictionary = [String: RecentMessage]()
  
  // MARK: -
  
  private let navigationBarHeight: CGFloat = 150
  
  // MARK: -
  
  private var listener: ListenerRegistration?
  
  // Deinitialization
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCollectionViewController()
    setupView()
    fetchRecentMessages()
    createNotifications()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Remove the listner to avoid memory leaks
    if isMovingFromParent {
      listener?.remove()
    }
  }
  
  // MARK: - Helper Methods
  
  private func setupView() {
    view.backgroundColor = .white
    
    // Configure Messages Navigation Bar
    collectionView.addSubview(messagesNavigationBar)
    messagesNavigationBar.snp.makeConstraints {
      $0.height.equalTo(navigationBarHeight)
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }
    
    // Hide the gap between the Custom Nav Bar and Status Bar
    let statusBarCover = UIView()
    statusBarCover.backgroundColor = .white
    view.addSubview(statusBarCover)
    statusBarCover.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
    }
  }
  
  private func setupCollectionViewController() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.isScrollEnabled = true
    collectionView.backgroundColor = .white
    collectionView.contentInset.top = navigationBarHeight
    collectionView.verticalScrollIndicatorInsets.top = navigationBarHeight
    
    // Register Collection View Cell
    collectionView.register(MessagesCollectionViewCell.self,
                            forCellWithReuseIdentifier: MessagesCollectionViewCell.reuseIdentifier)
    
    // Register Collection Header View
    collectionView.register(MessagesHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: MessagesHeaderView.reuseIdentifier)
    
    // Constraint Collection View
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    // Navigate Back to Home View Controller
    messagesNavigationBar.backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
  }
  
  private func fetchRecentMessages() {
    guard let currentUserID = Auth.auth().currentUser?.uid else { return }
    
    let query = Firestore.firestore()
      .collection("matches_messages")
      .document(currentUserID)
      .collection("recent_messages")
    
    listener = query.addSnapshotListener { [weak self] querySnapshot, error in
      guard let strongSelf = self else { return }
      
      if let error = error {
        print("Unable to Fetch Matched Users:", error)
        return
      }
      
      querySnapshot?.documentChanges.forEach({ change in
        if change.type == .added || change.type == .modified {
          let dictionary = change.document.data()
          let recentMessage = RecentMessage(dictionary: dictionary)
          strongSelf.recentMessagesDictionary[recentMessage.uid] = recentMessage
        }
      })
      
      strongSelf.resetMessages()
    }
  }
  
  private func resetMessages() {
    let values = Array(recentMessagesDictionary.values)
    recentMessages = values.sorted(by: { recentMessage1, recentMesage2 -> Bool in
      return recentMessage1.timestamp.compare(recentMesage2.timestamp) == .orderedDescending
    })
    
    collectionView.reloadData()
  }
  
  // MARK: - Actions
  
  @objc private func handleBackButton() {
    navigationController?.popViewController(animated: true)
  }
  
  // MARK: - Notifications
  
  private func createNotifications() {
    let name = NSNotification.Name(rawValue: Strings.matchesHorizontalControllerSegue)
    NotificationCenter.default.addObserver(self, selector: #selector(didSelectMatchedUser), name: name, object: nil)
  }
  
  @objc private func didSelectMatchedUser(_ notification: Notification) {
    guard let userInfo = notification.userInfo?["matchedUser"] as? MatchedUser else { return }
    let dictionary = ["uid": userInfo.uid,
                      "name": userInfo.name,
                      "profileImageUrl": userInfo.profileImageUrl ?? ""]
    
    let matchedUser = MatchedUser(dictionary: dictionary)
    let chatCollectionViewController = ChatCollectionViewController(matchedUser: matchedUser)
    navigationController?.pushViewController(chatCollectionViewController, animated: true)
  }
}

// MARK: - UICollectionViewDataSource

extension MessagesViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return recentMessages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessagesCollectionViewCell.reuseIdentifier,
                                                        for: indexPath) as? MessagesCollectionViewCell else {
                                                          fatalError("Unable to Dequeue Cell") }
    
    let recentMessage = recentMessages[indexPath.item]
    cell.configure(with: recentMessage)
    
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MessagesViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let recentMessage = recentMessages[indexPath.item]
    let dictionary = ["uid": recentMessage.uid,
                      "name": recentMessage.name,
                      "profileImageUrl": recentMessage.profileImageUrl]
    
    let matchedUser = MatchedUser(dictionary: dictionary)
    let chatCollectionViewController = ChatCollectionViewController(matchedUser: matchedUser)
    navigationController?.pushViewController(chatCollectionViewController, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return .init(width: view.frame.width, height: 130)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 0, left: 0, bottom: 16, right: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}

// MARK: - HeaderView

extension MessagesViewController {
  
  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: MessagesHeaderView.reuseIdentifier,
                                                                             for: indexPath) as? MessagesHeaderView else {
                                                                              fatalError("Invalid view type")}
      
      return headerView
    default:
      assert(false, "Invalid element type")
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      referenceSizeForHeaderInSection section: Int) -> CGSize {
    
    return .init(width: view.frame.width, height: 250)
  }
}
