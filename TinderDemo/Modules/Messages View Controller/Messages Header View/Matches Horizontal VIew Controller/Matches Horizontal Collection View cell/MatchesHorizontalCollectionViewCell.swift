//
//  MatchesHorizontalCollectionViewCell.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/22/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit

final class MatchesHorizontalCollectionViewCell: UICollectionViewCell {
  
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
    label.textColor =  #colorLiteral(red: 0.3450689912, green: 0.3451144099, blue: 0.3450536132, alpha: 1)
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
  
  // MARK: - Overrides
  
  override func prepareForReuse() {
    userNameLabel.text = ""
    profileImageView.image = nil
  }
  
  // MARK: - Helper Methods
  
  private func setupView() {
    backgroundColor = .white
    
    let height: CGFloat = 80
    profileImageView.layer.cornerRadius = height / 2
    profileImageView.snp.makeConstraints {
      $0.height.width.equalTo(height)
    }
    
    let stackView = UIStackView(arrangedSubviews: [profileImageView, userNameLabel])
    stackView.axis = .vertical
    stackView.alignment = .center
    
    addSubview(stackView)
    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  // MARK: - Public Methods
  
  func configure(with user: MatchedUser) {
    guard let imageUrl = URL(string: user.profileImageUrl ?? "") else { return }
    profileImageView.sd_setImage(with: imageUrl)
    userNameLabel.text = user.name
  }
}
