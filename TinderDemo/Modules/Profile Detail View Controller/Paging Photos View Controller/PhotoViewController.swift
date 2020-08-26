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
  
  private let profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  // MARK: - Initialization
  
  init(imageUrl: String) {
    if let imageUrl = URL(string: imageUrl) {
      self.profileImageView.sd_setImage(with: imageUrl)
    }
    
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
    view.addSubview(profileImageView)
    profileImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
