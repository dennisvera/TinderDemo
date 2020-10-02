//
//  SettingsCoordinator.swift
//  TinderDemo
//
//  Created by Dennis Vera on 10/1/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

final class SettingsCoordinator: Coordinator {
  
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
    showSettings()
  }
  
  func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    if viewController === initialViewController {
      didFinish?(self)
    }
  }
  
  // MARK: - Private Methods
  
  private func showSettings() {
    // Initialize Settings View Model
    let viewModel = SettingsViewModel()
    
    // Install Handlers
    viewModel.didSelectCancel = { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.handleCancel()
    }
    
    viewModel.didSelectSignOut = { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.handleCancel()
    }
    
    viewModel.didSelectSave = { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.handleCancel()
    }
    
    // Initialize Settings View Controller
    let settingsViewController = SettingsViewController(viewModel: viewModel)
    
    // Push Settings View Controller Onto Navigation Stack
    navigationController.pushViewController(settingsViewController, animated: true)
  }
  
  private func handleCancel() {
    // Pop Settings View Controller from Navigation Stack
    navigationController.popViewController(animated: true)
  }
}
