//
//  Coordinator.swift
//  TinderDemo
//
//  Created by Dennis Vera on 10/1/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
  
  // MARK: - Properties
  
  var didFinish: ((Coordinator) -> Void)? { get set }
  
  // MARK: - Helper Methods
  
  func start()
  
  // MARK: -
  
  func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool)
  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool)
}

extension Coordinator {
  
  func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {}
  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {}
}
