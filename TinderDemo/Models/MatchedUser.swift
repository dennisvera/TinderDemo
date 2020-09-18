//
//  MatchedUser.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/17/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import Foundation

struct MatchedUser {
  
  // MARK: - Properties
  let uid: String
  let name: String
  let profileImageUrl: String?
  
  // MARK: - Intialization
  
  init(dictionary: [String: Any]) {
    self.uid = dictionary["uid"] as? String ?? ""
    self.name = dictionary["name"] as? String ?? ""
    self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
  }
}
