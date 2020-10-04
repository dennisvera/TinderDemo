//
//  SettingsViewModel.swift
//  TinderDemo
//
//  Created by Dennis Vera on 10/2/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import Foundation
import Firebase

final class SettingsViewModel {
  
  // MARK: - Properties
  
  private let firestoreService: FirestoreService
  
  var user: User?
  
  // MARK: -
  
  var didSelectSave: (() -> Void)?
  var didSelectCancel: (() -> Void)?
  var didSelectSignOut: (() -> Void)?
  
  // MARK: - Initialization
  
  init(firestoreService: FirestoreService) {
    self.firestoreService = firestoreService
  }
  
  // MARK: - Public Methods
  
  func handleCancel() {
    didSelectCancel?()
  }
  
  func handleSignOut() {
    didSelectSignOut?()
    firestoreService.signOut()
  }
  
  func fetchCurrentUser(completion: @escaping () -> Void) {
    firestoreService.fetchCurrentUser { [weak self] (user, error) in
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
    ageRangeCell.minLabel.text = Strings.min + " \(minValue)"
    ageRangeCell.maxLabel.text = Strings.max + " \(maxValue)"
    
    user?.minSeekingAge = minValue
    user?.maxSeekingAge = maxValue
  }
  
  func saveCurrentUserSettingsInfo(completion: @escaping () -> Void) {
    // Save users info to Firestore
    guard let user = user, let currentUserUid = Auth.auth().currentUser?.uid else { return }
    
    let documentData: [String: Any] = [
      Strings.uid : currentUserUid,
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
    
    firestoreService.saveCurrentUserSettingsInfo(with: currentUserUid, documentData: documentData)
    
    completion()
    didSelectSave?()
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
