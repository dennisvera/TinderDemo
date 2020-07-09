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

  let blueView: UIView = {
    let view = UIView()
    view.backgroundColor = .blue
    return view
  }()

  let yellowView: UIView = {
    let view = UIView()
    view.backgroundColor = .yellow
    view.heightAnchor.constraint(equalToConstant: 120).isActive = true
    return view
  }()

  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
  }

  // MARK: - Helper Methods
  
  private func setupViews() {
    view.backgroundColor = .white
    
    let topSubviews = [UIColor.gray, UIColor.darkGray, UIColor.black].map { color -> UIView in
      let view = UIView()
      view.backgroundColor = color
      return view
    }
    
    let topStackView = UIStackView(arrangedSubviews: topSubviews)
    topStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    topStackView.distribution = .fillEqually
    
    let mainStackView = UIStackView(arrangedSubviews: [topStackView, blueView, yellowView])
    mainStackView.axis = .vertical
    
    view.addSubview(mainStackView)
    mainStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}

