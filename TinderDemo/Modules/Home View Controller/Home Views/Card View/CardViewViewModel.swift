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
  let uid: String
  let imageUrls: [String]
  let attributedString: NSAttributedString
  let textAlignment: NSTextAlignment
    
  // MARK: - Intilaization
  
  init(uid: String, imageUrls: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
    self.uid = uid
    self.imageUrls = imageUrls
    self.textAlignment = textAlignment
    self.attributedString = attributedString
  }
}
