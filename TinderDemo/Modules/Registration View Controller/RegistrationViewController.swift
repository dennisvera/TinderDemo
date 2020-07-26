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
  
  // MARK: Private Properties
  
  private let selectPhotoButton: UIButton = {
    let button = UIButton(type: .system)
    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    button.layer.cornerRadius = 16
    button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
    button.setTitle("Select Photo", for: .normal)
    button.widthAnchor.constraint(equalToConstant: 275).isActive = true
    button.heightAnchor.constraint(equalToConstant: 300).isActive = true
    button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
    return button
  }()
  
  private let fullNameTextField: CustomTextField = {
    let textField = CustomTextField(padding: 16)
    textField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    textField.placeholder = "Enter full name"
    return textField
  }()
  
  private let emailTextField: CustomTextField = {
    let textField = CustomTextField(padding: 16)
    textField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    textField.placeholder = "Enter email"
    textField.keyboardType = .emailAddress
    return textField
  }()
  
  private let passwordTextField: CustomTextField = {
    let textField = CustomTextField(padding: 16)
    textField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    textField.isSecureTextEntry = true
    textField.placeholder = "Enter password"
    return textField
  }()
  
  private let registerButton: UIButton = {
    let button = UIButton(type: .system)
    button.backgroundColor = #colorLiteral(red: 0.822586894, green: 0.09319851547, blue: 0.3174999356, alpha: 1)
    button.layer.cornerRadius = 22
    button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
    button.setTitle("Register", for: .normal)
    button.heightAnchor.constraint(equalToConstant: 44).isActive = true
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
    return button
  }()
  
  // MARK: -
  
  private let gradientLayer = CAGradientLayer()
  
  private lazy var verticalStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      fullNameTextField,
      emailTextField,
      passwordTextField,
      registerButton
    ])
    stackView.spacing = 8
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  private lazy var mainStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      selectPhotoButton,
      verticalStackView
    ])
    stackView.spacing = 8
    stackView.axis = .vertical
    return stackView
  }()
  
  // MARK: - View Life Cycle 
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupGradientLayer()
    setupStackView()
    setuptapGesture()
    setupNotificationObservers()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    // Set the gradient layer to equal the view bounds
    // when the device rotates
    gradientLayer.frame = view.bounds
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: - Overrides
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    // Configure Stack View orientation when device is rotated
    if traitCollection.verticalSizeClass == .compact {
      mainStackView.axis = .horizontal
    } else {
      mainStackView.axis = .vertical
    }
  }
  
  // MARK: - Helper Methods
  
  private func setupGradientLayer() {
    // Configure Gradient Layer
    let topColor = #colorLiteral(red: 0.9827533364, green: 0.3668525219, blue: 0.365799427, alpha: 1)
    let bottomColor = #colorLiteral(red: 0.8863948584, green: 0.1081401929, blue: 0.4572728276, alpha: 1)
    gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
    gradientLayer.locations = [0, 1]
    
    // Add Gradient Layer to Sub Layer
    view.layer.addSublayer(gradientLayer)
    gradientLayer.frame = view.bounds
  }
  
  private func setupStackView() {
    // Add Stack View to Sub View
    view.addSubview(mainStackView)
    mainStackView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(50)
      make.trailing.equalToSuperview().offset(-50)
    }
  }
  
  // MARK: - Notification Methods
  
  private func setupNotificationObservers() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleKeyboardShow(notification:)),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleKeyboardHide(notification:)),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }
  
  @objc private func handleKeyboardShow(notification: Notification) {
    // Find the Keybaord frame
    guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    let keyboardFrame = value.cgRectValue
    
    // Calculate the height from the bottom of the main view to the bottom of the stack view
    // Push up (transform) the view up to show the full stackview when the keyboard is shown
    let bottomSpace = view.frame.height - mainStackView.frame.origin.y - mainStackView.frame.height
    let difference = keyboardFrame.height - bottomSpace
    let bottomPadding: CGFloat = 8
    view.transform = CGAffineTransform(translationX: 0, y: -difference - bottomPadding)
  }
  
  @objc private func handleKeyboardHide(notification: Notification) {
    // Set view back to the original frame
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 1,
                   initialSpringVelocity: 1,
                   options: .curveEaseOut,
                   animations: {
                    self.view.transform = .identity
    })
  }
  
  // MARK: - TapGesture Methods
  
  private func setuptapGesture() {
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
  }
  
  @objc private func handleTapDismiss() {
    // Dismisse Keyboard
    view.endEditing(true)
  }
}
