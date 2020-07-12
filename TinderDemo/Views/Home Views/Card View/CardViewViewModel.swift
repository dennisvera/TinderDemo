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

struct CardViewViewModel {

  // MARK: - Properties
  
  let imageNames: [String]
  let attributedString: NSAttributedString
  let textAlignment: NSTextAlignment
}
