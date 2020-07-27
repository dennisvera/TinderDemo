//
//  RegistrationViewModel.swift
//  TinderDemo
//
//  Created by Dennis Vera on 7/26/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import Foundation
import Firebase

class RegistrationViewModel {
  
  // MARK: - Properties
  
  var fullName: String? {
    didSet {
      checkRegistrationIsValid()
    }
  }
  
  var email: String? {
    didSet {
      checkRegistrationIsValid()
    }
  }
  
  var password: String? {
    didSet {
      checkRegistrationIsValid()
    }
  }
  
  var image: UIImage? {
    didSet {
      imageObserver?(image)
    }
  }
  
  // MARK: - Observers
  
  var isRegistering: ((Bool) -> ())?
  var imageObserver: ((UIImage?) -> ())?
  var isRegistrationValidObserver: ((Bool) -> ())?
  
  // MARK: Private Methods
  
  private func checkRegistrationIsValid() {
    let emailIsValid = email?.isEmpty == false
    let fullNameIsValid = fullName?.isEmpty == false
    let passwordIsValid = password?.isEmpty == false
    
    let isFormValid = fullNameIsValid && emailIsValid && passwordIsValid
    
    isRegistrationValidObserver?(isFormValid)
  }
  
  // MARK: - Public Methods
  
  func performRagistration(completion: @escaping (Error?) -> ()) {
    guard let email = email else { return }
    guard let password = password else { return }
    
    // Set the isRegistering observer to true
    isRegistering?(true)
    
    // Create user with email and password
    Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
      guard let strongSelf = self else { return }
      
      if let error = error {
        completion(error)
        return
      }
      
      // Upload user profile image after the user has successfully created an account
      let fileName = UUID().uuidString
      let reference = Storage.storage().reference(withPath: "/images/\(fileName)")
      let imageData = strongSelf.image?.jpegData(compressionQuality: 0.75) ?? Data()
      
      reference.putData(imageData, metadata: nil) { (_, error) in
        if let error = error {
          completion(error)
          return
        }
        
        // Downnload Firebase image url
        reference.downloadURL { (url, error) in
          if let error = error {
            completion(error)
            return
          }
          
          // Set the isRegistering observer to false
          strongSelf.isRegistering?(false)
        }
      }
    }
  }
}
