//
//  MatchView.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/7/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseFirestore

final class MatchView: UIView {
  
  // MARK: - Properties
  
  private let currenUserImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.layer.borderWidth = 2
    imageView.contentMode = .scaleAspectFill
    imageView.layer.borderColor = UIColor.white.cgColor
    return imageView
  }()
  
  private let matchedUserImageView: UIImageView = {
    let imageView = UIImageView()
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
    return label
  }()
  
  private let sendMessageButton: UIButton = {
    let button = SendMessageButton(type: .system)
    button.setTitleColor(.white, for: .normal)
    button.setTitle("SEND MESSAGE", for: .normal)
    return button
  }()
  
  private let keepSwippingButton: UIButton = {
    let button = KeepSwippingButton(type: .system)
    button.setTitleColor(.white, for: .normal)
    button.setTitle("Keep Swipping", for: .normal)
    return button
  }()
  
  // MARK: -
  
  private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
  
  private lazy var views = [itsAMatchImageView,
                            itsAMatchLabel,
                            currenUserImageView,
                            matchedUserImageView,
                            sendMessageButton,
                            keepSwippingButton]
  
  // MARK: -
  
  var currentUser: User?
  var matchedUserUid: String? {
    didSet {
      Firestore.firestore()
        .collection("users")
        .document(matchedUserUid ?? "")
        .getDocument { [weak self] snapshot, error  in
          guard let strongSelf = self else { return }
          
          if let error = error {
            print("Unable ot fetch user uid:", error)
            return
          }
          
          // Fetch user data
          guard let dictionary = snapshot?.data() else { return }
          let user = User(dictionary: dictionary)
          
          // Set matched user image
          guard let matchedUserImageUrl = URL(string: user.imageUrl1 ?? "") else { return }
          strongSelf.matchedUserImageView.sd_setImage(with: matchedUserImageUrl)
          
          // Set itsAMatchLabel text
          guard let matchedUserName = user.name else { return }
          strongSelf.itsAMatchLabel.text = "You and \(matchedUserName) have liked\neach other"
          
          // Set current user image
          guard let currentUserimageUrl = URL(string: strongSelf.currentUser?.imageUrl1 ?? "") else { return }
          strongSelf.currenUserImageView.sd_setImage(with: currentUserimageUrl) { (_, _, _, _) in
            // Set up Animations
            strongSelf.setupAnimations()
          }
      }
    }
  }
  
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
    // Hide views
    views.forEach { views in
      addSubview(views)
      views.alpha = 0
    }
    
    // Configure It's a Match Image View
    itsAMatchImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
    }
    
    // Configure Description Label
    itsAMatchLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(itsAMatchImageView.snp.bottom).offset(20)
    }
    
    let imageWidth: CGFloat = 140
    currenUserImageView.layer.cornerRadius = imageWidth / 2
    matchedUserImageView.layer.cornerRadius = imageWidth / 2
    
    // Configure Current User Image View
    currenUserImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.height.width.equalTo(imageWidth)
      $0.trailing.equalTo(self.snp.centerX).offset(-16)
      $0.top.equalTo(itsAMatchLabel.snp.bottom).offset(50)
    }
    
    // Configure Match User Image View
    matchedUserImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.height.width.equalTo(imageWidth)
      $0.leading.equalTo(self.snp.centerX).offset(16)
    }
    
    // Configure Send Message Button
    sendMessageButton.snp.makeConstraints {
      $0.height.equalTo(60)
      $0.leading.equalToSuperview().offset(48)
      $0.trailing.equalToSuperview().offset(-48)
      $0.top.equalTo(matchedUserImageView.snp.bottom).offset(32)
    }
    
    // Configure Keep Swipping Button
    keepSwippingButton.snp.makeConstraints {
      $0.height.equalTo(60)
      $0.leading.equalTo(sendMessageButton.snp.leading)
      $0.trailing.equalTo(sendMessageButton.snp.trailing)
      $0.top.equalTo(sendMessageButton.snp.bottom).offset(16)
    }
  }
  
  private func setupAnimations() {
    // Unhide views
    views.forEach { $0.alpha = 1 }
    
    // Image Views animation starting positions
    let angle = 30 * CGFloat.pi / 180
    currenUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
    matchedUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
    
    // Buttons animation starting positions
    sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
    keepSwippingButton.transform = CGAffineTransform(translationX: 500, y: 0)
    
    // Keyframe animations
    UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic, animations: {
      
      // Animation 1 - Translation back to original position
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45) {
        self.currenUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
        self.matchedUserImageView.transform = CGAffineTransform(rotationAngle: angle)
      }
      
      // Animation 2 - Rotation
      UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
        // Rotate Image Views back to their original postition
        self.currenUserImageView.transform = .identity
        self.matchedUserImageView.transform = .identity
      }
    }) { _ in
    }
    
    // Animate the buttons back to their original postions
    UIView.animate(withDuration: 0.75,
                   delay: 0.6 * 1.3,
                   usingSpringWithDamping: 0.5,
                   initialSpringVelocity: 0.1,
                   options: .curveEaseOut, animations: {
                    // Set buttons back to their original positions
                    self.sendMessageButton.transform = .identity
                    self.keepSwippingButton.transform = .identity
    })
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
