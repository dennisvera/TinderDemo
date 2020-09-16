//
//  MessagesViewController.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/16/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit

class MessagesViewController: UIViewController {
  
  // MARK: - Properties
  
  private var collectionView = UICollectionView(frame: .zero,
                                                collectionViewLayout: UICollectionViewFlowLayout())
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    setupCollectionViewController()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.navigationBar.isHidden = true
  }
  
  // MARK: - Helper Methods
  
  private func setupView() {
    view.backgroundColor = .cyan
    navigationController?.navigationBar.isHidden = false
  }
  
  private func setupCollectionViewController() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .cyan
    collectionView.register(MessagesCollectionViewCell.self,
                            forCellWithReuseIdentifier: MessagesCollectionViewCell.reuseIdentifier)
    
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

// MARK: - UICollection View DataSource

extension MessagesViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessagesCollectionViewCell.reuseIdentifier,
                                                        for: indexPath) as? MessagesCollectionViewCell else {
                                                          fatalError("Unable to Dequeue Cell")
    }
    
    cell.backgroundColor = .red
    
    return cell
  }
}

// MARK: - UICollection View Delegate

extension MessagesViewController: UICollectionViewDelegate {}
