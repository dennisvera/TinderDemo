//
//  Advertiser.swift
//  TinderDemo
//
//  Created by Dennis Vera on 7/12/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

struct Advertiser: CardViewViewModelProtocol {
  
  // MARK: - Properties
  
  let title: String
  let brandName: String
  let posterImageName: String
  
  // MARK: - Helper Methods
  
  func toCardViewModel() -> CardViewViewModel {
    let attributedText = NSMutableAttributedString(string: title,
                                                   attributes: [.font: UIFont.systemFont(ofSize: 34,
                                                                                         weight: .heavy)])
    
    attributedText.append(NSAttributedString(string: "\n\(brandName)",
      attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
    
    return CardViewViewModel(imageName: posterImageName, attributedString: attributedText, textAlignment: .center)
  }
}
