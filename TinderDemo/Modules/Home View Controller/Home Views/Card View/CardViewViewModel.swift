//
//  CardViewViewModel.swift
//  TinderDemo
//
//  Created by Dennis Vera on 7/11/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

protocol CardViewViewModelProtocol {
  
  func toCardViewModel() -> CardViewViewModel
}

final class CardViewViewModel {
  
  // MARK: - Public Properties
  
  let imageUrls: [String]
  let attributedString: NSAttributedString
  let textAlignment: NSTextAlignment
    
  // MARK: - Intilaization
  
  init(imageUrls: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
    self.imageUrls = imageUrls
    self.attributedString = attributedString
    self.textAlignment = textAlignment
  }
}
