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
  
  private let firestoreService = FirestoreService()

  // MARK: -
  
  var didSelectMessage: (() -> Void)?
  var didSelectSettings: (() -> Void)?
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
    let viewModel = HomeViewModel(firestoreService: firestoreService)
    
    // Install Handler
    viewModel.didShowMessages = { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.didSelectMessage?()
    }
    
    viewModel.didShowSettings = { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.didSelectSettings?()
    }
    
    // Initialize Home View Controller
    let homeViewController = HomeViewController(homeViewModel: viewModel, firestoreService: firestoreService)
    
    // Push Home View Controller Onto Navigation Stack
    navigationController.pushViewController(homeViewController, animated: true)
  }
}
