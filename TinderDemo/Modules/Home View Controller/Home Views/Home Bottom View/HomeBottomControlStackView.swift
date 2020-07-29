//
//  HomeBottomControlStackView.swift
//  TinderDemo
//
//  Created by Dennis Vera on 7/10/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

class HomeBottomControlStackView: UIStackView {
  
  // MARK: - Properties
  
  let refreshButton = createButton(with: #imageLiteral(resourceName: "refresh_circle_icon"))
  let cancelButton = createButton(with: #imageLiteral(resourceName: "dismiss_circle_icon"))
  let starButton = createButton(with: #imageLiteral(resourceName: "super_like_circle_icon"))
  let heartButton = createButton(with: #imageLiteral(resourceName: "like_circle_icon"))
  let lightningButton = createButton(with: #imageLiteral(resourceName: "boost_circle_icon"))
  
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
    [refreshButton, cancelButton, starButton, heartButton, lightningButton].forEach { button in
      addArrangedSubview(button)
    }
    
    distribution = .fillEqually
    heightAnchor.constraint(equalToConstant: heightAnchorConstraint).isActive = true
  }
  
  private static func createButton(with image: UIImage) -> UIButton {
    let button = UIButton(type: .system)
    let image = image.withRenderingMode(.alwaysOriginal)
    button.setImage(image, for: .normal)
    button.contentMode = .scaleAspectFill
    return button
  }
}
