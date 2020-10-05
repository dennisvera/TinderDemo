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
  
  // MARK: - Properties
  
  private var listener: ListenerRegistration?
  private let firestore = Firestore.firestore()
  private let currentUserId = Auth.auth().currentUser?.uid
  
  // MARK: - Public Methods
  
  func signOut() {
    try? Auth.auth().signOut()
  }
  
  func removeListener() {
    listener?.remove()
  }
  
  func fetchCurrentUser(completion: @escaping (User?, Error?) -> Void) {
    guard let currentUserId = currentUserId else { return }
    
    firestore
      .collection(Strings.usersCollection)
      .document(currentUserId)
      .getDocument { (snapshot, error) in
        if let error = error {
          completion(nil, error)
          return
        }
        
        // Fetch Current User
        guard let dictionary = snapshot?.data() else { return }
        let user = User(dictionary: dictionary)
        completion(user, nil)
    }
  }
  
  func saveCurrentUserSettingsInfo(with userId: String, documentData: [String: Any]) {
    firestore
      .collection(Strings.usersCollection)
      .document(userId)
      .setData(documentData) { error in
        if let error = error {
          print(Strings.failedToSaveUserSettingsInfo, error)
          return
        }
    }
  }
  
  func saveImage(with uploadData: Data, completion: @escaping (URL?, Error?) -> Void) {
    // Store Image to FireBase Storage
    let fileName = UUID().uuidString
    let reference = Storage.storage().reference(withPath: Strings.imagePath + "\(fileName)")
    
    reference.putData(uploadData, metadata: nil) { _, error in
      if let error = error {
        completion(nil, error)
      }
      
      // Retrieve the Image download URL
      reference.downloadURL { (url, error) in
        completion(url, error)
        
        if let error = error {
          print(Strings.failedToFetchImageUrl, error)
          return
        }
      }
    }
  }
  
  func fetchMessages(completion: @escaping ([String: Any]?, Error?) -> Void) {
    guard let currentUserId = currentUserId else { return }
    
    let query = firestore
      .collection(Strings.matchesMessagesCollection)
      .document(currentUserId)
      .collection(Strings.recentMessagesCollection)
    
    listener = query.addSnapshotListener { querySnapshot, error in
      if let error = error {
        completion(nil, error)
      }
      
      querySnapshot?.documentChanges.forEach({ change in
        if change.type == .added || change.type == .modified {
          let dictionary = change.document.data()
          completion(dictionary, nil)
        }
      })
    }
  }
}
