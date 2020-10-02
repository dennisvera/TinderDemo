//
//  SettingsViewModel.swift
//  TinderDemo
//
//  Created by Dennis Vera on 10/2/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import Foundation

final class SettingsViewModel {
  
  // MARK: - Properties
  
  var didSelectCancel: (() -> Void)?
  
  // MARK: - Public API
  
  func handleCancel() {
    didSelectCancel?()
  }
}
