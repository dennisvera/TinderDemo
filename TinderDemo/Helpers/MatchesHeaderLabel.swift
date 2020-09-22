//
//  MatchesHeaderLabel.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/22/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

class MatchesHeaderLabel: UILabel {
  
  // MARK: - Override
  
  override func draw(_ rect: CGRect) {
    // Set the leading constraint to 20
    super.drawText(in: rect.insetBy(dx: 20, dy: 0))
  }
}
