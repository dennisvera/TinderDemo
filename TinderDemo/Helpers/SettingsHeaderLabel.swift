//
//  SettingsHeaderLabel.swift
//  TinderDemo
//
//  Created by Dennis Vera on 8/12/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

class SettingsHeaderLabel: UILabel {
  
  // MARK: - Override
  
  override func draw(_ rect: CGRect) {
    // Set the leading constraint to 16
    super.drawText(in: rect.insetBy(dx: 16, dy: 0))
  }
}
