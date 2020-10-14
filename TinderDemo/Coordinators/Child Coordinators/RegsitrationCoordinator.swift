//
//  RegsitrationCoordinator.swift
//  TinderDemo
//
//  Created by Dennis Vera on 10/13/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

final class RegsitrationCoordinator: Coordinator {
  
  // MARK: - Properties
  
  private var initialViewController: UIViewController?
  private let navigationController: UINavigationController
  
  // MARK: -
  
  var didFinish: ((Coordinator) -> Void)?
  
  // MARK: - Initialization
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    navigationController.navigationBar.isHidden = false
    
    // Set Initial View Controller
    self.initialViewController = navigationController.viewControllers.last
  }
  
  // MARK: - Deinitialization
  
  deinit {
    print("Settings Coordinator is Being Deallocated")
  }
  
  // MARK: - Public Methods
  
  func start() {
  }
  
}
