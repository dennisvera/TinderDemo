//
//  RegistrationViewController.swift
//  TinderDemo
//
//  Created by Dennis Vera on 7/22/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import JGProgressHUD

class RegistrationViewController: UIViewController {
  
  // MARK: Private Properties
  
  private let selectPhotoButton: UIButton = {
    let button = UIButton(type: .system)
    button.clipsToBounds = true
    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    button.layer.cornerRadius = 16
    button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
    button.setTitle("Select Photo", for: .normal)
    button.imageView?.contentMode = .scaleAspectFill
    button.widthAnchor.constraint(equalToConstant: 275).isActive = true
    button.heightAnchor.constraint(equalToConstant: 300).isActive = true
    button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
    button.addTarget(self, action: #selector(handleSelectButtontapped), for: .touchUpInside)
    return button
  }()
  
  private let fullNameTextField: CustomTextField = {
    let textField = CustomTextField(padding: 16)
    textField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    textField.placeholder = "Enter full name"
    textField.addTarget(self, action: #selector(handleTextChanged(textField:)),
                        for: .editingChanged)
    return textField
  }()
  
  private let emailTextField: CustomTextField = {
    let textField = CustomTextField(padding: 16)
    textField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    textField.placeholder = "Enter email"
    textField.keyboardType = .emailAddress
    textField.addTarget(self, action: #selector(handleTextChanged(textField:)),
                        for: .editingChanged)
    return textField
  }()
  
  private let passwordTextField: CustomTextField = {
    let textField = CustomTextField(padding: 16)
    textField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    textField.isSecureTextEntry = true
    textField.placeholder = "Enter password"
    textField.addTarget(self, action: #selector(handleTextChanged(textField:)),
                        for: .editingChanged)
    return textField
  }()
  
  private let registerButton: UIButton = {
    let button = UIButton(type: .system)
    button.isEnabled = false
    button.layer.cornerRadius = 22
    button.backgroundColor = .lightGray
    button.setTitle("Register", for: .normal)
    button.setTitleColor(.darkGray, for: .disabled)
    button.heightAnchor.constraint(equalToConstant: 44).isActive = true
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
    button.addTarget(self, action: #selector(handleRegisterButtonTapped), for: .touchUpInside)
    return button
  }()
  
  // MARK: -
  
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
  
  // MARK: -
  
  private let resgisterHud = JGProgressHUD()
  private let gradientLayer = CAGradientLayer()
  private var viewModel = RegistrationViewModel()
  
  // MARK: - View Life Cycle 
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupGradientLayer()
    setupStackView()
    setuptapGesture()
    setupNotificationObservers()
    setupRegistrationViewModelObservers()
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
  
  @objc private func handleTextChanged(textField: UITextField) {
    if textField == fullNameTextField {
      viewModel.fullName = textField.text
    } else if textField == emailTextField {
      viewModel.email = textField.text
    } else {
      viewModel.password = textField.text
    }
  }
  
  private func setupRegistrationViewModelObservers() {
    // Configure registration isValid observer
    viewModel.isRegistrationValidObserver = { [weak self] isValid in      
      guard let strongSelf = self else { return }
      strongSelf.registerButton.isEnabled = isValid
      
      if isValid {
        strongSelf.registerButton.backgroundColor = #colorLiteral(red: 0.822586894, green: 0.09319851547, blue: 0.3174999356, alpha: 1)
        strongSelf.registerButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
      } else {
        strongSelf.registerButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        strongSelf.registerButton.setTitleColor(.darkGray, for: .disabled)
      }
    }
    
    // Configure image observer
    viewModel.imageObserver = { [weak self] image in
      guard let strongSelf = self else { return }
      strongSelf.selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    // Configure isRegistering observer
    viewModel.isRegistering = { [weak self] isRegistering in
      guard let strongSelf = self else { return }
      
      if isRegistering == true {
        strongSelf.resgisterHud.textLabel.text = "Register"
        strongSelf.resgisterHud.show(in: strongSelf.view)
      } else {
        strongSelf.resgisterHud.dismiss()
      }
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
  
  // MARK: - Actions
  
  @objc private func handleRegisterButtonTapped() {
    // Dismiss keyboard when user attempts to login
    handleTapDismiss()
    
    // Create user registration
    viewModel.performRagistration { [weak self] error in
      if let error = error {
        guard let strongSelf = self else { return }
        strongSelf.showHudWithError(with: error)
        return
      }
    }
  }
  
  @objc private func handleSelectButtontapped() {
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    present(imagePickerController, animated: true)
  }
  
  // MARK: - Alerts
  
  private func showHudWithError(with error: Error) {
    // Dismiss Register Hud
    resgisterHud.dismiss()
    
    // Configure Registration Error Hud
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Failed to Register"
    hud.detailTextLabel.text = error.localizedDescription
    hud.show(in: view)
    hud.dismiss(afterDelay: 4)
  }
}

extension RegistrationViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let selectedImage = info[.originalImage] as? UIImage
    
    viewModel.image = selectedImage
    
    // Dismiss UIPicker Controller
    dismiss(animated: true)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true)
  }
}