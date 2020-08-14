//
//  CustomTextField.swift
//  TinderDemo
//
//  Created by Dennis Vera on 7/22/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
  
  // MARK: - Properties
  
  let padding: CGFloat
  let height: CGFloat
  
  // MARK: Initialization
  
  init(padding: CGFloat, height: CGFloat) {
    self.padding = padding
    self.height = height
    
    super.init(frame: .zero)
    
    // Set Corner Radius
    layer.cornerRadius = height / 2
    
    // Set BackgroundColor
    backgroundColor = .white
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overrides
  
  override var intrinsicContentSize: CGSize {
    return .init(width: 0, height: height)
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: padding, dy: 0)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: padding, dy: 0)
  }
}
