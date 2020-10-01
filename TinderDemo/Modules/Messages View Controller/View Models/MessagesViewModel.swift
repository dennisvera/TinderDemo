//
//  MessagesViewModel.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/30/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class MessagesViewModel {
  
  // MARK: - Properties
  
  private var listener: ListenerRegistration?
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
  
  // MARK: - Public API
  
  func loadData() {
    guard let currentUserID = Auth.auth().currentUser?.uid else { return }
    
    let query = Firestore.firestore()
      .collection(Strings.matchesMessagesCollection)
      .document(currentUserID)
      .collection(Strings.recentMessagesCollection)
    
    listener = query.addSnapshotListener { [weak self] querySnapshot, error in
      guard let strongSelf = self else { return }
      
      if let error = error {
        print("Unable to Fetch Matched Users:", error)
        return
      }
      
      querySnapshot?.documentChanges.forEach({ change in
        if change.type == .added || change.type == .modified {
          let dictionary = change.document.data()
          let recentMessage = RecentMessage(dictionary: dictionary)
          strongSelf.recentMessagesDictionary[recentMessage.uid] = recentMessage
        }
      })
      
      strongSelf.resetMessages()
    }
  }
  
  func removeListener() {
    listener?.remove()
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
