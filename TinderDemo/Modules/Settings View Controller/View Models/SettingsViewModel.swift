//
//  SettingsViewModel.swift
//  TinderDemo
//
//  Created by Dennis Vera on 10/2/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

final class SettingsViewModel {
  
  // MARK: - Properties
  
  var user: User?
  
  // MARK: -
  
  var didSelectSave: (() -> Void)?
  var didSelectCancel: (() -> Void)?
  var didSelectSignOut: (() -> Void)?
  
  // MARK: - Public API
  
  func handleCancel() {
    didSelectCancel?()
  }
  
  func handleSignOut() {
    try? Auth.auth().signOut()
    
    didSelectSignOut?()
  }
  
  func fetchCurrentUser(completion: @escaping () -> Void) {
    Firestore.firestore().fetchCurrentUser { [weak self] (user, error) in
      guard let strongSelf = self else { return }
      
      if let error = error {
        print("Failed to Fetch User:", error)
        return
      }
      
      // Set user
      strongSelf.user = user
      
      completion()
    }
  }
  
  func handleSave(completion: @escaping () -> Void) {
    // Save users info to Firestore
    guard let userUid = Auth.auth().currentUser?.uid else { return }
    
    let documentData: [String: Any] = [
      "uid" : userUid,
      "age" : user?.age ?? -1,
      "bio" : user?.bio ?? "",
      "fullName" : user?.name ?? "",
      "imageUrl1" : user?.imageUrl1 ?? "",
      "imageUrl2" : user?.imageUrl2 ?? "",
      "imageUrl3" : user?.imageUrl3 ?? "",
      "profession" : user?.profession ?? "",
      "minSeekingAge" : user?.minSeekingAge ?? -1,
      "maxSeekingAge" : user?.maxSeekingAge ?? -1
    ]
    
    Firestore.firestore()
      .collection("users")
      .document(userUid)
      .setData(documentData) { [weak self] error in
        guard let strongSelf = self else { return }
        
        if let error = error {
          print("Failed to save user's settings to Firestore:", error)
        }
        
        print("Saved Settings User Info")
        
        completion()
        strongSelf.didSelectSave?()
    }
  }
}
