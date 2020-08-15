//
//  LoginViewModel.swift
//  TinderDemo
//
//  Created by Dennis Vera on 8/13/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import Foundation
import Firebase

final class LoginViewModel {
  
  // MARK: - Properties
  
  var email: String? {
    didSet {
      checkFormValidity()
    }
  }
  
  var password: String? {
    didSet {
      checkFormValidity()
    }
  }
  
  // MARK: - Observers
  
  var isLoggingInObserver: ((Bool) -> ())?
  var isFormValidObserver: ((Bool) -> ())?
  
  // MARK: - Private Methods
  
  private func checkFormValidity() {
    let isValid = email?.isEmpty == false && password?.isEmpty == false
    isFormValidObserver?(isValid)
  }
  
  // MARK: - Public Methods
  
  func performLogin(_ completion: @escaping (Error?) -> ()) {
    isLoggingInObserver?(true)

    guard let email = email, let password = password else { return }
    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
      if let error = error {
        completion(error)
      }
    }
  }
}