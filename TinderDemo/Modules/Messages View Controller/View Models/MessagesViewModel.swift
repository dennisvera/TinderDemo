//
//  MessagesViewModel.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/30/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import Foundation

final class MessagesViewModel {
  
  // MARK: - Properties
  
  private let firestoreService: FirestoreService

  // MARK: -
  
  private var recentMessagesDictionary = [String: RecentMessage]()
  private var recentMessages: [RecentMessage] = [] {
    didSet {
      DispatchQueue.main.async {
        self.messagesDidChange?()
      }
    }
  }
  
  // MARK: -
  
  var numberOfMessages: Int {
    return recentMessages.count
  }
  
  // MARK: -
  
  var messagesDidChange: (() -> Void)?
  var didSelectBackButton: (() -> Void)?
  
  // MARK: - Initialization
  
  init(firestoreService: FirestoreService) {
    self.firestoreService = firestoreService
  }
  
  // MARK: - Public API
  
  func loadMessages() {
    firestoreService.fetchMessages { [weak self] (dictionary, error) in
      guard let strongSelf = self else { return }
      
      if let error = error {
        print(Strings.failedToFetchMessages, error)
        return
      }
      
      guard let dictionary = dictionary else { return }
      let recentMessage = RecentMessage(dictionary: dictionary)
      strongSelf.recentMessagesDictionary[recentMessage.uid] = recentMessage
      
      strongSelf.resetMessages()
    }
  }
  
  func removeListener() {
    firestoreService.removeListener()
  }
  
  func navigateBackHome() {
    didSelectBackButton?()
  }
  
  func message(at index: Int) -> RecentMessage {
    return recentMessages[index]
  }
  
  // MARK: Helper Methods
  
  private func resetMessages() {
    let values = Array(recentMessagesDictionary.values)
    recentMessages = values.sorted(by: { recentMessage1, recentMesage2 -> Bool in
      return recentMessage1.timestamp.compare(recentMesage2.timestamp) == .orderedDescending
    })
  }
}
