//
//  FirestoreService.swift
//  TinderDemo
//
//  Created by Dennis Vera on 10/4/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import Foundation
import Firebase

/// Wrapper helper class to facilitate all requests to the Firestore database
final class FirestoreService {
  
  private let currentUserId = Auth.auth().currentUser?.uid
  
  func signOut() {
    try? Auth.auth().signOut()
  }
  
  func fetchCurrentUser(completion: @escaping (User?, Error?) -> ()) {
    guard let currentUserId = currentUserId else { return }
    
    Firestore.firestore()
      .collection(Strings.usersCollection)
      .document(currentUserId)
      .getDocument { (snapshot, error) in
        if let error = error {
          completion(nil, error)
          return
        }
        
        // Fetch current user
        guard let dictionary = snapshot?.data() else { return }
        let user = User(dictionary: dictionary)
        completion(user, nil)
    }
  }
  
  func saveCurrentUserSettingsInfo(with userId: String, documentData: [String: Any]) {
    Firestore.firestore()
      .collection(Strings.usersCollection)
      .document(userId)
      .setData(documentData) { error in
        if let error = error {
          print("Failed to save user's settings to Firestore:", error)
        }
    }
  }
}
