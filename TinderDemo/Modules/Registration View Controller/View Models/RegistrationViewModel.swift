//
//  RegistrationViewModel.swift
//  TinderDemo
//
//  Created by Dennis Vera on 7/26/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

final class RegistrationViewModel {
  
  // MARK: - TypeAlias
  
  typealias Completion = (Error?) -> ()
  
  // MARK: - Properties
  
  private let firestoreService: FirestoreService

  // MARK: -
  
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
  
  // MARK: - Initialization
  
  init(firestoreService: FirestoreService) {
    self.firestoreService = firestoreService
  }
  
  // MARK: - Public Methods
  
  func checkRegistrationIsValid() {
    let emailIsValid = email?.isEmpty == false
    let fullNameIsValid = fullName?.isEmpty == false
    let passwordIsValid = password?.isEmpty == false
    let imageIsValid = image != nil
    
    let isFormValid = fullNameIsValid && emailIsValid && passwordIsValid && imageIsValid
    
    isRegistrationValidObserver?(isFormValid)
  }
  
  func registerUser(completion: @escaping Completion) {
    guard let email = email, let password = password else { return }
    
    // Set the isRegistering observer to true
    isRegistering?(true)
    
    // Create user with email and password
    firestoreService.createUser(with: email, password: password) { [weak self] error in
      guard let strongSelf = self else { return }
      
      if let error = error {
        completion(error)
      }
      
      strongSelf.uploadImageToFirebase(completion: completion)
    }
  }
  
  // MARK: Private Methods
  
  private func uploadImageToFirebase(completion: @escaping Completion) {
    let imageData = image?.jpegData(compressionQuality: 0.75) ?? Data()
    
    firestoreService.uploadImageToFirebase(with: imageData) { [weak self] (imageUrl, error) in
      guard let strongSelf = self else { return }
      
      if let error = error {
        completion(error)
      }
      
      // Save User Info to FireStore
      let imageUrl = imageUrl?.absoluteString ?? ""
      strongSelf.saveUserInfoToFireStore(with: imageUrl, completion: completion)
    }
  }
  
  private func saveUserInfoToFireStore(with imageUrl: String, completion: @escaping Completion) {
    firestoreService.saveUserInfoToFireStore(with: fullName, imageUrl: imageUrl) { [weak self] error in
      guard let strongSelf = self else { return }
      
      if let error = error {
        completion(error)
      }
      
      // Set the isRegistering observer to false
      strongSelf.isRegistering?(false)
      
      completion(nil)
    }
  }
}
