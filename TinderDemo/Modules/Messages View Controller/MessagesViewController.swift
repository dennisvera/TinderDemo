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
  
  private let navigationBarHeight: CGFloat = 150
  private let messagesNavigationBar = MessagesNavigationBar()
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  // MARK: -
  
  private let viewModel: MessagesViewModel
  
  // MARK: -
  
  var didSelectMessage: ((MatchedUser) -> Void)?
  
  // MARK: - Initialization
  
  init(viewModel: MessagesViewModel) {
    self.viewModel = viewModel
    
    super.init(nibName: nil, bundle: .main)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Deinitialization
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCollectionViewController()
    setupView()
    setupViewModel()
    createNotifications()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Remove listener to avoid memory leaks
    if isMovingFromParent {
      viewModel.removeListener()
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
  
  private func setupViewModel() {
    // Fetch Messages
    viewModel.loadData()
    
    // Install Handler
    viewModel.messagesDidChange = { [weak self] in
      // Update Collection View
      guard let strongSelf = self else { return }
      strongSelf.collectionView.reloadData()
    }
  }
  
  // MARK: - Actions
  
  @objc private func handleBackButton() {
    viewModel.navigateBackHome()
  }
  
  // MARK: - Notifications
  
  private func createNotifications() {
    let name = NSNotification.Name(rawValue: Strings.matchesHorizontalControllerSegue)
    NotificationCenter.default.addObserver(self, selector: #selector(didSelectMatchedUser), name: name, object: nil)
  }
  
  @objc private func didSelectMatchedUser(_ notification: Notification) {
    guard let userInfo = notification.userInfo?[Strings.matchedUserKey] as? MatchedUser else { return }
    let dictionary = [Strings.uid: userInfo.uid,
                      Strings.name: userInfo.name,
                      Strings.profileImageUrl: userInfo.profileImageUrl ?? ""]

    let matchedUser = MatchedUser(dictionary: dictionary)
    let chatCollectionViewController = ChatCollectionViewController(matchedUser: matchedUser)
    navigationController?.pushViewController(chatCollectionViewController, animated: true)
  }
}

// MARK: - UICollectionViewDataSource

extension MessagesViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfMessages
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessagesCollectionViewCell.reuseIdentifier,
                                                        for: indexPath) as? MessagesCollectionViewCell else {
                                                          fatalError("Unable to Dequeue Cell") }
    
    let recentMessage = viewModel.message(at: indexPath.item)
    cell.configure(with: recentMessage)
    
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MessagesViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let recentMessage = viewModel.message(at: indexPath.item)
    let dictionary = [Strings.uid: recentMessage.uid,
                      Strings.name: recentMessage.name,
                      Strings.profileImageUrl: recentMessage.profileImageUrl]
    
    let user = MatchedUser(dictionary: dictionary)
    didSelectMessage?(user)
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
