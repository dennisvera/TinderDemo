//
//  CardView.swift
//  TinderDemo
//
//  Created by Dennis Vera on 7/11/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit

class CardView: UIView {
  
  // MARK: - Private Properties
  
  private let userInformationLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.numberOfLines = Layout.numberOfLines
    return label
  }()
  
  private let profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private var imageIndex = 0
  private let topBarStackView = UIStackView()
  private let gradientLayer = CAGradientLayer()
  private let topBarDeselectedColor = UIColor(white: 0, alpha: 0.1)
  
  // MARK: - Public Properties
  
  var viewModel: CardViewViewModel? {
    didSet {
      let image = viewModel?.imageNames.first ?? ""
      profileImageView.image = UIImage(named: image)
      userInformationLabel.textAlignment = viewModel!.textAlignment
      userInformationLabel.attributedText = viewModel?.attributedString
      
      (0..<(viewModel?.imageNames.count ?? 0)).forEach { (_) in
        let barview = UIView()
        barview.backgroundColor = topBarDeselectedColor
        topBarStackView.addArrangedSubview(barview)
      }
      
      topBarStackView.arrangedSubviews.first?.backgroundColor = .white
    }
  }
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupView()
    setupGestureRecognizers()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overrides
  
  override func layoutSubviews() {
    // The frame is not known till initialization has completed,
    // layoutSubViews has access to the actual frame.
    gradientLayer.frame = self.frame
  }
  
  // MARK: - Helper Methods
  
  private func setupView() {
    clipsToBounds = true
    layer.cornerRadius = Layout.cornerRadius
    
    addSubview(profileImageView)
    profileImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    setupTopBarStackView()
    
    // The gradient layer needs to be called before the userInfoLabel,
    // in order to get the gradient to appear underneath the label.
    setupGradientLayer()
    
    addSubview(userInformationLabel)
    userInformationLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(Layout.User.leading)
      make.bottom.trailing.equalToSuperview().offset(Layout.User.trailing)
    }
  }
  
  private func setupGestureRecognizers() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    addGestureRecognizer(panGesture)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    addGestureRecognizer(tapGesture)
  }
  
  private func setupGradientLayer() {
    gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
    gradientLayer.locations = [Layout.Gradient.topOfTheViewPoint, Layout.Gradient.bottomOfTheViewPoint]
    
    layer.addSublayer(gradientLayer)
  }
  
  private func setupTopBarStackView() {
    addSubview(topBarStackView)
    topBarStackView.snp.makeConstraints { make in
      make.height.equalTo(5)
      make.trailing.equalToSuperview().offset(-8)
      make.top.leading.equalToSuperview().offset(8)
    }
    
    topBarStackView.spacing = 4
    topBarStackView.distribution = .fillEqually
  }
  
  // MARK: - Actions
  
  @objc private func handleTap(gesture: UITapGestureRecognizer) {
    let tapLocation = gesture.location(in: nil)
    let shouldAdvanceToNextPhoto = tapLocation.x > frame.width / 2 ? true : false
    
    if shouldAdvanceToNextPhoto {
      imageIndex = min(imageIndex + 1, viewModel!.imageNames.count - 1)
    } else {
      imageIndex = max(0, imageIndex - 1)
    }
    
    guard let imageName = viewModel?.imageNames[imageIndex] else { return }
    profileImageView.image = UIImage(named: imageName)
    
    // Set the top bar background color to dark when scrolling through the images
    topBarStackView.arrangedSubviews.forEach { subview in
      subview.backgroundColor = topBarDeselectedColor
    }
    
    // Set the top bar to white when scrolling through the images
    topBarStackView.arrangedSubviews[imageIndex].backgroundColor = .white
  }
  
  @objc private func handlePan(gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .began:
      superview?.subviews.last?.layer.removeAllAnimations()
    case .changed:
      handleChaged(gesture)
    case .ended:
      handleEndedAnimation(gesture)
    default:
      ()
    }
  }
  
  private func handleChaged(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: nil)
    
    // Convert radian to Degrees
    let degrees: CGFloat = translation.x / Layout.Gesture.twenty
    let angle = degrees * .pi / Layout.Gesture.oneHundredAndEighty
    
    // Configure Rotation
    let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
    self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
  }
  
  private func handleEndedAnimation(_ gesture: UIPanGestureRecognizer) {
    // Functionality to dismiss the card from left to right and backwards
    let translationDirection: CGFloat = gesture.translation(in: nil).x > Layout.zero ? Layout.one : Layout.negativeOne
    let shouldDismissCard = abs(gesture.translation(in: nil).x) > Layout.threshold
    
    UIView.animate(withDuration: Layout.Animation.duration,
                   delay: Layout.Animation.delay,
                   usingSpringWithDamping: Layout.Animation.springDamping,
                   initialSpringVelocity: Layout.Animation.springVelocity,
                   options: .curveEaseOut,
                   animations: {
                    if shouldDismissCard {
                      self.layer.frame = CGRect(x: Layout.Animation.frameX * translationDirection,
                                          y: Layout.zero,
                                          width: self.frame.width,
                                          height: self.frame.height)
                    } else {
                      // Set transform back to Center
                      self.transform = .identity
                    }
    }) { (_) in
      self.transform = .identity
      
      if shouldDismissCard {
        self.removeFromSuperview()
      }
    }
  }
}

extension CardView {
  
  // MARK: - Types
  
  enum Layout {
    static let one: CGFloat = 1
    static let zero: CGFloat = 0
    static let numberOfLines: Int = 0
    static let threshold: CGFloat = 80
    static let negativeOne: CGFloat = -1
    static let cornerRadius: CGFloat = 10
    
    enum User {
      static let leading = 16
      static let trailing = -16
    }
    
    enum Gesture {
      static let twenty: CGFloat = 20
      static let oneHundredAndEighty: CGFloat = 180
    }
    
    enum Animation {
      static let delay: Double = 0
      static let duration: Double = 1
      static let frameX: CGFloat = 600
      static let springDamping: CGFloat = 0.6
      static let springVelocity: CGFloat = 0.1
    }
    
    enum Gradient {
      static let topOfTheViewPoint: NSNumber = 0.5
      static let bottomOfTheViewPoint: NSNumber = 1.1
    }
  }
}
