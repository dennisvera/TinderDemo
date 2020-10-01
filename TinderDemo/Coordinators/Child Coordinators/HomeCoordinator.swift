//
//  HomeCoordinator.swift
//  TinderDemo
//
//  Created by Dennis Vera on 10/1/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

final class HomeCoordinator: Coordinator {
  
  // MARK: - Properties
  
  private var initialViewController: UIViewController?
  private let navigationController: UINavigationController
  
  // MARK: -
  
  var didSelectMessage: (() -> Void)?
  var didFinish: ((Coordinator) -> Void)?
  
  // MARK: - Initialization
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    
    // Set Initial View Controller
    self.initialViewController = navigationController.viewControllers.last
  }
  
  // MARK: - Deinitialization
  
  deinit {
    print("Home Coordinator is Being Deallocated")
  }
  
  // MARK: - Public Methods
  
  func start() {
    showHome()
  }
  
  func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    if viewController === initialViewController {
      didFinish?(self)
    }
  }
  
  // MARK: - Private Methods
  
  private func showHome() {
    // Initialize Home View Model
    let viewModel = HomeViewModel()
    
    // Install Handler
    viewModel.didShowMessages = { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.didSelectMessage?()
    }
    
    // Initialize Home View Controller
    let homeViewController = HomeViewController(homeViewModel: viewModel)
    
    // Push Home View Controller Onto Navigation Stack
    navigationController.pushViewController(homeViewController, animated: true)
  }
}
