//
//  PhotoViewController.swift
//  TinderDemo
//
//  Created by Dennis Vera on 8/16/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit

final class PhotoViewController: UIViewController {
  
  // MARK: - Properties
  
  private let profileImageView = UIImageView()
  
  // MARK: - Initialization
  
  init(image: UIImage) {
    self.profileImageView.image = image
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
  }
  
  // MARK: - Helper Methods
  
  private func setupView() {
    // Copnfigure profileImageView
    profileImageView.clipsToBounds = true
    profileImageView.contentMode = .scaleAspectFill
    
    view.addSubview(profileImageView)
    profileImageView.snp.makeConstraints { make in
      make.height.equalTo(view.frame.width)
      make.top.leading.trailing.equalToSuperview()
    }
  }
}
