//
//  SnapshotTestingTests.swift
//  TinderDemoTests
//
//  Created by Dennis Vera on 10/23/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import TinderDemo

class SnapshotTestingTests: XCTestCase {
  
  // MARK: - Properties
  
  var firestoreService: FirestoreService!
  
  // MARK: - Set Up & Tear Down
  
  override func setUpWithError() throws {
    // Initiallize FirestoreService
    firestoreService = FirestoreService()
  }
  
  override func tearDownWithError() throws {
    firestoreService = nil
  }
  
  // MARK: - Test Login View Controller
  
  func test_LoginViewController() {
    let loginViewController = LoginViewController()
    
    verifyViewController(loginViewController, testName: "LoginViewController")
  }
  
  // MARK: - Test Registration View Controller
  
  func test_RegistrationViewController() {
    let viewModel = RegistrationViewModel(firestoreService: firestoreService)
    let registrationViewController = RegistrationViewController(viewModel: viewModel)
    
    verifyViewController(registrationViewController, testName: "RegistrationViewController")
  }
  
  // MARK: - Test Home View Controller
  
  func test_HomeViewController_Loading() {
    let viewModel = HomeViewModel(firestoreService: firestoreService)
    let homeViewController = HomeViewController(viewModel: viewModel)
    
    verifyViewController(homeViewController, testName: "HomeViewController-Loading")
  }
  
  // MARK: - Settings Home View Controller
  
  func test_SettingsViewController() {
    let viewModel = SettingsViewModel(firestoreService: firestoreService)
    let settingsViewController = SettingsViewController(viewModel: viewModel)
        
    verifyViewController(settingsViewController, testName: "SettingsViewController")
  }
  
  // MARK: - Helper Method
  
  private func verifyViewController(_ viewController: UIViewController, testName: String) {
    let devices: [String: ViewImageConfig] = ["iPhoneX": .iPhoneX,
                                              "iPhone8": .iPhone8,
                                              "iPhoneSe": .iPhoneSe,
                                              "iPhoneXsMax": .iPhoneXsMax]
    
    let results = devices.map { device in
      verifySnapshot(matching: viewController,
                     as: .image(on: device.value),
                     named: "Default-\(device.key)",
        testName: testName)
    }
    
    results.forEach { XCTAssertNil($0) }
  }
}
