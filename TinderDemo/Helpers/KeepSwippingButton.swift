//
//  KeepSwippingButton.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/14/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

class KeepSwippingButton: UIButton {
  
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
    
    // Create a mask to cover the inside of the button, creating a gradient border
    let maskLayer = CAShapeLayer()
    let maskPath = CGMutablePath()
    let cornerRadius = rect.height / 2
    
    maskPath.addPath(UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath)
    
    // Hide-clear the center of the button
    maskPath.addPath(UIBezierPath(roundedRect: rect.insetBy(dx: 2, dy: 2), cornerRadius: cornerRadius).cgPath)
    
    maskLayer.path = maskPath
    maskLayer.fillRule = .evenOdd
    
    gradientLayer.mask = maskLayer
    
    clipsToBounds = true
    layer.cornerRadius = cornerRadius
    layer.insertSublayer(gradientLayer, at: 0)
  }
}
