//
//  SettingsTextField.swift
//  TinderDemo
//
//  Created by Dennis Vera on 8/12/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

class SettingsTextField: UITextField {
  
  // MARK: - Overrides
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    // Set the bounds leading constraint to 24
    return bounds.insetBy(dx: 24, dy: 0)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    // Set the bounds editing leading constraint to 24
    return bounds.insetBy(dx: 24, dy: 0)
  }
  
  override var intrinsicContentSize: CGSize {
    // Set the height constraint to 44
    return .init(width: 0, height: 44)
  }
}
