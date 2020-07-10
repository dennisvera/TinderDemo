//
//  ViewController.swift
//  TinderDemo
//
//  Created by Dennis Vera on 7/9/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
  
  // MARK: - Properties
  
  private let contentView: UIView = {
    let view = UIView()
    view.backgroundColor = .blue
    return view
  }()
  
  let topStackView = TopNavigationStackView()
  let bottomStackView = HomeBottomControlStackView()
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
  }
  
  // MARK: - Helper Methods
  
  private func setupViews() {
    view.backgroundColor = .white
    
    let mainStackView = UIStackView(arrangedSubviews: [topStackView, contentView, bottomStackView])
    mainStackView.axis = .vertical
    
    view.addSubview(mainStackView)
    mainStackView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
  }
}

