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
  
  static func createButton(image: UIImage) -> UIButton {
    let button = UIButton(type: .system)
    button.imageView?.contentMode = .scaleAspectFill
    button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
    return button
  }
  
  // MARK: -
  
  let starButton = createButton(image: #imageLiteral(resourceName: "super_like_circle_icon"))
  let likeButton = createButton(image: #imageLiteral(resourceName: "like_circle_icon"))
  let refreshButton = createButton(image: #imageLiteral(resourceName: "refresh_circle_icon"))
  let dislikeButton = createButton(image: #imageLiteral(resourceName: "dismiss_circle_icon"))
  let lightningButton = createButton(image: #imageLiteral(resourceName: "boost_circle_icon"))
  
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
}
