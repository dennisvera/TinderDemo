//
//  ViewController.swift
//  TinderDemo
//
//  Created by Dennis Vera on 7/9/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  // MARK: - Properties
  
  let redView: UIView = {
    let view = UIView()
    return view
  }()
  
  let blueView: UIView = {
    let view = UIView()
    return view
  }()

  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }

  // MARK: - Helper Methods
  
  private func setupViews() {
    
    let stackview = UIStackView(arrangedSubviews: [redView, blueView])
    
  }

}

