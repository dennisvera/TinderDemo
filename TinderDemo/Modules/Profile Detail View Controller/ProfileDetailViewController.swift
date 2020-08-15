//
//  ProfileDetailViewController.swift
//  TinderDemo
//
//  Created by Dennis Vera on 8/15/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit

final class ProfileDetailViewController: UIViewController {
  
  // MARK: - Properties
  
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.delegate = self
    scrollView.alwaysBounceVertical = true
    scrollView.backgroundColor = .systemTeal
    scrollView.contentInsetAdjustmentBehavior = .never
    return scrollView
  }()
  
  private let profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "alyssa1")
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleToFill
    return imageView
  }()
  
  private let infoLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textColor = .white
    label.text = "User Name 30\nDoctor\nBio text ..."
    label.font = UIFont.boldSystemFont(ofSize: 20)
    return label
  }()
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
  }
  
  // MARK: - Helper Methods
  
  private func setupView() {
    view.backgroundColor = .white
    
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    
    // Configure scrollView
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    // Configure profileImageView
    scrollView.addSubview(profileImageView)
    // Setting the imageview frame in ordero avoid using auto-layout
    // Auto-layout inside a scrollview does not always behave as expected
    profileImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
    
    // Configure infoLabel
    scrollView.addSubview(infoLabel)
    infoLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.top.equalTo(profileImageView.snp.bottom).offset(16)
    }
  }
  
  
  // MARK: - Actions
  
  @objc private func handleTapDismiss() {
    dismiss(animated: true)
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
      profileImageView.frame = CGRect(x: -changeY,
                                      y: -changeY,
                                      width: width,
                                      height: width)
    }
    
  }
}
