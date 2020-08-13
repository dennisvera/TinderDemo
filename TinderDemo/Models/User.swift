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
  var name: String?
  var imageUrl1: String?
  var imageUrl2: String?
  var imageUrl3: String?
  var profession: String?
  
  // MARK: Initialization
  
  init(dictionary: [String: Any]) {
    self.age = dictionary["age"] as? Int
    self.uid = dictionary["uid"] as? String ?? ""
    self.name = dictionary["fullName"] as? String ?? ""
    self.profession = dictionary["profession"] as? String
    self.imageUrl1 = dictionary["imageUrl1"] as? String
    self.imageUrl2 = dictionary["imageUrl2"] as? String
    self.imageUrl3 = dictionary["imageUrl3"] as? String
  }
  
  // MARK: - Helper Methods
  
  func toCardViewModel() -> CardViewViewModel {
    let attributedText = NSMutableAttributedString(string: name ?? "",
                                                   attributes: [.font: UIFont.systemFont(ofSize: 34,
                                                                                         weight: .heavy)])
    
    let ageString = age != nil ? "\(age!)" : "N\\A"
    attributedText.append(NSAttributedString(string: "  \(ageString)",
      attributes: [.font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
    
    let professionString = profession != nil ? "\(profession!)" : "Not Available"
    attributedText.append(NSAttributedString(string: "\n\(professionString)",
      attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
    
    var imageUrls = [String]()
    if let url = imageUrl1 { imageUrls.append( url) }
    if let url = imageUrl2 { imageUrls.append( url) }
    if let url = imageUrl3 { imageUrls.append( url) }
    
    return CardViewViewModel(imageNames: imageUrls,
                             attributedString: attributedText,
                             textAlignment: .left)
  }
}
