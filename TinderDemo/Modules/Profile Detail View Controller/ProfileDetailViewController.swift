//
//  ProfileDetailViewController.swift
//  TinderDemo
//
//  Created by Dennis Vera on 8/15/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

final class ProfileDetailViewController: UIViewController {
  
  // MARK: - Properties
  
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.delegate = self
    scrollView.alwaysBounceVertical = true
    scrollView.contentInsetAdjustmentBehavior = .never
    return scrollView
  }()
  
  private let infoLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textColor = .black
    label.font = UIFont.boldSystemFont(ofSize: 20)
    return label
  }()
  
  private let bioLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textColor = .black
    label.font = UIFont.boldSystemFont(ofSize: 18)
    return label
  }()
  
  private let dissmissButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "dismiss_down_arrow_icon").withRenderingMode(.alwaysOriginal), for: .normal)
    button.addTarget(self, action: #selector(handleDismissButton), for: .touchUpInside)
    return button
  }()
  
  // MARK: -
  
  private let pagingPhotosViewController = PagingPhotosViewController()
  
  // MARK: -
  
  private let cancelButton = UIButton().createButton(with: #imageLiteral(resourceName: "dismiss_circle_icon"), selector: #selector(handleCancelButton))
  private let starButton = UIButton().createButton(with: #imageLiteral(resourceName: "super_like_circle_icon"), selector: #selector(handleStarButton))
  private let heartButton = UIButton().createButton(with: #imageLiteral(resourceName: "like_circle_icon"), selector: #selector(handleHeartButton))
  
  // MARK: -
  
  var cardViewModel: CardViewViewModel? {
    didSet {
      infoLabel.attributedText = cardViewModel?.attributedString
      pagingPhotosViewController.cardViewModel = cardViewModel
    }
  }
  
  // MARK: -
  
  private let pagingPhotosHeightPadding: CGFloat = 80
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    setupVisualEffectBlurView()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    guard let pagingPhotosView = pagingPhotosViewController.view else { return }
    
    // Setting the imageview frame in order to avoid using auto-layout
    // Auto-layout inside a scrollview does not always behave as expected
    pagingPhotosView.frame = CGRect(x: 0,
                                    y: 0,
                                    width: view.frame.width,
                                    height: view.frame.width + pagingPhotosHeightPadding)
  }
  
  // MARK: - Helper Methods
  
  private func setupView() {
    view.backgroundColor = .white
    
    // Configure scrollView
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    // Configure pagingPhotosView
    guard let pagingPhotosView = pagingPhotosViewController.view else { return }
    scrollView.addSubview(pagingPhotosView)
    
    
    let stackView = UIStackView(arrangedSubviews: [infoLabel, bioLabel])
    stackView.axis = .vertical
    stackView.spacing = 14
    
    // Configure infoLabel
    scrollView.addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.top.equalTo(pagingPhotosView.snp.bottom).offset(16)
    }
    
    // Configure dissmissButton
    scrollView.addSubview(dissmissButton)
    dissmissButton.snp.makeConstraints { make in
      make.width.height.equalTo(50)
      make.trailing.equalTo(view.snp.trailing).offset(-25)
      make.top.equalTo(pagingPhotosView.snp.bottom).offset(-25)
    }
    
    // Initialize bottonStackView
    let bottonStackView = UIStackView(arrangedSubviews: [cancelButton, starButton, heartButton])
    bottonStackView.spacing = -32
    bottonStackView.axis = .horizontal
    bottonStackView.distribution = .fillEqually
    
    // Configure bottonStackView
    scrollView.addSubview(bottonStackView)
    bottonStackView.snp.makeConstraints { make in
      make.height.equalTo(80)
      make.width.equalTo(300)
      make.centerX.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
    }
  }
  
  private func setupVisualEffectBlurView() {
    let blurEffect = UIBlurEffect(style: .regular)
    let visualEffectView = UIVisualEffectView(effect: blurEffect)
    
    
    view.addSubview(visualEffectView)
    visualEffectView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
    }
  }
  
  // MARK: - Actions
  
  @objc private func handleDismissButton() {
    // Dismiss View Controller
    dismiss(animated: true)
  }
  
  @objc private func handleCancelButton() {
    print("Cancel button tapped")
  }
  
  @objc private func handleStarButton() {
    print("Star button tapped")
  }
  
  @objc private func handleHeartButton() {
    print("Heart button tapped")
  }
}

// MARK: - UIScrollViewDelegate

extension ProfileDetailViewController: UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // Stretch Header Effect
    
    // Capture the scrollview y coordinate change
    // The contentOffset.y coordinates are in the negative.
    // We change it back to positive in order to make it easier to update the profileImage frame
    let changeY = -scrollView.contentOffset.y
    
    // Update profileImageView only if the scroll is pulling down
    if changeY > 0 {
      // Update the profileImageView frame
      // Set the x/y coordinates to -changeY to have the images shift to the left
      // The width/ height both add the frame width + changeY * 2 to make the image bigger as it is growing,
      // balancing out the shift to the left by the x/y
      let width = view.frame.width + changeY * 2
      
      guard let pagingPhotosView = pagingPhotosViewController.view else { return }

      pagingPhotosView.frame = CGRect(x: -changeY,
                                      y: -changeY,
                                      width: width,
                                      height: width + pagingPhotosHeightPadding)
    }
    
    // This solution below works too. But it does not scroll up at all:
    
    //    let coordinateY = scrollView.contentOffset.y
    //    let width = max(view.frame.width - coordinateY , view.frame.width)
    //    profileImageView.frame = CGRect(x: 0 , y: coordinateY , width: width, height: width)
    //    profileImageView.center.x = scrollView.center.x
  }
}
