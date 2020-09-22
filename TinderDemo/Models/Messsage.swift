//
//  Messsage.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/18/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import Firebase

struct Message {
  
  // MARK: - Properties
  
  let text: String
  let toId: String
  let fromId: String
  let timestamp: Timestamp
  
  let isCurrentLoggedUser: Bool
  
  // MARK: - Initialization
  
  init(dictionary: [String: Any]) {
    self.text = dictionary["text"] as? String ?? ""
    self.toId = dictionary["toId"] as? String ?? ""
    self.fromId = dictionary["fromId"] as? String ?? ""
    self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    
    self.isCurrentLoggedUser = Auth.auth().currentUser?.uid == fromId
  }
}
