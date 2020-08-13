//
//  AgeRangeLabel.swift
//  TinderDemo
//
//  Created by Dennis Vera on 8/13/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

class AgeRangeLabel: UILabel {
  
  // MARK: - Overrides
  
  override var intrinsicContentSize: CGSize {
    return .init(width: 80, height: 0)
  }
}
