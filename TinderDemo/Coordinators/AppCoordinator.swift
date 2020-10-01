//
//  AppCoordinator.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/29/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

final class AppCoordinator: NSObject {
  
  // MARK: - Properties
  
  private let navigationController = UINavigationController()
  
  // MARK: -
  
  private var childCoordinators: [Coordinator] = []
  
  // MARK: - Public API
  
  var rootViewController: UIViewController {
    return navigationController
  }
  
  // MARK: - Public Methods
  
  func start() {
    // Set Navigation Controller Delegate
    navigationController.delegate = self
    
    showHome()
  }
  
  // MARK: - Helper Methods
  
  private func pushCoordinator(_ coordinator: Coordinator) {
    // Install Handler
    coordinator.didFinish = { [weak self] coordinator in
      self?.popCoordinator(coordinator)
    }
    
    // Start Coordinator
    coordinator.start()
    
    // Append Coordinator
    childCoordinators.append(coordinator)
  }
  
  private func popCoordinator(_ coordinator: Coordinator) {
    if let index = childCoordinators.firstIndex(where: { $0 === coordinator  }) {
      childCoordinators.remove(at: index)
    }
  }
  
  // MARK: - Home View Controller
  
  private func showHome() {
    // Initialize Home Coordinator
    let homeCoordinator = HomeCoordinator(navigationController: navigationController)
    
    // Install Handler
    homeCoordinator.didSelectMessage = { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.showMessages()
    }
    
    // Push Home Coordinator
    pushCoordinator(homeCoordinator)
  }
  
  // MARK: - Messages View Controller
  
  private func showMessages() {
    // Initialize Messages Coordinator
    let messagesCoordinator = MesagesCoordinator(navigationController: navigationController)
    
    // Push Message Coordinator
    pushCoordinator(messagesCoordinator)
  }
}

// MARK: - UINavigation Controller Delegate

extension AppCoordinator: UINavigationControllerDelegate {
  
  // MARK: - Helper Methods
  
  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    childCoordinators.forEach { coordinator in
      coordinator.navigationController(navigationController, willShow: viewController, animated: true)
    }
  }
  
  func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    childCoordinators.forEach { coordinator in
      coordinator.navigationController(navigationController, didShow: viewController, animated: true)
    }
  }
}
