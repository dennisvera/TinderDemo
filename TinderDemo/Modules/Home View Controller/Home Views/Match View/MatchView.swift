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
  
  private let itsAMatchLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.textColor = .white
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 18)
    label.text = "You and [name] have liked\neach other"
    return label
  }()
  
  private let sendMessageButton: UIButton = {
    let button = SendMessageButton(type: .system)
    button.setTitleColor(.white, for: .normal)
    button.setTitle("SEND MESSAGE", for: .normal)
    return button
  }()
  
  private let keepSwipingButton: UIButton = {
    let button = KeepSwippingButton(type: .system)
    button.setTitleColor(.white, for: .normal)
    button.setTitle("Keep Swipping", for: .normal)
    return button
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
    itsAMatchImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
    }
    
    // Configure Description Label
    addSubview(itsAMatchLabel)
    itsAMatchLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(itsAMatchImageView.snp.bottom).offset(20)
    }
    
    let imageWidth: CGFloat = 140
    currenUserImageView.layer.cornerRadius = imageWidth / 2
    matchedUserImageView.layer.cornerRadius = imageWidth / 2
    
    // Configure Current User Image View
    addSubview(currenUserImageView)
    currenUserImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.height.width.equalTo(imageWidth)
      $0.trailing.equalTo(self.snp.centerX).offset(-16)
      $0.top.equalTo(itsAMatchLabel.snp.bottom).offset(50)
    }
    
    // Configure Match User Image View
    addSubview(matchedUserImageView)
    matchedUserImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.height.width.equalTo(imageWidth)
      $0.leading.equalTo(self.snp.centerX).offset(16)
    }
    
    // Configure Send Message Button
    addSubview(sendMessageButton)
    sendMessageButton.snp.makeConstraints {
      $0.height.equalTo(60)
      $0.leading.equalToSuperview().offset(48)
      $0.trailing.equalToSuperview().offset(-48)
      $0.top.equalTo(matchedUserImageView.snp.bottom).offset(32)
    }
    
    // Configure Keep Swipping Button
    addSubview(keepSwipingButton)
    keepSwipingButton.snp.makeConstraints {
      $0.height.equalTo(60)
      $0.leading.equalTo(sendMessageButton.snp.leading)
      $0.trailing.equalTo(sendMessageButton.snp.trailing)
      $0.top.equalTo(sendMessageButton.snp.bottom).offset(16)
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
