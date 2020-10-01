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
  
  // MARK: - Home View Controller
  
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
  
  // MARK: - Messages View Controller
  
  private func showMessages() {
    // Initialize Messages View Model
    let viewModel = MessagesViewModel()

    // Configure View Model
    viewModel.didSelectBackButton = { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.dismissMessages()
    }

    // Initialize Messages View Controller
    let messagesViewController = MessagesViewController(viewModel: viewModel)
    
    // Configure Messages View Controller
    messagesViewController.didSelectMessage = { [weak self] user in
      guard let strongSelf = self else { return }
      strongSelf.showChat(with: user)
    }

    // Push Messages View Controller Onto Navigation Stack
    navigationController.pushViewController(messagesViewController, animated: true)
  }
  
  private func dismissMessages() {
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
