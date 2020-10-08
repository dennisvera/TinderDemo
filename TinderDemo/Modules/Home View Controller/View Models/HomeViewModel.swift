//
//  HomeViewModel.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/30/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import Foundation
import Firebase

final class HomeViewModel {
  
  // MARK: - Properties

  private let firestoreService: FirestoreService
  
  // MARK: -
  
  var user: User?
  var users = [String: User]()
  var swipes = [String: Int]()
  
  // MARK: -
  
  var didShowMessages: (() -> Void)?
  var didShowSettings: (() -> Void)?
  
  // MARK: - Initialization
  
  init(firestoreService: FirestoreService) {
    self.firestoreService = firestoreService
  }
  
  // MARK: - Public Methods
  
  func showMessages() {
    didShowMessages?()
  }
  
  func showSettings() {
    didShowSettings?()
  }
  
  func fetchCurrentUser(completion: @escaping () -> Void) {
    firestoreService.fetchCurrentUser { [weak self] (user, error) in
      guard let strongSelf = self else { return }

      if let error = error {
        print(Strings.failedToFetchCurrentUser, error)
        return
      }
      // Fetch current user
      strongSelf.user = user

      completion()
    }
  }

  func fetchSwipedUsers(completion: @escaping () -> Void) {
    firestoreService.fetchSwipedUsers { [weak self] (swipedUser, error) in
      guard let strongSelf = self else { return }

      if let error = error {
        print(Strings.failedToFethcSwipedHistoryForCurrentUser, error)
        return
      }

      guard let swipedUser = swipedUser else { return }
      strongSelf.swipes = swipedUser

      completion()
    }
  }
  
  func saveSwipeToFireStore(with cardUid: String, didLike: Int, completion: @escaping (Int?) -> Void) {
    firestoreService.saveSwipeToFireStore(with: cardUid, didLike: didLike) {  (didLike, error)   in
      if let error = error {
        print(Strings.failedToUpdateData, error)
        return
      }
      
      completion(didLike)
    }
  }
  
  func checkIfMatchExists(cardUid: String, completion: @escaping (Bool) -> Void) {
    firestoreService.checkIfMatchExists(cardUid: cardUid) { (hasMatched, error) in
      if let error = error {
        print(Strings.failedToFetchUserDocumentCard, error)
        return
      }
      
      completion(hasMatched)
    }
  }
  
  func saveMatchedCurrentUserInfo(with cardUid: String) {
    firestoreService.saveMatchedCurrentUserInfo(with: user, cardUid: cardUid) { error in
      if let error = error {
        print(Strings.failedToSaveCurrentUserInfo, error)
        return
      }
    }
  }
  
  func saveMatchedUserInfo(with cardUid: String) {
    firestoreService.saveMatchedUserInfo(with: users, cardUid: cardUid) { error in
      if let error = error {
        print(Strings.failedToSaveMatchedUserInfo, error)
        return
      }
    }
  }
}
