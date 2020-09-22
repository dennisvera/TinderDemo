//
//  MatchesHorizontalViewController.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/22/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

final class MatchesHorizontalViewController: UIViewController {
  
  // MARK: - Properties
  
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  
  // MARK: -
  
  private var matchedUsers = [MatchedUser]()
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchMatchedUsers()
    setupCollectionViewController()
  }
  
  // MARK: - Helper Methods
  
  private func setupCollectionViewController() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.isScrollEnabled = true
    collectionView.backgroundColor = .white
    
    // Register Collection View Cell
    collectionView.register(MatchesHorizontalCollectionViewCell.self,
                            forCellWithReuseIdentifier: MatchesHorizontalCollectionViewCell.reuseIdentifier)
    
    // Set the scroll direction to horizontal
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .horizontal
    }
    
    // Constraint Collection View
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
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

// MARK: - UICollectionViewDataSource

extension MatchesHorizontalViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return matchedUsers.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchesHorizontalCollectionViewCell.reuseIdentifier,
                                                        for: indexPath) as? MatchesHorizontalCollectionViewCell else {
                                                          fatalError("Unable to Dequeue Cell") }
    
    let matchedUser = matchedUsers[indexPath.row]
    cell.configure(with: matchedUser)
    
    return cell
  }
}

extension MatchesHorizontalViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let matchedUser = matchedUsers[indexPath.item]
    
    let chatCollectionViewController = ChatCollectionViewController(matchedUser: matchedUser)
    navigationController?.pushViewController(chatCollectionViewController, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return .init(width: 110, height: view.frame.height)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 0, left: 4, bottom: 0, right: 16)
  }
}
