//
//  User.swift
//  TinderDemo
//
//  Created by Dennis Vera on 7/11/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

struct User: CardViewViewModelProtocol {
  
  // MARK: - Properties
  
  var age: Int?
  var uid: String?
  var bio: String?
  var name: String?
  var imageUrl1: String?
  var imageUrl2: String?
  var imageUrl3: String?
  var profession: String?
  var minSeekingAge: Int?
  var maxSeekingAge: Int?
  
  // MARK: Initialization
  
  init(dictionary: [String: Any]) {
    self.age = dictionary["age"] as? Int
    self.bio = dictionary["bio"] as? String
    self.uid = dictionary["uid"] as? String
    self.name = dictionary["fullName"] as? String
    self.imageUrl1 = dictionary["imageUrl1"] as? String
    self.imageUrl2 = dictionary["imageUrl2"] as? String
    self.imageUrl3 = dictionary["imageUrl3"] as? String
    self.profession = dictionary["profession"] as? String
    self.minSeekingAge = dictionary["minSeekingAge"] as? Int
    self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int
  }
  
  // MARK: - Helper Methods
  
  func toCardViewModel() -> CardViewViewModel {
    let attributedText = NSMutableAttributedString(string: name ?? "",
                                                   attributes: [.font: UIFont.systemFont(ofSize: 28,
                                                                                         weight: .heavy)])
    
    let ageString = age != nil ? "\(age!)" : "N\\A"
    attributedText.append(NSAttributedString(string: "  \(ageString)",
      attributes: [.font : UIFont.systemFont(ofSize: 18, weight: .regular)]))
    
    let professionString = profession != nil ? "\(profession!)" : "Not Available"
    attributedText.append(NSAttributedString(string: "\n\(professionString)",
      attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular)]))
    
    var imageUrls = [String]()
    if let url = imageUrl1 { imageUrls.append( url) }
    if let url = imageUrl2 { imageUrls.append( url) }
    if let url = imageUrl3 { imageUrls.append( url) }
    
    return CardViewViewModel(uid: uid ?? "",
                             imageUrls: imageUrls,
                             attributedString: attributedText,
                             textAlignment: .left)
  }
}
