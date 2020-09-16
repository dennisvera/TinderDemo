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
  
  private let collectionView = UICollectionView(frame: .zero,
                                                collectionViewLayout: UICollectionViewFlowLayout())
  
  // MARK: -
  
  private let customNavigationBar: UIView = {
    let view = UIView()
    view.layer.shadowRadius = 8
    view.backgroundColor = .white
    view.layer.shadowOpacity = 0.2
    view.layer.shadowOffset = CGSize(width: 0, height: 10)
    view.layer.shadowColor = UIColor(white: 0, alpha: 0.3).cgColor
    return view
  }()
  
  private let tinderIconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.tintColor = .lightGray
    imageView.contentMode = .scaleAspectFit
    imageView.image = #imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysTemplate)
    return imageView
  }()
  
  private let messagesImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.tintColor = #colorLiteral(red: 0.9977821708, green: 0.4371853769, blue: 0.4595726728, alpha: 1)
    imageView.contentMode = .scaleAspectFit
    imageView.image = #imageLiteral(resourceName: "top_right_messages_icon").withRenderingMode(.alwaysTemplate)
    return imageView
  }()
  
  private let messagesLabel: UILabel = {
    let label = UILabel()
    label.textColor = #colorLiteral(red: 0.9977821708, green: 0.4371853769, blue: 0.4595726728, alpha: 1)
    label.text = "Messages"
    label.textAlignment = .center
    label.font = .boldSystemFont(ofSize: 22)
    return label
  }()
  
  private let feedLabel: UILabel = {
    let label = UILabel()
    label.text = "Feed"
    label.textColor = .lightGray
    label.textAlignment = .center
    label.font = .boldSystemFont(ofSize: 22)
    return label
  }()
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    setupCollectionViewController()
  }
  
  // MARK: - Helper Methods
  
  private func setupView() {
    view.backgroundColor = .white
    
    // Configure Custom Navigation Bar
    view.addSubview(customNavigationBar)
    customNavigationBar.snp.makeConstraints {
      $0.height.equalTo(150)
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(view.safeAreaLayoutGuide)
    }
    
    // Configure Messages Image View
    messagesImageView.snp.makeConstraints {
      $0.height.equalTo(44)
    }
    
    // Instantiate Image Views Stack View
    let imageViewsStackView = UIStackView(arrangedSubviews: [tinderIconImageView, messagesImageView])
    imageViewsStackView.axis = .horizontal
    imageViewsStackView.distribution = .fill
    
    // Instantiate Labels Stack View
    let labelsStackView = UIStackView(arrangedSubviews: [messagesLabel, feedLabel])
    labelsStackView.axis = .horizontal
    labelsStackView.distribution = .fillEqually
    
    // Instantiate Main Stack View
    let mainStackView = UIStackView(arrangedSubviews: [imageViewsStackView, labelsStackView])
    mainStackView.spacing = 4
    mainStackView.axis = .vertical
    
    // Configure Main Stack View
    customNavigationBar.addSubview(mainStackView)
    mainStackView.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      $0.top.equalToSuperview().offset(10)
      $0.leading.equalToSuperview().offset(10)
      $0.trailing.equalToSuperview().offset(-10)
    }
  }
  
  private func setupCollectionViewController() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.isScrollEnabled = true
    collectionView.backgroundColor = .white
    collectionView.register(MessagesCollectionViewCell.self,
                            forCellWithReuseIdentifier: MessagesCollectionViewCell.reuseIdentifier)
    
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.top.equalTo(customNavigationBar.snp.bottom).offset(40)
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
        
    return cell
  }
}

// MARK: - UICollection View Delegate

extension MessagesViewController: UICollectionViewDelegate {}
