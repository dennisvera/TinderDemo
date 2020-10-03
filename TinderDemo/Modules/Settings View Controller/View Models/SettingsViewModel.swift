//
//  SettingsViewModel.swift
//  TinderDemo
//
//  Created by Dennis Vera on 10/2/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

final class SettingsViewModel {
  
  // MARK: - Properties
  
  var user: User?
  
  // MARK: -
  
  var didSelectSave: (() -> Void)?
  var didSelectCancel: (() -> Void)?
  var didSelectSignOut: (() -> Void)?
  
  // MARK: - Public API
  
  func handleCancel() {
    didSelectCancel?()
  }
  
  func handleSignOut() {
    try? Auth.auth().signOut()
    
    didSelectSignOut?()
  }
  
  func fetchCurrentUser(completion: @escaping () -> Void) {
    Firestore.firestore().fetchCurrentUser { [weak self] (user, error) in
      guard let strongSelf = self else { return }
      
      if let error = error {
        print("Failed to Fetch User:", error)
        return
      }
      
      // Set user
      strongSelf.user = user
      
      completion()
    }
  }
  
  func evaluateMinAndMaxSliderValue(with ageRangeCell: AgeRangeTableViewCell) {
    let minValue = Int(ageRangeCell.minSlider.value)
    var maxValue = Int(ageRangeCell.maxSlider.value)
    
    maxValue = max(minValue, maxValue)
    
    ageRangeCell.maxSlider.value = Float(maxValue)
    ageRangeCell.minLabel.text = "Min: \(minValue)"
    ageRangeCell.maxLabel.text = "Max: \(maxValue)"
    
    user?.minSeekingAge = minValue
    user?.maxSeekingAge = maxValue
  }
  
   // MARK: - Save User Info
  
  func handleSave(completion: @escaping () -> Void) {
    // Save users info to Firestore
    guard let user = user, let userUid = Auth.auth().currentUser?.uid else { return }
    
    let documentData: [String: Any] = [
      Strings.uid : userUid,
      Strings.age : user.age ?? -1,
      Strings.bio : user.bio ?? "",
      Strings.fullName : user.name ?? "",
      Strings.imageUrl1 : user.imageUrl1 ?? "",
      Strings.imageUrl2 : user.imageUrl2 ?? "",
      Strings.imageUrl3 : user.imageUrl3 ?? "",
      Strings.profession : user.profession ?? "",
      Strings.minSeekingAge : user.minSeekingAge ?? -1,
      Strings.maxSeekingAge : user.maxSeekingAge ?? -1
    ]
    
    Firestore.firestore()
      .collection(Strings.usersCollection)
      .document(userUid)
      .setData(documentData) { [weak self] error in
        guard let strongSelf = self else { return }
        
        if let error = error {
          print("Failed to save user's settings to Firestore:", error)
        }
                
        completion()
        strongSelf.didSelectSave?()
    }
  }
  
  func handleNameChange(with textField: UITextField) {
    user?.name = textField.text
  }
  
  func handleProfessionChange(with textField: UITextField) {
    user?.profession = textField.text
  }
  
  func handleAgeChange(with textField: UITextField) {
    user?.age = Int(textField.text ?? "")
  }
  
  func handleBioChange(with textField: UITextField) {
    user?.bio = textField.text
  }
}
