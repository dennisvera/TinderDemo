//
//  ChatNavigationBar.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/19/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit

final class ChatNavigationBar: UIView {
  
  // MARK: - Properties
  
  let backButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "dismiss_circle_icon"), for: .normal)
    button.imageView?.contentMode = .scaleAspectFill
    return button
  }()
  
  let reportButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "dismiss_circle_icon"), for: .normal)
    button.imageView?.contentMode = .scaleAspectFill
    return button
  }()
  
  private let profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "kelly1")
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.text = "Name"
    label.font = .boldSystemFont(ofSize: 12)
    return label
  }()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupViews()
    setupShadow()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Helper Methods
  
  private func setupViews() {
    backgroundColor = .white
    
    // Configure Profile Image View
    let imageHeight: CGFloat = 50
    profileImageView.layer.cornerRadius = imageHeight / 2
    profileImageView.snp.makeConstraints {
      $0.width.height.equalTo(imageHeight)
    }
    
    // Instantiate Vertical Stack View
    let verticalStackView = UIStackView(arrangedSubviews: [profileImageView, nameLabel])
    verticalStackView.spacing = 4
    verticalStackView.axis = .vertical
    verticalStackView.alignment = .center
    
    // Instantiate Main Stack View
    let mainSatckView = UIStackView(arrangedSubviews: [backButton, verticalStackView, reportButton])
    mainSatckView.axis = .horizontal
    mainSatckView.distribution = .fillEqually
    
    // Configure Vertical StackView
    addSubview(mainSatckView)
    mainSatckView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func setupShadow() {
    layer.shadowRadius = 8
    layer.shadowOpacity = 0.2
    layer.shadowOffset = CGSize(width: 0, height: 10)
    layer.shadowColor = UIColor(white: 0, alpha: 0.3).cgColor
  }
}
