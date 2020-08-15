//
//  LoginViewController.swift
//  TinderDemo
//
//  Created by Dennis Vera on 8/13/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol LoginViewControllerDelegate {
  func didFinishLoggingIn()
}

class LoginViewController: UIViewController {
  
  // MARK: - Properties
  
  private let emailTextField: CustomTextField = {
    let textField = CustomTextField(padding: 16, height: 50)
    textField.placeholder = "Enter email"
    textField.keyboardType = .emailAddress
    textField.addTarget(self, action: #selector(handleTextChanged(textField:)), for: .editingChanged)
    return textField
  }()
  
  private let passwordTextField: CustomTextField = {
    let textField = CustomTextField(padding: 16, height: 50)
    textField.isSecureTextEntry = true
    textField.placeholder = "Enter password"
    textField.addTarget(self, action: #selector(handleTextChanged(textField:)), for: .editingChanged)
    return textField
  }()
  
  private let loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.isEnabled = false
    button.layer.cornerRadius = 22
    button.backgroundColor = .lightGray
    button.setTitle("Log In", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.setTitleColor(.gray, for: .disabled)
    button.heightAnchor.constraint(equalToConstant: 44).isActive = true
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
    button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    return button
  }()
  
  private let backToRegisterButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitleColor(.white, for: .normal)
    button.setTitle("Back to register", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    button.addTarget(self, action: #selector(handleBackToRegister), for: .touchUpInside)
    return button
  }()
  
  
  // MARK: -
  
  private lazy var mainStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      emailTextField,
      passwordTextField,
      loginButton
    ])
    stackView.axis = .vertical
    stackView.spacing = 8
    return stackView
  }()
  
  
  // MARK: -
  
  var delegate: LoginViewControllerDelegate?
  private var viewModel = LoginViewModel()
  
  // MARK: -
  
  private let gradientLayer = CAGradientLayer()
  private let progressHud = JGProgressHUD(style: .dark)
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupGradientLayer()
    setupView()
    setupLoginViewModelObservers()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    // Set the gradient layer to equal the view bounds
    // when the device rotates
    gradientLayer.frame = view.bounds
  }
  
  // MARK: - Helper Methods
  
  private func setupView() {
    navigationController?.isNavigationBarHidden = true
    
    // Add Stack View to Sub View
    view.addSubview(mainStackView)
    mainStackView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(50)
      make.trailing.equalToSuperview().offset(-50)
    }
    
    // Add Back to Register Button
    view.addSubview(backToRegisterButton)
    backToRegisterButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
  }
  
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
  
  private func setupLoginViewModelObservers() {
    // Configure Login isFormValidObserver
    viewModel.isFormValidObserver = { [weak self] isFormValid in
      guard let strongSelf = self else { return }
      
      strongSelf.loginButton.isEnabled = isFormValid
      strongSelf.loginButton.backgroundColor = isFormValid ? #colorLiteral(red: 0.8235294118, green: 0, blue: 0.3254901961, alpha: 1) : .lightGray
      strongSelf.loginButton.setTitleColor(isFormValid ? .white : .gray, for: .normal)
    }
    
    // Configure Login isLoggingInObserver
    viewModel.isLoggingInObserver = { [weak self] isLoginIn in
      guard let strongSelf = self else { return }
      
      if isLoginIn {
        strongSelf.progressHud.textLabel.text = "Login In ..."
        strongSelf.progressHud.show(in: strongSelf.view)
      } else {
        strongSelf.progressHud.dismiss()
      }
    }
  }
  
  // MARK: - Actions
  
  @objc private func handleLogin() {
    dismiss(animated: true)
    
    viewModel.performLogin { [weak self] error in
      guard let strongSelf = self else { return }
      if let error = error {
        print("Failed to Login:", error)
        return
      }
      
      print("Login Successful!")
      
      strongSelf.dismiss(animated: true, completion: {
        strongSelf.delegate?.didFinishLoggingIn()
      })
    }
  }
  
  @objc private func handleTextChanged(textField: UITextField) {
    if textField == emailTextField {
      viewModel.email = textField.text
    } else if textField == passwordTextField {
      viewModel.password = textField.text
    } else {
      viewModel.password = textField.text
    }
  }
  
  @objc private func handleBackToRegister() {
    navigationController?.popViewController(animated: true)
  }
}
