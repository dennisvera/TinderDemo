//
//  ChatCollectionViewController.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/22/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit

final class ChatCollectionViewController: UICollectionViewController {
  
  // MARK: - Properties
  
  private let viewModel: ChatViewModel
  
  // MARK: -
  
  private lazy var chatNavigationBar = ChatNavigationBar(matchedUser: viewModel.matchedUser)
  
  // MARK: -
  
  private let navigationBarHeight: CGFloat = 120
  
  // MARK: -
  
  private lazy var customInputAccessoryView: CustomInputAccessoryView = {
    let view = CustomInputAccessoryView(frame: .init(x: 0,
                                                     y: 0,
                                                     width: self.view.frame.width,
                                                     height: 50))
    
    view.sendButton.addTarget(self, action: #selector(handleSendButton),
                              for: .touchUpInside)
    return view
  }()
  
  // MARK: - Initialization
  
  init(viewModel: ChatViewModel) {
    self.viewModel = viewModel
    
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
    fetchChatMessages()
    setupView()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Remove the listner to avoid memory leaks
    if isMovingFromParent {
      viewModel.removeListener()
    }
  }
  
  // MARK: - Overrides

  // swiftlint:disable implicit_getter
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
    viewModel.fetchCurrentUser()
  }
  
  private func fetchChatMessages() {
    viewModel.fetchChatMessages { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.collectionView.reloadData()
      strongSelf.collectionView.scrollToItem(at: [0, strongSelf.viewModel.numberOfMessages - 1],
                                             at: .bottom,
                                             animated: true)
    }
  }
  
  private func saveToFromMesages() {
    viewModel.saveToFromChatMesage(with: customInputAccessoryView.textView.text) { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.customInputAccessoryView.textView.text = nil
      strongSelf.customInputAccessoryView.placeHolderLabel.isHidden = false

    }
  }
  
  private func saveToFromChatRecentMessages() {
    viewModel.saveToFromChatRecentMessages(with: customInputAccessoryView.textView.text)
  }
  
  // MARK: - Actions
  
  @objc private func handleBackButton() {
    navigationController?.popViewController(animated: true)
  }
  
  @objc private func handleSendButton() {
    saveToFromMesages()
    saveToFromChatRecentMessages()
  }
  
  @objc private func handleKeyboardShow() {
    self.collectionView.scrollToItem(at: [0, viewModel.numberOfMessages - 1], at: .bottom, animated: true)
  }
}

// MARK: - UICollectionViewDataSource

extension ChatCollectionViewController {
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfMessages
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCollectionViewCell.reuseIdentifier,
                                                        for: indexPath) as? ChatCollectionViewCell else {
                                                          fatalError("Unable to Dequeue Cell") }
    
    let message = viewModel.messages[indexPath.item]
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
    
    estimatedSizeCell.configure(with: viewModel.messages[indexPath.item])
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
