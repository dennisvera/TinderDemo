//
//  SendMessageButton.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/14/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

class SendMessageButton: UIButton {
  
  // MARK: - Overrides
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    // Configure Gradient Layer
    let gradientLayer = CAGradientLayer()
    let leftcolor = #colorLiteral(red: 1, green: 0.01176470588, blue: 0.4470588235, alpha: 1)
    let rightColor = #colorLiteral(red: 1, green: 0.3921568627, blue: 0.3176470588, alpha: 1)
    gradientLayer.frame = rect
    gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
    gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
    gradientLayer.colors = [leftcolor.cgColor, rightColor.cgColor]
    
    clipsToBounds = true
    layer.cornerRadius = rect.height / 2
    layer.insertSublayer(gradientLayer, at: 0)
  }
}
