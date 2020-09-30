//
//  HomeViewModel.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/30/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import Foundation

final class HomeViewModel {
  
  // MARK: - Properties
  
  var didShowMessages: (() -> Void)?
  
  // MARK: - Public API
  
  func showMessages() {
    didShowMessages?()
  }
}
