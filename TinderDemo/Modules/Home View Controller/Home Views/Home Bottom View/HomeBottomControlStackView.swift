//
//  HomeBottomControlStackView.swift
//  TinderDemo
//
//  Created by Dennis Vera on 7/10/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

final class HomeBottomControlStackView: UIStackView {
  
  // MARK: - Properties
  
  let refreshButton = UIButton().createButton(with: #imageLiteral(resourceName: "refresh_circle_icon"), selector: #selector(handleRefreshButton))
  let dislikeButton = UIButton().createButton(with: #imageLiteral(resourceName: "dismiss_circle_icon"), selector: #selector(handleDislikeButton))
  let starButton = UIButton().createButton(with: #imageLiteral(resourceName: "super_like_circle_icon"), selector: #selector(handleStarButton))
  let likeButton = UIButton().createButton(with: #imageLiteral(resourceName: "like_circle_icon"), selector: #selector(handleLikeButton))
  let lightningButton = UIButton().createButton(with: #imageLiteral(resourceName: "boost_circle_icon"), selector: #selector(handleLightningButton))
  
  // MARK: -
  
  private let heightAnchorConstraint: CGFloat = 100
  
  // MARK: - Initilization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupStackView()
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Helper methods
  
  private func setupStackView() {
    [refreshButton, dislikeButton, starButton, likeButton, lightningButton].forEach { button in
      addArrangedSubview(button)
    }
    
    distribution = .fillEqually
    heightAnchor.constraint(equalToConstant: heightAnchorConstraint).isActive = true
  }
  
  // MARK: - Actions
  
  @objc private func handleRefreshButton() {
    print("Refresh button tapped")
  }
  
  @objc private func handleDislikeButton() {
    print("Cancel button tapped")
  }
  
  @objc private func handleStarButton() {
    print("Star button tapped")
  }
  
  @objc private func handleLikeButton() {
    print("Heart button tapped")
  }
  
  @objc private func handleLightningButton() {
    print("Lightning button tapped")
  }
}
