//
//  User.swift
//  TinderDemo
//
//  Created by Dennis Vera on 7/11/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

struct User {
  
  // MARK: - Properties
  
  let name: String
  let age: Int
  let profession: String
  let imageName: String
  
  func toCardViewModel() -> CardViewViewModel {
    let attributedText = NSMutableAttributedString(string: name,
                                                   attributes: [.font: UIFont.systemFont(ofSize: 34,
                                                                                         weight: .heavy)])
    attributedText.append(NSAttributedString(string: " \(age)",
      attributes: [.font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
    
    attributedText.append(NSAttributedString(string: "\n\(profession)",
      attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
    
    return CardViewViewModel(imageName: imageName, attributedString: attributedText, textAlignment: .left)
    
    
    
  }
}
