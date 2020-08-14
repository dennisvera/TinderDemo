//
//  SettingsViewController.swift
//  TinderDemo
//
//  Created by Dennis Vera on 8/3/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import SDWebImage
import JGProgressHUD

protocol SettingsViewControllerDelegate {
  func didSaveSettings()
}

final class SettingsViewController: UIViewController {
  
  // MARK: Properties
  
  let tableView = UITableView(frame: .zero, style: .plain)
  
  // MARK: -
  
  lazy var header = createHeader()
  lazy var imageButton1 = createHeaderButton(with: #selector(handleSelectedPhoto(button:)))
  lazy var imageButton2 = createHeaderButton(with: #selector(handleSelectedPhoto(button:)))
  lazy var imageButton3 = createHeaderButton(with: #selector(handleSelectedPhoto(button:)))
  
  // MARK: -
  
  var user: User?
  var deleagate: SettingsViewControllerDelegate?
  
  // MARK: View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableViewController()
    setupNavigationController()
    fetchCurrentUser()
  }
  
  private func setupNavigationController() {
    navigationItem.title = "Settings"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                       style: .plain,
                                                       target: self,
                                                       action: #selector(handleCancel))
    
    navigationItem.rightBarButtonItems = [ UIBarButtonItem(title: "Save",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(handleSave)),
                                           UIBarButtonItem(title: "Logout",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(handleLogout))]
  }
  
  private func setupTableViewController() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.allowsSelection = false
    tableView.separatorStyle = .none
    tableView.keyboardDismissMode = .interactive
    tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    tableView.register(SettingsTableViewCell.self,
                       forCellReuseIdentifier: SettingsTableViewCell.reuseIdentifier)
    tableView.register(AgeRangeTableViewCell.self,
                       forCellReuseIdentifier: AgeRangeTableViewCell.reuseIdentifier)
  }
  
  private func fetchCurrentUser() {
    Firestore.firestore().fetchCurrentUser { [weak self] (user, error) in
      guard let strongSelf = self else { return }

      if let error = error {
        print("Failed to Fetch User:", error)
        return
      }
      
      // Set user
      strongSelf.user = user
      
      // Load user photos
      strongSelf.loadUserPhotos()
      
      // Reload data before populating the fetch user data on the view
      strongSelf.tableView.reloadData()
    }
  }
  
  private func loadUserPhotos() {
    if let imageUrl = user?.imageUrl1, let url = URL(string: imageUrl) {
      // The SDWebImageManager will handle chaching the image for us.
      /// Chaching the image  saves the image on the phone  after  its been fetched the first time,
      /// thiis will guarante we dont fetch an imagea again that  we have previously loaded..
      SDWebImageManager.shared.loadImage(with: url,
                                         options: .continueInBackground,
                                         progress: nil) { [weak self] (image, _, _, _, _, _) in
                                          
                                          guard let strongSelf = self else { return }
                                          strongSelf.imageButton1.setImage(image?.withRenderingMode(.alwaysOriginal),
                                                                           for: .normal)
      }
    }
    
    if let imageUrl = user?.imageUrl2, let url = URL(string: imageUrl) {
      SDWebImageManager.shared.loadImage(with: url,
                                         options: .continueInBackground,
                                         progress: nil) { [weak self] (image, _, _, _, _, _) in
                                          
                                          guard let strongSelf = self else { return }
                                          strongSelf.imageButton2.setImage(image?.withRenderingMode(.alwaysOriginal),
                                                                           for: .normal)
      }
    }
    
    if let imageUrl = user?.imageUrl3, let url = URL(string: imageUrl) {
      SDWebImageManager.shared.loadImage(with: url,
                                         options: .continueInBackground,
                                         progress: nil) { [weak self] (image, _, _, _, _, _) in
                                          
                                          guard let strongSelf = self else { return }
                                          strongSelf.imageButton3.setImage(image?.withRenderingMode(.alwaysOriginal),
                                                                           for: .normal)
      }
    }
  }
  
  private func createHeader() -> UIView {
    let header = UIView()
    
    header.addSubview(imageButton1)
    imageButton1.snp.makeConstraints { make in
      make.bottom.equalToSuperview().offset(-16)
      make.top.leading.equalToSuperview().offset(16)
      make.width.equalToSuperview().multipliedBy(0.45)
    }
    
    let verticalStackView = UIStackView(arrangedSubviews: [imageButton2, imageButton3])
    verticalStackView.spacing = 16
    verticalStackView.axis = .vertical
    verticalStackView.distribution = .fillEqually
    
    header.addSubview(verticalStackView)
    verticalStackView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(16)
      make.bottom.trailing.equalToSuperview().offset(-16)
      make.leading.equalTo(imageButton1.snp.trailing).offset(16)
    }
    
    return header
  }
  
  private func createHeaderButton(with selector: Selector) -> UIButton {
    let button = UIButton(type: .system)
    button.clipsToBounds = true
    button.layer.cornerRadius = 8
    button.backgroundColor = .white
    button.imageView?.contentMode = .scaleToFill
    button.setTitle("Select Photo", for: .normal)
    button.addTarget(self, action: selector, for: .touchUpInside)
    return button
  }
  
  private func evaluateMinAndMaxSliderValue() {
    guard let ageRangeCell = tableView.cellForRow(at: [5, 0]) as? AgeRangeTableViewCell else { return }
    let minValue = Int(ageRangeCell.minSlider.value)
    var maxValue = Int(ageRangeCell.maxSlider.value)
    
    maxValue = max(minValue, maxValue)
    
    ageRangeCell.maxSlider.value = Float(maxValue)
    ageRangeCell.minLabel.text = "Min: \(minValue)"
    ageRangeCell.maxLabel.text = "Max: \(maxValue)"
    
    user?.minSeekingAge = minValue
    user?.maxSeekingAge = maxValue
  }
  
  // MARK: - Actions
  
  @objc private func handleCancel() {
    // Dismiss View Controller
    dismiss(animated: true)
  }
  
  @objc private func handleLogout() {
    try? Auth.auth().signOut()
    
    // Dismiss View Controller
    dismiss(animated: true)
  }
  
  @objc private func handleSave() {
    // Save users info to Firestore
    guard let userUid = Auth.auth().currentUser?.uid else { return }
    
    let documentData: [String: Any] = [
      "uid" : userUid,
      "age" : user?.age ?? -1,
      "bio" : user?.bio ?? "",
      "fullName" : user?.name ?? "",
      "imageUrl1" : user?.imageUrl1 ?? "",
      "imageUrl2" : user?.imageUrl2 ?? "",
      "imageUrl3" : user?.imageUrl3 ?? "",
      "profession" : user?.profession ?? "",
      "minSeekingAge" : user?.minSeekingAge ?? -1,
      "maxSeekingAge" : user?.maxSeekingAge ?? -1
    ]
    
    let progressHud = JGProgressHUD(style: .dark)
    progressHud.textLabel.text = "Saving settings"
    
    Firestore.firestore()
      .collection("users")
      .document(userUid)
      .setData(documentData) { [weak self] error in
        progressHud.dismiss()
        
        if let error = error {
          print("Failed to save user's settings to Firestore:", error)
        }
        
        print("Saved user info to Firestore")
        
        guard let strongSelf = self else { return }
        strongSelf.dismiss(animated: true) {
          // Refresh cards in HomeViewController via delegate
          strongSelf.deleagate?.didSaveSettings()
        }
    }
  }
  
  @objc private func handleSelectedPhoto(button: UIButton) {
    let customImagePicker = CustomImagePicker()
    customImagePicker.delegate = self
    customImagePicker.imageButton = button
    present(customImagePicker, animated: true)
  }
  
  @objc private func handleMinAgeChange(slider: UISlider) {
    evaluateMinAndMaxSliderValue()
  }
  
  @objc private func handleMaxAgeChange(slider: UISlider) {
    evaluateMinAndMaxSliderValue()
  }
  
  // MARK: - Actions / Save User Info
  
  @objc private func handleNameChange(textField: UITextField) {
    user?.name = textField.text
  }
  
  @objc private func handleProfessionChange(textField: UITextField) {
    user?.profession = textField.text
  }
  
  @objc private func handleAgeChange(textField: UITextField) {
    user?.age = Int(textField.text ?? "")
  }
  
  @objc private func handleBioChange(textField: UITextField) {
    user?.bio = textField.text
  }
}

// MARK: - TableViewDataSource

extension SettingsViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 6
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == 0 ? 0 : 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseIdentifier,
                                                   for: indexPath) as? SettingsTableViewCell else {
                                                    fatalError("\n" + "Unable to Dequeue Settings Cell") }
    switch indexPath.section {
    case 1:
      cell.textField.text = user?.name
      cell.textField.placeholder = "Enter Name"
      cell.textField.addTarget(self, action: #selector(handleNameChange(textField:)),
                               for: .editingChanged)
    case 2:
      cell.textField.text = user?.profession
      cell.textField.placeholder = "Enter Profession"
      cell.textField.addTarget(self, action: #selector(handleProfessionChange(textField:)),
                               for: .editingChanged)
    case 3:
      if let age = user?.age {
        cell.textField.text = String(age)
      }
      cell.textField.placeholder = "Enter Age"
      cell.textField.addTarget(self, action: #selector(handleAgeChange(textField:)),
                               for: .editingChanged)
    case 4:
      cell.textField.text = user?.bio
      cell.textField.placeholder = "Enter Bio"
      cell.textField.addTarget(self, action: #selector(handleBioChange(textField:)),
                               for: .editingChanged)
    default:
      print("")
    }
    
    if indexPath.section == 5 {
      let ageRangeCell = AgeRangeTableViewCell(style: .default, reuseIdentifier: nil)
      ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinAgeChange(slider:)), for: .valueChanged)
      ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxAgeChange(slider:)), for: .valueChanged)
      
      if let minAge = user?.minSeekingAge, let maxAge = user?.maxSeekingAge {
        // Set the AgeRangeCell min and max labels
        ageRangeCell.minLabel.text = "Min: \(minAge)"
        ageRangeCell.maxLabel.text = "Max: \(maxAge)"
        
        // Set the AgeRangeCell min and max sliders
        ageRangeCell.minSlider.value = Float(minAge)
        ageRangeCell.maxSlider.value = Float(maxAge)
        
        return ageRangeCell
      }
    }
    
    return cell
  }
}

// MARK: UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == 0 {
      return header
    }
    
    let headerLabel = SettingsHeaderLabel()
    headerLabel.font = .boldSystemFont(ofSize: 16)
    
    switch section {
    case 1:
      headerLabel.text = "Name"
    case 2:
      headerLabel.text = "Profession"
    case 3:
      headerLabel.text = "Age"
    case 4:
      headerLabel.text = "Bio"
    default:
      headerLabel.text = "Seeking Age Range"
    }
    
    return headerLabel
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 300
    }
    
    return 40
  }
}

// MARK: - UIImagePickerControllerDelegate

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    // Get selected image
    let selectedImage = info[.originalImage] as? UIImage
    
    // Set the selected image to the button
    let imageButton = (picker as? CustomImagePicker)?.imageButton
    imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
    
    // Dismiss UIPicker Controller
    dismiss(animated: true)
    
    // Store Image to FireBase Storage
    let fileName = UUID().uuidString
    let reference = Storage.storage().reference(withPath: "/images/\(fileName)")
    guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.75) else { return }
    
    let progressHud = JGProgressHUD(style: .dark)
    progressHud.textLabel.text = "Uploading Image ..."
    progressHud.show(in: view)
    
    reference.putData(uploadData, metadata: nil) { _, error in
      if let error = error {
        progressHud.dismiss()
        print("Failed to upload image to Firebase storage:", error)
        return
      }
      
      print("Finished uploading user's settings image")
      
      // Retrieve the Image download URL
      reference.downloadURL { [weak self] (url, error) in
        progressHud.dismiss()
        
        if let error = error {
          print("Failed to retrieve image download url:", error)
        }
        
        // Set the selected image to the selected button
        guard let strongSelf = self else { return }
        if imageButton == strongSelf.imageButton1 {
          strongSelf.user?.imageUrl1 = url?.absoluteString
        } else if imageButton == strongSelf.imageButton2 {
          strongSelf.user?.imageUrl2 = url?.absoluteString
        } else {
          strongSelf.user?.imageUrl3 = url?.absoluteString
        }
      }
    }
  }
}
