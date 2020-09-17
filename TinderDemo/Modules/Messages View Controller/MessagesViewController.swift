//
//  MessagesViewController.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/16/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit

final class MessagesViewController: UIViewController {
  
  // MARK: - Properties
  
  private let messagesNavigationBar = MessagesNavigationBar()
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  // MARK: -
  
  private let navigationBarHeight: CGFloat = 150
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCollectionViewController()
    setupView()
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
  }
  
  private func setupCollectionViewController() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.isScrollEnabled = true
    collectionView.backgroundColor = .white
    collectionView.register(MessagesCollectionViewCell.self,
                            forCellWithReuseIdentifier: MessagesCollectionViewCell.reuseIdentifier)
    collectionView.contentInset = UIEdgeInsets(top: navigationBarHeight, left: 0, bottom: 0, right: 0)
    
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    // Navigate Back to Home View Controller
    messagesNavigationBar.backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
  }
  
  // MARK: - Actions
  
  @objc private func handleBackButton() {
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - UICollection View DataSource

extension MessagesViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 2
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessagesCollectionViewCell.reuseIdentifier,
                                                        for: indexPath) as? MessagesCollectionViewCell else {
                                                          fatalError("Unable to Dequeue Cell")
    }
    
    return cell
  }
}

// MARK: - UICollection View Delegate Flow Layout

extension MessagesViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return .init(width: 120, height: 140)
  }
}
