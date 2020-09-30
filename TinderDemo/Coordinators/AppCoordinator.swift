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
    showHome()
  }
  
  // MARK: - Helper Methods
  
  private func showHome() {
    // Initialize Home View Model
    let viewModel = HomeViewModel()
    
    // Configure View Model
    viewModel.didShowMessages = { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.showMessages()
    }
    
    // Initialize Homes View Controller
    let homeViewController = HomeViewController(homeViewModel: viewModel)
    
    // Push Homes View Controller Onto Navigation Stack
    navigationController.pushViewController(homeViewController, animated: true)
  }
  
  private func showMessages() {
    // Initialize Messages View Controller
    let messagesViewController = MessagesViewController()
    
    // Push Messages View Controller Onto Navigation Stack
    navigationController.pushViewController(messagesViewController, animated: true)
  }
}
