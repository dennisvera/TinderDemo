//
//  Firebase+Helpers.swift
//  TinderDemo
//
//  Created by Dennis Vera on 8/13/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import Firebase

extension Firestore {
  
  func fetchCurrentUser(completion: @escaping (User?, Error?) -> ()) {
    guard let userUid = Auth.auth().currentUser?.uid else { return }
    
    Firestore.firestore()
      .collection("users")
      .document(userUid)
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
}
