//
//  RecentMessages.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/22/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore

struct RecentMessage {
  
  // MARK: - Properties
  
  let uid: String
  let name: String
  let text: String
  let timestamp: Timestamp
  let profileImageUrl: String
  
  // MARK: - Initialization
  
  init(dictionary: [String: Any]) {
    self.uid = dictionary["uid"] as? String ?? ""
    self.name = dictionary["name"] as? String ?? ""
    self.text = dictionary["text"] as? String ?? ""
    self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
  }
}
