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
  
  let tinderIconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "app_icon")
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let settingsButton: UIButton = {
    let button = UIButton(type: .system)
    let image = #imageLiteral(resourceName: "top_left_profile_icon").withRenderingMode(.alwaysOriginal)
    button.setImage(image, for: .normal)
    return button
  }()
  
  private let messageButton: UIButton = {
    let button = UIButton(type: .system)
    let image = #imageLiteral(resourceName: "top_right_messages_icon").withRenderingMode(.alwaysOriginal)
    button.setImage(image, for: .normal)
    return button
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
  
  private func setupStackView() {
    [settingsButton, UIView(), tinderIconImageView, UIView(), messageButton].forEach { view in
      addArrangedSubview(view)
    }
    
    distribution = .equalCentering
    heightAnchor.constraint(equalToConstant: Layout.heightAnchorConstraint).isActive = true
    
    // Set constraints Relative to the SuperView Margins
    isLayoutMarginsRelativeArrangement = true
    layoutMargins = .init(top: Layout.zero,
                          left: Layout.leadingMarging,
                          bottom: Layout.zero,
                          right: Layout.leadingMarging)
  }
}

private extension TopNavigationStackView {
  
  // MARK: - Types
  
  enum Layout {
    static let zero: CGFloat = 0
    static let leadingMarging: CGFloat = 16
    static let heightAnchorConstraint: CGFloat = 80
  }
}
