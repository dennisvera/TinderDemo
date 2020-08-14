//
//  RegistrationViewModel.swift
//  TinderDemo
//
//  Created by Dennis Vera on 7/26/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import Foundation
import Firebase

final class RegistrationViewModel {
  
  // MARK: - TypeAlias
  
  typealias Completion = (Error?) -> ()
  
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
  
  // MARK: - Public Methods
  
  func registerUser(completion: @escaping Completion) {
    guard let email = email else { return }
    guard let password = password else { return }
    
    // Set the isRegistering observer to true
    isRegistering?(true)
    
    // Create user with email and password
    Auth.auth().createUser(withEmail: email, password: password) { [weak self] (_, error) in
      guard let strongSelf = self else { return }
      
      if let error = error {
        completion(error)
        return
      }
      
      strongSelf.uploadImageToFirebase(completion: completion)
    }
  }
  
  // MARK: Private Methods
  
  private func checkRegistrationIsValid() {
    let emailIsValid = email?.isEmpty == false
    let fullNameIsValid = fullName?.isEmpty == false
    let passwordIsValid = password?.isEmpty == false
    
    let isFormValid = fullNameIsValid && emailIsValid && passwordIsValid
    
    isRegistrationValidObserver?(isFormValid)
  }
  
  private func uploadImageToFirebase(completion: @escaping Completion) {
    // Upload user profile image after the user has successfully created an account
    let fileName = UUID().uuidString
    let reference = Storage.storage().reference(withPath: "/images/\(fileName)")
    let imageData = image?.jpegData(compressionQuality: 0.75) ?? Data()
    
    reference.putData(imageData, metadata: nil) { [weak self] (_, error) in
      guard let strongSelf = self else { return }
      
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
        
        // Save User Info to FireStore
        let imageUrl = url?.absoluteString ?? ""
        strongSelf.saveUserInfoToFireStore(with: imageUrl, completion: completion)
        
        // Set the isRegistering observer to false
        strongSelf.isRegistering?(false)
      }
    }
  }
  
  private func saveUserInfoToFireStore(with imageUrl: String, completion: @escaping Completion) {
    let uid = Auth.auth().currentUser?.uid ?? ""
    let documentData = [
      "uid": uid,
      "imageUrl1": imageUrl,
      "fullName": fullName ?? ""
    ]
    
    Firestore.firestore()
      .collection("users")
      .document(uid)
      .setData(documentData) { error in
        if let error = error {
          completion(error)
          return
        }
        
        completion(nil)
    }
  }
}
