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
        }
        
        // Fetch Current User
        guard let dictionary = snapshot?.data() else { return }
        let user = User(dictionary: dictionary)
        completion(user, nil)
    }
  }
  
  // MARK: - Registration Helper Methods
  
  func createUser(with email: String, password: String, completion: @escaping (Error?) -> Void) {
    // Create New User With Email and Password
    Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
      completion(error)
    }
  }
  
  func uploadImageToFirebase(with imageData: Data, completion: @escaping ((URL?, Error?) -> Void)) {
    // Upload user profile image after the user has successfully created an account
    let fileName = UUID().uuidString
    let reference = Storage.storage().reference(withPath: "/images/\(fileName)")
    
    reference.putData(imageData, metadata: nil) { (_, error) in
      completion(nil, error)
      
      // Downnload Firebase image url
      reference.downloadURL { (imageUrl, error) in
        if let imageUrl = imageUrl {
          completion(imageUrl, error)
        }
      }
    }
  }
  
  // MARK: - Login Helper Methods
  
  func signIn(with email: String, password: String, completion: @escaping (Error?) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
      completion(error)
    }
  }
  
  func saveUserInfoToFireStore(with fullName: String?, imageUrl: String, completion: @escaping ((Error?) -> Void)) {
    let uid = Auth.auth().currentUser?.uid ?? ""
    
    let documentData: [String: Any] = [
      Strings.age: 18,
      Strings.uid: uid,
      Strings.imageUrl1: imageUrl,
      Strings.fullName: fullName ?? "",
      Strings.minSeekingAge: SettingsViewController.defaultMinSeekingAge,
      Strings.maxSeekingAge: SettingsViewController.defaultMaxSeekingAge
    ]
    
    firestore
      .collection(Strings.usersCollection)
      .document(uid)
      .setData(documentData) { error in
        
        if let error = error {
          completion(error)
          return
        }
        
        completion(nil)
    }
  }
  
  // MARK: - Home Helper Methods
  
  func fetchSwipedUsers(completion: @escaping (Bool, Error?) -> Void) {
    guard let currentUserId = currentUserId else { return }
    
    firestore
      .collection(Strings.swipesCollection)
      .document(currentUserId)
      .getDocument { (_, error) in
        if let error = error {
          completion(false, error)
        }
        
        completion(true, nil)
    }
  }
  
  // TO DO
  func fetchUsers(with minSeekingAge: Int, maxSeekingAge: Int, completion: @escaping ([User]?, Error?) -> Void) {
  }
    
  func saveSwipeToFireStore(with cardUid: String,
                            didLike: Int,
                            completion: @escaping (Int?, Error?) -> Void) {
    guard let currentUserId = currentUserId else { return }
    let documentData = [cardUid: didLike]
    
    firestore
      .collection(Strings.swipesCollection)
      .document(currentUserId)
      .getDocument { [weak self] (snapshot, error) in
        if let error = error {
          completion(nil, error)
        }
        
        if snapshot?.exists == true {
          Firestore.firestore()
            .collection(Strings.swipesCollection)
            .document(currentUserId)
            .updateData(documentData) { error in
              
              if let error = error {
                completion(nil, error)
              }
              
              if didLike == 1 {
                completion(didLike, nil)
              }
          }
        } else {
          self?.saveSwipeToFireStoreHelper(with: cardUid, didLike: didLike) { (didLike, error) in
            if let error = error {
              print(Strings.failedToSaveSwipedData, error)
              return
            }
            
            if didLike == 1 {
              completion(didLike, nil)
            }
          }
        }
    }
  }
  
  private func saveSwipeToFireStoreHelper(with cardUid: String,
                                          didLike: Int,
                                          completion: @escaping (Int?, Error?) -> Void) {
    guard let currentUserId = currentUserId else { return }
    let documentData = [cardUid: didLike]
    
    firestore
      .collection(Strings.swipesCollection)
      .document(currentUserId)
      .setData(documentData) { error in
        
        if let error = error {
          completion(nil, error)
        }
        
        if didLike == 1 {
          completion(didLike, nil)
        }
    }
  }

  func checkIfMatchExists(cardUid: String, completion: @escaping (Bool, Error?) -> Void) {
    firestore
      .collection(Strings.swipesCollection)
      .document(cardUid)
      .getDocument { snapshot, error in
        if let error = error {
          completion(false, error)
        }
        
        guard let data = snapshot?.data() else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let hasMatched = data[uid] as? Int == 1
        
        completion(hasMatched, nil)
    }
  }
  
  func saveMatchedCurrentUserInfo(with user: User?, cardUid: String, completion: @escaping (Error?) -> Void) {
    guard let currentUserId = currentUserId else { return }
    
    // Get the Current User Name and Image Url
    guard let currentUser = user else { return }
    let currentUserData: [String: Any] = [Strings.uid: currentUser.uid ?? "",
                                          Strings.name: currentUser.name ?? "",
                                          Strings.profileImageUrl: currentUser.imageUrl1 ?? "",
                                          Strings.timestamp: Timestamp(date: Date())]
    
    // Save the Current User Info to FireStore
    firestore
      .collection(Strings.matchesMessagesCollection)
      .document(cardUid)
      .collection(Strings.matchesCollection)
      .document(currentUserId)
      .setData(currentUserData) { error in
        if let error = error {
          completion(error)
        }
    }
  }
  
  func saveMatchedUserInfo(with users: [String: User], cardUid: String, completion: @escaping (Error?) -> Void) {
    guard let currentUserId = currentUserId else { return }
    
    // Get Mathed User Info
    guard let matchedUser = users[cardUid] else { return }
    let matchedUserdata: [String: Any] = [Strings.uid: matchedUser.uid ?? "",
                                          Strings.name: matchedUser.name ?? "",
                                          Strings.profileImageUrl: matchedUser.imageUrl1 ?? "",
                                          Strings.timestamp: Timestamp(date: Date())]
    
    // Save Matched User Info to FireStore
    firestore
      .collection(Strings.matchesMessagesCollection)
      .document(currentUserId)
      .collection(Strings.matchesCollection)
      .document(cardUid)
      .setData(matchedUserdata) { error in
        
        if let error = error {
          completion(error)
        }
    }
  }
  
  // MARK: - Settings Helper Methods
  
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
  
  // MARK: - Messages Helper Methods
  
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
  
  // MARK: - Chat Helper Methods
  
  func fetchChatMessages(with matchedUserId: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
    guard let currentUserId = currentUserId else { return }
    
    let query = firestore
      .collection(Strings.matchesMessagesCollection)
      .document(currentUserId)
      .collection(matchedUserId)
      .order(by: Strings.timestamp)
    
    listener = query.addSnapshotListener { querySnapshot, error in
      if let error = error {
        completion(nil, error)
      }
      
      querySnapshot?.documentChanges.forEach({ change in
        if change.type == .added {
          let dictionary = change.document.data()
          completion(dictionary, nil)
        }
      })
    }
  }
  
  func saveCurrentUserAndMatchedUserChatMesages(with matchedUser: MatchedUser,
                             text: String,
                             completion: @escaping (Error?) -> Void) {
    guard let currentUserId = currentUserId else { return }
    
    // Save Chat Messages to Current User
    let currentUserCollection = firestore
      .collection(Strings.matchesMessagesCollection)
      .document(currentUserId)
      .collection(matchedUser.uid)
    
    let data: [String: Any] = [Strings.text: text,
                               Strings.fromId: currentUserId,
                               Strings.toId: matchedUser.uid,
                               Strings.timestamp: Timestamp(date: Date())]
    
    currentUserCollection.addDocument(data: data) { error in
      if let error = error {
        completion(error)
      }
    }
    
    // Save Chat Messages to Matched User
    let matchedUserCollection = firestore
      .collection(Strings.matchesMessagesCollection)
      .document(matchedUser.uid)
      .collection(currentUserId)
    
    matchedUserCollection.addDocument(data: data) { error in
      if let error = error {
        completion(error)
      }
    }
  }
  
  func saveCurrentUserRecentChatMessage(with matchedUser: MatchedUser,
                                        text: String,
                                        completion: @escaping (Error?) -> Void) {
    guard let currentUserId = currentUserId else { return }
    
    // Save Most Recent Chat Message Sent to Current User
    let data: [String: Any] = [Strings.uid: matchedUser.uid,
                               Strings.name: matchedUser.name,
                               Strings.timestamp: Timestamp(date: Date()),
                               Strings.text: text,
                               Strings.profileImageUrl: matchedUser.profileImageUrl ?? ""]
    
    firestore
      .collection(Strings.matchesMessagesCollection)
      .document(currentUserId)
      .collection(Strings.recentMessagesCollection)
      .document(matchedUser.uid)
      .setData(data) { error in
        if let error = error {
          completion(error)
        }
    }
  }
  
  func saveMatchedUserRecentChatMessage(with currentUser: User,
                                           matchedUser: MatchedUser,
                                           text: String,
                                           completion: @escaping (Error?) -> Void) {
    guard let currentUserId = currentUserId else { return }
    
    // Save Most Recent Chat Message Sent to Matched User
    let currentUserData: [String: Any] = [Strings.uid: currentUserId,
                                          Strings.name: currentUser.name ?? "",
                                          Strings.timestamp: Timestamp(date: Date()),
                                          Strings.text: text,
                                          Strings.profileImageUrl: currentUser.imageUrl1 ?? ""]
    
    firestore
      .collection(Strings.matchesMessagesCollection)
      .document(matchedUser.uid)
      .collection(Strings.recentMessagesCollection)
      .document(currentUserId)
      .setData(currentUserData) { error in
        if let error = error {
          completion(error)
        }
    }
  }
}
