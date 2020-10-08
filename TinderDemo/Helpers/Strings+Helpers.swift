//
//  Strings+Helpers.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/28/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

/// Strings resource file
struct Strings {
  
  // MARK: Firebase Firestore
  
  static let uid = "uid"
  static let age = "age"
  static let bio = "bio"
  static let name = "name"
  static let fullName = "fullName"
  static let profession = "profession"
  
  static let minSeekingAge = "minSeekingAge"
  static let maxSeekingAge = "maxSeekingAge"
    
  static let imagePath = "/images/"
  static let imageUrl1 = "imageUrl1"
  static let imageUrl2 = "imageUrl2"
  static let imageUrl3 = "imageUrl3"
  static let profileImageUrl = "profileImageUrl"
  
  static let text = "text"
  static let toId = "toId"
  static let fromId = "fromId"
  static let timestamp = "timestamp"
  static let matchedUserKey = "matchedUserKey"
  
  static let usersCollection = "users"
  static let swipesCollection = "swipes"
  static let matchesCollection = "matches"
  static let recentMessagesCollection = "recent_messages"
  static let matchesMessagesCollection = "matches_messages"
  
  // MARK: - RegistrationViewController
  
  static let register = "Register"
  static let goToLogin = "Go to Login"
  static let enterEmail = "Enter email"
  static let enterPassword = "Enter password"
  static let enterFullName = "Enter full name"
  
  // MARK: - SettingsViewController
  
  static let enterAge = "Enter Age"
  static let enterBio = "Enter Bio"
  static let enterName = "Enter Name"
  static let settingsTitle = "Settings"
  static let enterProfession = "Enter Profession"
  
  static let capitalBio = "Bio"
  static let capitalAge = "Age"
  static let capitalName = "Name"
  static let capitalProfession = "Profession"
  static let seekingAgeRange = "Seeking Age Range"
  
  // MARK: - ProgressHud
  
  static let savingSetttings = "Saving Settings"
  static let uploadingImage = "Uploading Image ..."
  
  // MARK: - Generals
  
  static let min = "Min:"
  static let max = "Max:"

  // MARK: - Bunttons
  
  static let save = "Save"
  static let cancel = "Cancel"
  static let logout = "Logout"
  static let selectPhoto = "Select Photo"
  
  // MARK: - Notifications
  
  static let matchesHorizontalControllerSegue = "matchesHorizontalControllerSegue"
  
  // MARK: - Errors

  static let failedToRegister = "Failed to Register User:"
  static let failedToFetchUsers = "Failed to Fetch Users:"
  static let failedToUpdateData = "Failed to Update Data:"
  static let failedToSaveSwipedData = "Failed to Save Swipe Data:"
  static let failedToFetchCurrentUser = "Failed to Fetch Current User:"
  static let failedToUplaodImage = "Failed to Upload Image to Firestore:"
  static let failedToFetchChatMessages = "Failed to Fetch Chat Messages:"
  static let failedToFetchImageUrl = "Failed to Fetch Image Download Url:"
  static let failedToFetchMessages = "Failed to Fetch Matched User Messages:"
  static let failedToSaveMatchedUserInfo = "Failed to Save Matched User Info:"
  static let failedToSaveCurrentUserInfo = "Failed to Save Current User Info:"
  static let failedToFetchUserDocumentCard = "Failed to Fetch User Card Document:"
  static let failedToSaveUserSettingsInfo = "Failed to Save User Settings Info to Firestore:"
  static let failedToSaveMatchedUserRecentMessage = "Failed to Save Matched User Most Recent Message:"
  static let failedToSaveCurrentUserRecentMessage = "Failed to Save Current User Most Recent Message:"
  static let failedToFethcSwipedHistoryForCurrentUser = "Failed to Fetch Swip History for Current User:"
}
