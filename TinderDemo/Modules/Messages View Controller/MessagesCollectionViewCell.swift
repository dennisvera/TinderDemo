//
//  MessagesCollectionViewCell.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/16/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit

final class MessagesCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Static Properties
  
  static var reuseIdentifier: String {
    return String(describing: self)
  }
  
  // MARK: - Properties
  
  private let profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private let userNameLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.textColor = .black
    label.font = .boldSystemFont(ofSize: 18)
    return label
  }()
  
  private let messageTextLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.textColor = #colorLiteral(red: 0.5685824156, green: 0.5686529875, blue: 0.5685582757, alpha: 1)
    label.font = .systemFont(ofSize: 16)
    label.text = "this is text that will end up being two lines long in order to see the ui work correctly."
    return label
  }()
  
  private let separatorLineView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(white: 0.8, alpha: 1)
    return view
  }()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overrides
  
  override func prepareForReuse() {
    userNameLabel.text = ""
    profileImageView.image = nil
  }
  
  // MARK: - Helper Methods
  
  private func setupView() {
    let height: CGFloat = 94
    profileImageView.layer.cornerRadius = height / 2
    profileImageView.snp.makeConstraints {
      $0.height.width.equalTo(height)
    }
    
    let verticalStackView = UIStackView(arrangedSubviews: [userNameLabel, messageTextLabel])
    verticalStackView.spacing = 4
    verticalStackView.axis = .vertical
    
    let stackView = UIStackView(arrangedSubviews: [profileImageView, verticalStackView])
    stackView.spacing = 20
    stackView.axis = .horizontal
    stackView.alignment = .center
    
    addSubview(stackView)
    stackView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    addSubview(separatorLineView)
    separatorLineView.snp.makeConstraints {
      $0.height.equalTo(0.5)
      $0.trailing.equalToSuperview()
      $0.leading.equalTo(userNameLabel.snp.leading)
      $0.top.equalTo(stackView.snp.bottom).offset(14)
    }
  }
  
  // MARK: - Public Methods
  
  func configure(with user: MatchedUser) {
    guard let imageUrl = URL(string: user.profileImageUrl ?? "") else { return }
    profileImageView.sd_setImage(with: imageUrl)
    userNameLabel.text = user.name
  }
}
