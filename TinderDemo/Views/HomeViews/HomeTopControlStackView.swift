//
//  HomeTopControlStackView.swift
//  TinderDemo
//
//  Created by Dennis Vera on 7/10/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

class TopNavigationStackView: UIStackView {
  
  // MARK: - Properties
  
  private let heightAnchorConstraint: CGFloat = 100
  
  private let topSubviews: [UIButton] = {
    [#imageLiteral(resourceName: "top_left_profile_icon"), #imageLiteral(resourceName: "app_icon"), #imageLiteral(resourceName: "top_right_messages_icon")].map { image -> UIButton in
      let button = UIButton(type: .system)
      let image = image.withRenderingMode(.alwaysOriginal)
      button.setImage(image, for: .normal)
      return button
    }
  }()
  
  // MARK: - Initilization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupStackView()
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Helper methods
  
  func setupStackView() {
    topSubviews.forEach { view in
      addArrangedSubview(view)
    }
    
    distribution = .fillEqually
    heightAnchor.constraint(equalToConstant: heightAnchorConstraint).isActive = true
  }
}
