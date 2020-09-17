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
    label.numberOfLines = 2
    label.font = .boldSystemFont(ofSize: 14)
    return label
  }()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Helper Methods
  
  private func setupView() {    
    let stackView = UIStackView(arrangedSubviews: [profileImageView, userNameLabel])
    stackView.spacing = 4
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.distribution = .fill
    
    let height: CGFloat = 80
    profileImageView.layer.cornerRadius = height / 2
    profileImageView.snp.makeConstraints {
      $0.height.width.equalTo(height)
    }
    
    addSubview(stackView)
    stackView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-4)
    }
  }
  
  // MARK: - Public Methods
  
  func configure(with user: MatchedUser) {
    guard let imageUrl = URL(string: user.profileImageUrl ?? "") else { return }
    profileImageView.sd_setImage(with: imageUrl)
    
    userNameLabel.text = user.name
  }
}
