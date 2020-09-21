//
//  MessagesViewController.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/16/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

final class MessagesViewController: UIViewController {
  
  // MARK: - Properties
  
  private let messagesNavigationBar = MessagesNavigationBar()
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  // MARK: -
  
  private var matchedUsers = [MatchedUser]()
  private let navigationBarHeight: CGFloat = 150
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCollectionViewController()
    setupView()
    fetchMatchedUsers()
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
    collectionView.contentInset = .init(top: navigationBarHeight, left: 0, bottom: 0, right: 0)
    
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
  
  private func fetchMatchedUsers() {
    guard let currentUserID = Auth.auth().currentUser?.uid else { return }
    
    Firestore.firestore()
      .collection("matches_messages")
      .document(currentUserID)
      .collection("matches")
      .getDocuments { [weak self] snapshot, error in
        guard let strongSelf = self else { return }
        
        if let error = error {
          print("Unable to Fetch Matched Users:", error)
          return
        }
        
        snapshot?.documents.forEach({ documentSnapshot in
          let dictionary = documentSnapshot.data()
          strongSelf.matchedUsers.append(.init(dictionary: dictionary))
          
          strongSelf.collectionView.reloadData()
        })
    }
  }
}

// MARK: - UICollection View DataSource

extension MessagesViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return matchedUsers.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessagesCollectionViewCell.reuseIdentifier,
                                                        for: indexPath) as? MessagesCollectionViewCell else {
                                                          fatalError("Unable to Dequeue Cell") }
    
    let matchedUser = matchedUsers[indexPath.row]
    cell.configure(with: matchedUser)
    
    return cell
  }
}

// MARK: - UICollection View Delegate Flow Layout

extension MessagesViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let matchedUser = matchedUsers[indexPath.item]
    
    let chatViewController = ChatViewController(matchedUser: matchedUser)
    navigationController?.pushViewController(chatViewController, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return .init(width: 120, height: 140)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 16, left: 16, bottom: 16, right: 16)
  }
}
