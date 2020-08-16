//
//  UIButton+Extension.swift
//  TinderDemo
//
//  Created by Dennis Vera on 8/16/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

extension UIButton {
  
  func createButton(with image: UIImage, selector: Selector) -> UIButton {
    let button = UIButton(type: .system)
    let image = image.withRenderingMode(.alwaysOriginal)
    button.clipsToBounds = true
    button.setImage(image, for: .normal)
    button.contentMode = .scaleAspectFill
    button.addTarget(self, action: selector, for: .touchUpInside)
    return button
  }
}
