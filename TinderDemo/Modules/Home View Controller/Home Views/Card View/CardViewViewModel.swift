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

class CardViewViewModel {
  
  // MARK: - Private Properties

  private var imageIndex = 0 {
    didSet {
      let imageUrl = imageNames[imageIndex]
      imageIndexObserver?(imageIndex, imageUrl)
    }
  }
  
  // MARK: - Public Properties
  
  let imageNames: [String]
  let attributedString: NSAttributedString
  let textAlignment: NSTextAlignment
  
  var imageIndexObserver: ((Int, String?) -> ())?
  
  // MARK: - Intilaization
  
  init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
    self.imageNames = imageNames
    self.attributedString = attributedString
    self.textAlignment = textAlignment
  }
  
  // MARK: - Helper Methods
  
  func moveToNextImage() {
    imageIndex = min(imageIndex + 1, imageNames.count - 1)
  }
  
  func moveToPreviousImage() {
    imageIndex = max(0, imageIndex - 1)
  }
}
