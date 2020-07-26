//
//  RegistrationViewModel.swift
//  TinderDemo
//
//  Created by Dennis Vera on 7/26/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

class RegistrationViewModel {
  
  // MARK: - Properties
  
  var fullName: String? {
    didSet {
      checkRegistrationIsValid()
    }
  }
  
  var email: String? {
    didSet {
      checkRegistrationIsValid()
    }
  }
  
  var password: String? {
    didSet {
      checkRegistrationIsValid()
    }
  }
  
  var isRegistrationValid: ((Bool) -> ())?
  
  // MARK: Helper Methods
  
  private func checkRegistrationIsValid() {
    let emailIsValid = email?.isEmpty == false
    let fullNameIsValid = fullName?.isEmpty == false
    let passwordIsValid = password?.isEmpty == false
    
    let isFormValid = fullNameIsValid && emailIsValid && passwordIsValid
        
    isRegistrationValid?(isFormValid)
  }
}
