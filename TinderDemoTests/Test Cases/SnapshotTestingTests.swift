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
    
    verifyViewController(loginViewController, named: "Default", testName: "LoginViewController")
  }
  
  // MARK: - Test Registration View Controller
  
  func test_RegistrationViewController() {
    let viewModel = RegistrationViewModel(firestoreService: firestoreService)
    let registrationViewController = RegistrationViewController(viewModel: viewModel)
    
    verifyViewController(registrationViewController, named: "Default", testName: "RegistrationViewController")
  }
  
  // MARK: - Helper Method
  
  private func verifyViewController(_ viewController: UIViewController, named: String, testName: String) {
    let devices: [String: ViewImageConfig] = ["iPhoneX": .iPhoneX,
                                              "iPhone8": .iPhone8,
                                              "iPhoneSe": .iPhoneSe,
                                              "iPhoneXsMax": .iPhoneXsMax]
    
    let results = devices.map { device in
      verifySnapshot(matching: viewController,
                     as: .image(on: device.value),
                     named: "\(named)-\(device.key)",
        testName: testName)
    }
    
    results.forEach { XCTAssertNil($0) }
  }
}
