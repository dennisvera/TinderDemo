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
  
  // MARK: Initialization
  
  init(padding: CGFloat) {
    self.padding = padding
    super.init(frame: .zero)
    
    // Set Corner Radius
    layer.cornerRadius = 25
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overrides
  
  override var intrinsicContentSize: CGSize {
    return .init(width: 0, height: 50)
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: padding, dy: 0)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: padding, dy: 0)
  }
}
