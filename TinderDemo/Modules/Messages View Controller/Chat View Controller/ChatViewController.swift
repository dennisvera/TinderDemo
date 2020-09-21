//
//  ChatViewController.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/18/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit

final class ChatViewController: UIViewController {
  
  // MARK: - Properties
  
  private lazy var chatNavigationBar = ChatNavigationBar(matchedUser: matchedUser)
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  // MARK: -
  
  private let matchedUser: MatchedUser
  private let navigationBarHeight: CGFloat = 120
  
  // MARK: - Initialization
  
  init(matchedUser: MatchedUser) {
    self.matchedUser = matchedUser
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCollectionViewController()
    setupView()
  }
  
  // MARK: - Helper Methods
  private func setupView() {
    view.backgroundColor = .yellow
    
    // Configure Messages Navigation Bar
    collectionView.addSubview(chatNavigationBar)
    chatNavigationBar.snp.makeConstraints {
      $0.height.equalTo(navigationBarHeight)
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }
    
    chatNavigationBar.backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
  }
  
  private func setupCollectionViewController() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.isScrollEnabled = true
    collectionView.backgroundColor = .cyan
    collectionView.register(ChatCollectionViewCell.self,
                            forCellWithReuseIdentifier: ChatCollectionViewCell.reuseIdentifier)
    collectionView.contentInset = .init(top: navigationBarHeight, left: 0, bottom: 0, right: 0)
    
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  // MARK: - Actions
  
  @objc private func handleBackButton() {
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - UICollection View DataSource

extension ChatViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCollectionViewCell.reuseIdentifier,
                                                        for: indexPath) as? ChatCollectionViewCell else {
                                                          fatalError("Unable to Dequeue Cell") }
    cell.backgroundColor = .red
    return cell
  }
  
  
}

extension ChatViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return .init(width: view.frame.width, height: 100)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 16, left: 16, bottom: 16, right: 16)
  }
}
