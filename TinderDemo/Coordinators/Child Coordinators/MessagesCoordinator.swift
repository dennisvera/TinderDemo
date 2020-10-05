//
//  MessagesCoordinator.swift
//  TinderDemo
//
//  Created by Dennis Vera on 10/1/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

final class MesagesCoordinator: Coordinator {
  
  // MARK: - Properties
  
  private var initialViewController: UIViewController?
  private let navigationController: UINavigationController
  
  // MARK: -
  
  private let firestoreService = FirestoreService()
  
  // MARK: -
  
  var didFinish: ((Coordinator) -> Void)?
  
  // MARK: - Initialization
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    
    // Set Initial View Controller
    self.initialViewController = navigationController.viewControllers.last
  }
  
  // MARK: - Deinitialization
  
  deinit {
    print("Messages Coordinator is Being Deallocated")
  }
  
  // MARK: - Public Methods
  
  func start() {
    showMessages()
  }
  
  func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    if viewController === initialViewController {
      didFinish?(self)
    }
  }
  
  // MARK: - Private Methods
  
  private func showMessages() {
    // Initialize Messages View Model
    let viewModel = MessagesViewModel(firestoreService: firestoreService)
    
    // Install Handler
    viewModel.didSelectBackButton = { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.hideMessages()
    }
    
    // Initialize Messages View Controller
    let messagesViewController = MessagesViewController(viewModel: viewModel)
    
    // Install Handler
    messagesViewController.didSelectMessage = { [weak self] user in
      guard let strongSelf = self else { return }
      strongSelf.showChat(with: user)
    }
    
    // Push Messages View Controller Onto Navigation Stack
    navigationController.pushViewController(messagesViewController, animated: true)
  }
  
  private func hideMessages() {
    // Pop Messages View Controller from Navigation Stack
    navigationController.popViewController(animated: true)
  }
  
  // MARK: - Chat Collection View Controller
  
  private func showChat(with matchedUser: MatchedUser) {
    // Initialize Chat Collection View Controller
    let chatCollectionViewController = ChatCollectionViewController(matchedUser: matchedUser)
    
    // Push Chat Collection View Controller Onto Navigation Stack
    navigationController.pushViewController(chatCollectionViewController, animated: true)
  }
}
