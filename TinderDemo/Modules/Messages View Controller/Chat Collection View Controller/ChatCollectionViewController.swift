//
//  ChatCollectionViewController.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/22/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

final class ChatCollectionViewController: UICollectionViewController {
  
  // MARK: - Properties
  
  private lazy var chatNavigationBar = ChatNavigationBar(matchedUser: matchedUser)
  
  // MARK: -
  
  private var currentUser: User?
  private var messages = [Message]()
  private let matchedUser: MatchedUser
  private let navigationBarHeight: CGFloat = 120
  
  // MARK: -
  
  private lazy var customInputAccessoryView: CustomInputAccessoryView = {
    let view = CustomInputAccessoryView(frame: .init(x: 0,
                                                     y: 0,
                                                     width: self.view.frame.width,
                                                     height: 50))
    
    view.sendButton.addTarget(self, action: #selector(handleSendButton), for: .touchUpInside)
    return view
  }()
  
  // MARK: -

  private var listener: ListenerRegistration?
  
  // MARK: - Initialization
  
  init(matchedUser: MatchedUser) {
    self.matchedUser = matchedUser
    
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCollectionViewController()
    fetchCurrentUser()
    fetchMessages()
    setupView()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Remove the listner to avoid memory leaks
    if isMovingFromParent {
      listener?.remove()
    }
  }
  
  // MARK: - Overrides
  
  override var inputAccessoryView: UIView? {
    get {
      return customInputAccessoryView
    }
  }
  
  override var canBecomeFirstResponder: Bool {
    return true
  }
  
  // MARK: - Helper Methods
  private func setupView() {
    // Configure Messages Navigation Bar
    collectionView.addSubview(chatNavigationBar)
    chatNavigationBar.snp.makeConstraints {
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
    
    // Set Navigation Button Target
    chatNavigationBar.backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
    
    // Observe Keyboard sid show changes
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleKeyboardShow),
                                           name: UIResponder.keyboardDidShowNotification,
                                           object: nil)
  }
  
  private func setupCollectionViewController() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.isScrollEnabled = true
    collectionView.backgroundColor = .white
    collectionView.alwaysBounceVertical = true
    collectionView.keyboardDismissMode = .interactive
    collectionView.contentInset.top = navigationBarHeight
    collectionView.verticalScrollIndicatorInsets.top = navigationBarHeight
    collectionView.register(ChatCollectionViewCell.self,
                            forCellWithReuseIdentifier: ChatCollectionViewCell.reuseIdentifier)
    
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func fetchCurrentUser() {
    guard let currentUserId = Auth.auth().currentUser?.uid else { return }
    
    Firestore.firestore()
      .collection("users")
      .document(currentUserId)
      .getDocument { [weak self] snapshot, error in
        guard let strongSelf = self else { return }
        
        if let error = error {
          print("Unable to fethc current user:", error)
          return
        }
        
        let data = snapshot?.data() ?? [:]
        strongSelf.currentUser = User(dictionary: data)
    }
  }
  
  private func fetchMessages() {
    guard let currentUserId = Auth.auth().currentUser?.uid else { return }
    
    let query = Firestore.firestore()
      .collection("matches_messages")
      .document(currentUserId)
      .collection(matchedUser.uid)
      .order(by: "timestamp")
    
    listener = query.addSnapshotListener { [weak self] querySnapshot, error in
      guard let strongSelf = self else { return }
      
      if let error = error {
        print("Unable to Fetch Messages:", error)
        return
      }
      
      querySnapshot?.documentChanges.forEach({ change in
        if change.type == .added {
          let dictionary = change.document.data()
          strongSelf.messages.append(.init(dictionary: dictionary))
        }
      })
      
      strongSelf.collectionView.reloadData()
      strongSelf.collectionView.scrollToItem(at: [0, strongSelf.messages.count - 1], at: .bottom, animated: true)
    }
  }
  
  private func saveToFromMesages() {
    guard let currentUserId = Auth.auth().currentUser?.uid else { return }
    
    // Save messages to current user acccount
    let currentUserCollection = Firestore.firestore()
      .collection("matches_messages")
      .document(currentUserId)
      .collection(matchedUser.uid)
    
    let data: [String: Any] = ["text": customInputAccessoryView.textView.text ?? "",
                               "fromId": currentUserId,
                               "toId": matchedUser.uid,
                               "timestamp": Timestamp(date: Date())]
    
    currentUserCollection.addDocument(data: data) { [weak self] error in
      guard let strongSelf = self else { return }
      
      if let error = error {
        print("Unable to Save Message:", error)
        return
      }
      
      strongSelf.customInputAccessoryView.textView.text = nil
      strongSelf.customInputAccessoryView.placeHolderLabel.isHidden = false
    }
    
    // Save messages to matched user acccount
    let matchedUserCollection = Firestore.firestore()
      .collection("matches_messages")
      .document(matchedUser.uid)
      .collection(currentUserId)
    
    matchedUserCollection.addDocument(data: data) { [weak self] error in
      guard let strongSelf = self else { return }
      
      if let error = error {
        print("Unable to Save Message:", error)
        return
      }
      
      strongSelf.customInputAccessoryView.textView.text = nil
      strongSelf.customInputAccessoryView.placeHolderLabel.isHidden = false
    }
  }
  
  private func saveToFromRecentMessages() {
    guard let currentUserId = Auth.auth().currentUser?.uid else { return }
    
    // Save most recent message to current user
    let data: [String: Any] = ["uid": matchedUser.uid,
                               "name": matchedUser.name,
                               "timestamp": Timestamp(date: Date()),
                               "text": customInputAccessoryView.textView.text ?? "",
                               "profileImageUrl": matchedUser.profileImageUrl ?? ""]
    
    Firestore.firestore()
      .collection("matches_messages")
      .document(currentUserId)
      .collection("recent_messages")
      .document(matchedUser.uid)
      .setData(data) { error in
        if let error = error {
          print("Unable to Save Last Message:", error)
          return
        }
    }
    
    // Save most recent messages to matched user
    guard let currentUser = currentUser else { return }
    
    let currentUserData: [String: Any] = ["uid": currentUserId,
                                          "name": currentUser.name ?? "",
                                          "timestamp": Timestamp(date: Date()),
                                          "text": customInputAccessoryView.textView.text ?? "",
                                          "profileImageUrl": currentUser.imageUrl1 ?? ""]
    
    Firestore.firestore()
      .collection("matches_messages")
      .document(matchedUser.uid)
      .collection("recent_messages")
      .document(currentUserId)
      .setData(currentUserData) { error in
        if let error = error {
          print("Unable to Save Last Message:", error)
          return
        }
    }
  }
  
  // MARK: - Actions
  
  @objc private func handleBackButton() {
    navigationController?.popViewController(animated: true)
  }
  
  @objc private func handleSendButton() {
    saveToFromMesages()
    saveToFromRecentMessages()
  }
  
  @objc private func handleKeyboardShow() {
    self.collectionView.scrollToItem(at: [0, messages.count - 1], at: .bottom, animated: true)
  }
}

// MARK: - UICollectionViewDataSource

extension ChatCollectionViewController {
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCollectionViewCell.reuseIdentifier,
                                                        for: indexPath) as? ChatCollectionViewCell else {
                                                          fatalError("Unable to Dequeue Cell") }
    
    let message = messages[indexPath.item]
    cell.configure(with: message)
    
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ChatCollectionViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    // Estimated Sizing
    let estimatedSizeCell = ChatCollectionViewCell(frame: .init(x: 0,
                                                                y: 0,
                                                                width: view.frame.width,
                                                                height: 1000))
    
    estimatedSizeCell.configure(with: messages[indexPath.item])
    estimatedSizeCell.layoutIfNeeded()
    
    let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
    
    return .init(width: view.frame.width, height: estimatedSize.height)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 16, left: 16, bottom: 16, right: 16)
  }
}
