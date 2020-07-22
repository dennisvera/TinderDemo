//
//  RegistrationViewController.swift
//  TinderDemo
//
//  Created by Dennis Vera on 7/22/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit

class RegistrationViewController: UIViewController {
  
  // MARK: Properties
  
  let selectPhotoButton: UIButton = {
    let button = UIButton(type: .system)
    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    button.layer.cornerRadius = 16
    button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
    button.setTitle("Select Photo", for: .normal)
    button.heightAnchor.constraint(equalToConstant: 300).isActive = true
    button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
    return button
  }()
  
  let fullNameTextField: CustomTextField = {
    let textField = CustomTextField(padding: 16)
    textField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    textField.placeholder = "Enter full name"
    return textField
  }()
  
  let emailTextField: CustomTextField = {
    let textField = CustomTextField(padding: 16)
    textField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    textField.placeholder = "Enter email"
    textField.keyboardType = .emailAddress
    return textField
  }()
  
  let passwordTextField: CustomTextField = {
    let textField = CustomTextField(padding: 16)
    textField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    textField.isSecureTextEntry = true
    textField.placeholder = "Enter password"
    return textField
  }()
  
  // MARK: - View Life Cycle 
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupGradientLayer()
    setupStackView()
  }
  
  // MARK: - Helper Methods
  
  private func setupGradientLayer() {
    // Configure Gradient Layer
    let gradientLayer = CAGradientLayer()
    let topColor = #colorLiteral(red: 0.9827533364, green: 0.3668525219, blue: 0.365799427, alpha: 1)
    let bottomColor = #colorLiteral(red: 0.8863948584, green: 0.1081401929, blue: 0.4572728276, alpha: 1)
    gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
    gradientLayer.locations = [0, 1]
    
    // Add Gradient Layer to Sub Layer
    view.layer.addSublayer(gradientLayer)
    gradientLayer.frame = view.bounds
  }
  
  private func setupStackView() {
    // Configure Stack View
    let stackView = UIStackView(arrangedSubviews: [
      selectPhotoButton,
      fullNameTextField,
      emailTextField,
      passwordTextField])
    stackView.axis = .vertical
    stackView.spacing = 8
    
    // Add Stack View to Sub View
    view.addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(50)
      make.trailing.equalToSuperview().offset(-50)
    }
  }
}
