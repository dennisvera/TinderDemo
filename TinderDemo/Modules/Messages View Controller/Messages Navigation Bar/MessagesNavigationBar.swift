//
//  MessagesNavigationBar.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/17/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit

final class MessagesNavigationBar: UIView {
  
  // MARK: - Properties
  
  let backButton: UIButton = {
    let button = UIButton()
    button.tintColor = #colorLiteral(red: 0.8273723125, green: 0.8512359262, blue: 0.8856532574, alpha: 1)
    button.imageView?.contentMode = .scaleAspectFill
    button.setImage(#imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysTemplate), for: .normal)
    return button
  }()
  
  private let messagesImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.tintColor = #colorLiteral(red: 0.9960784314, green: 0.4352941176, blue: 0.4588235294, alpha: 1)
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
    label.textColor = #colorLiteral(red: 0.5764250159, green: 0.5764964819, blue: 0.576400578, alpha: 1)
    label.textAlignment = .center
    label.font = .boldSystemFont(ofSize: 22)
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

    // Configure Messages Image View
    addSubview(messagesImageView)
    messagesImageView.snp.makeConstraints {
      $0.height.width.equalTo(44)
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(8)
    }
    
    // Configure Back Button
    addSubview(backButton)
    backButton.snp.makeConstraints {
      $0.height.width.equalTo(34)
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalTo(messagesImageView.snp.top)
      $0.trailing.lessThanOrEqualTo(messagesImageView.snp.leading)
    }
    
    // Instantiate Labels Stack View
    let stackView = UIStackView(arrangedSubviews: [messagesLabel, feedLabel])
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    
    // Configure Main Stack View
    addSubview(stackView)
    stackView.snp.makeConstraints {
      $0.bottom.equalToSuperview()
      $0.leading.equalToSuperview().offset(12)
      $0.trailing.equalToSuperview().offset(-12)
      $0.top.equalTo(messagesImageView.snp.bottom).offset(12)
    }
  }
  
  private func setupShadow() {
    layer.shadowRadius = 8
    layer.shadowOpacity = 0.2
    layer.shadowOffset = CGSize(width: 0, height: 10)
    layer.shadowColor = UIColor(white: 0, alpha: 0.3).cgColor
  }
}
