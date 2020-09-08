//
//  MatchView.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/7/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit

final class MatchView: UIView {
  
  // MARK: - Properties
  
  private let currenUserImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "alyssa1")
    imageView.clipsToBounds = true
    imageView.layer.borderWidth = 2
    imageView.contentMode = .scaleAspectFill
    imageView.layer.borderColor = UIColor.white.cgColor
    return imageView
  }()
  
  private let matchedUserImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "kelly1")
    imageView.clipsToBounds = true
    imageView.layer.borderWidth = 2
    imageView.contentMode = .scaleAspectFill
    imageView.layer.borderColor = UIColor.white.cgColor
    return imageView
  }()
  
  private let itsAMatchImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "itsamatch")
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.numberOfLines = 2
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 18)
    label.text = "You and [name] have liked\neach other"
    return label
  }()
  
  private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupBlurView()
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: - Helper Methods
  
  private func setupBlurView() {
    visualEffectView.alpha = 0
    
    addSubview(visualEffectView)
    visualEffectView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 1,
                   initialSpringVelocity: 1,
                   options: .curveEaseOut, animations: {
                    self.visualEffectView.alpha = 1
    }) { (_) in
    }
  }
  
  private func setupViews() {
    // Configure It's a Match Image View
    addSubview(itsAMatchImageView)
    itsAMatchImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
    }
    
    // Configure Description Label
    addSubview(descriptionLabel)
    descriptionLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(itsAMatchImageView.snp.bottom).offset(20)
    }
    
    let imageWidth: CGFloat = 140
    currenUserImageView.layer.cornerRadius = imageWidth / 2
    matchedUserImageView.layer.cornerRadius = imageWidth / 2
    
    // Configure Current User Image View
    addSubview(currenUserImageView)
    currenUserImageView.snp.makeConstraints { make in
      make.height.width.equalTo(imageWidth)
      make.centerY.equalToSuperview()
      make.trailing.equalTo(self.snp.centerX).offset(-16)
      make.top.equalTo(descriptionLabel.snp.bottom).offset(50)
    }
    
    // Configure Match User Image View
    addSubview(matchedUserImageView)
    matchedUserImageView.snp.makeConstraints { make in
      make.height.width.equalTo(imageWidth)
      make.centerY.equalToSuperview()
      make.leading.equalTo(self.snp.centerX).offset(16)
    }
  }
  
  // MARK: - Actions
  
  @objc private func handleTapDismiss() {
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 1,
                   initialSpringVelocity: 1,
                   options: .curveEaseOut, animations: {
                    self.alpha = 0
    }) { (_) in
      self.removeFromSuperview()
    }
  }
}
