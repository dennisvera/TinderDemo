//
//  AppCoordinator.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/29/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

final class AppCoordinator {
  
  // MARK: - Properties
  
  private let navigationController = UINavigationController()
  
  // MARK: - Public API
  
  var rootViewController: UIViewController {
    return navigationController
  }
  
  // MARK: -
  
  func start() {
    showHomeViewController()
  }
  
  // MARK: - Helper Methods
  
  private func showHomeViewController() {
    let homeViewController = HomeViewController()
    
    navigationController.present(homeViewController, animated: true)
  }
}
