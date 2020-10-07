//
//  ChatViewModel.swift
//  TinderDemo
//
//  Created by Dennis Vera on 10/5/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import Foundation

final class ChatViewModel {
  
  // MARK: - Properties
  
  private let firestoreService: FirestoreService
  
  // MARK: -
  
  let matchedUser: MatchedUser
  
  // MARK: -
  
  var currentUser: User?
  var messages = [Message]()
  
  // MARK: -
  
  var numberOfMessages: Int {
    return messages.count
  }
  
  // MARK: - Initialization
  
  init(firestoreService: FirestoreService, matchedUser: MatchedUser) {
    self.firestoreService = firestoreService
    self.matchedUser = matchedUser
  }
  
  // MARK: - Public Methods
  
  func removeListener() {
    firestoreService.removeListener()
  }
  
  func fetchCurrentUser() {
    firestoreService.fetchCurrentUser { [weak self] (user, error) in
      guard let strongSelf = self else { return }
      
      if let error = error {
        print(Strings.failedToFetchCurrentUser, error)
        return
      }
      
      strongSelf.currentUser = user
    }
  }
  
  func fetchChatMessages(completion: @escaping () -> Void) {
    firestoreService.fetchChatMessages(with: matchedUser.uid) { [weak self] (user, error) in
      guard let strongSelf = self else { return }
      
      if let error = error {
        print(Strings.failedToFetchCurrentUser, error)
        return
      }
      
      guard let userDictionary = user else { return }
      strongSelf.messages.append(.init(dictionary: userDictionary))
      
      completion()
    }
  }
  
  func saveToFromChatMesage(with text: String, completion: @escaping () -> Void) {
    firestoreService.saveCurrentUserAndMatchedUserChatMesages(with: matchedUser, text: text) { error in
      if let error = error {
        print(Strings.failedToFetchChatMessages, error)
        return
      }
      
      completion()
    }
  }
  
  func saveToFromChatRecentMessages(with text: String) {
    firestoreService.saveCurrentUserRecentChatMessage(with: matchedUser, text: text) { error in
      if let error = error {
        print(Strings.failedToSaveCurrentUserRecentMessage, error)
        return
      }
    }
    
    guard let currentUser = currentUser else { return }
    firestoreService.saveMatchedUserRecentChatMessage(with: currentUser, matchedUser: matchedUser, text: text) { error in
      if let error = error {
        print(Strings.failedToSaveMatchedUserRecentMessage, error)
        return
      }
    }
  }
}
