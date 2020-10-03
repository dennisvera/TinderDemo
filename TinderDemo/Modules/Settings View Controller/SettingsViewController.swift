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
import FirebaseAuth
import JGProgressHUD
import FirebaseFirestore

protocol SettingsViewControllerDelegate {
  func didSaveSettings()
}

final class SettingsViewController: UIViewController {
  
  // MARK: Properties
  
  private let tableView = UITableView(frame: .zero, style: .plain)
  
  // MARK: -
  
  private lazy var header = createHeader()
  private lazy var imageButton1 = createHeaderButton(with: #selector(handleSelectedPhoto(button:)))
  private lazy var imageButton2 = createHeaderButton(with: #selector(handleSelectedPhoto(button:)))
  private lazy var imageButton3 = createHeaderButton(with: #selector(handleSelectedPhoto(button:)))
  
  // MARK: -
  
  private var delegate: SettingsViewControllerDelegate?
  
  // MARK: -
  
  private let viewModel: SettingsViewModel
  private let progressHud = JGProgressHUD(style: .dark)
  
  // MARK: -
  
  static let defaultMinSeekingAge = 18
  static let defaultMaxSeekingAge = 50
  
  // MARK: -  Initialization
  
  init(viewModel: SettingsViewModel) {
    self.viewModel = viewModel
    
    super.init(nibName: nil, bundle: .main)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableViewController()
    setupNavigationController()
    fetchCurrentUser()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.navigationBar.isHidden = true
  }
  
  private func setupNavigationController() {
    navigationItem.title = Strings.settingsTitle
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: Strings.cancel,
                                                       style: .plain,
                                                       target: self,
                                                       action: #selector(handleCancel))
    
    navigationItem.rightBarButtonItems = [UIBarButtonItem(title: Strings.save,
                                                          style: .plain,
                                                          target: self,
                                                          action: #selector(handleSave)),
                                          UIBarButtonItem(title: Strings.logout,
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
    viewModel.fetchCurrentUser { [weak self] in
      guard let strongSelf = self else { return }
      
      // Load user photos
      strongSelf.loadUserPhotos()
      
      // Reload data before populating the fetch user data on the view
      strongSelf.tableView.reloadData()
    }
  }
  
  private func loadUserPhotos() {
    if let imageUrl = viewModel.user?.imageUrl1, let url = URL(string: imageUrl) {
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
    
    if let imageUrl = viewModel.user?.imageUrl2, let url = URL(string: imageUrl) {
      SDWebImageManager.shared.loadImage(with: url,
                                         options: .continueInBackground,
                                         progress: nil) { [weak self] (image, _, _, _, _, _) in
                                          
                                          guard let strongSelf = self else { return }
                                          strongSelf.imageButton2.setImage(image?.withRenderingMode(.alwaysOriginal),
                                                                           for: .normal)
      }
    }
    
    if let imageUrl = viewModel.user?.imageUrl3, let url = URL(string: imageUrl) {
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
    button.imageView?.contentMode = .scaleAspectFill
    button.setTitle(Strings.selectPhoto, for: .normal)
    button.addTarget(self, action: selector, for: .touchUpInside)
    return button
  }
  
  private func evaluateMinAndMaxSliderValue() {
    guard let ageRangeCell = tableView.cellForRow(at: [5, 0]) as? AgeRangeTableViewCell else { return }
    viewModel.evaluateMinAndMaxSliderValue(with: ageRangeCell)
  }
  
  // MARK: - Actions
  
  @objc private func handleCancel() {
    // Dismiss View Controller
    viewModel.handleCancel()
  }
  
  @objc private func handleLogout() {
    // Dismiss View Controller
    viewModel.handleSignOut()
  }
  
  @objc private func handleSave() {
    progressHud.textLabel.text = "Saving settings"
    
    // Save Current Users Info
    viewModel.handleSave { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.progressHud.dismiss()
      strongSelf.delegate?.didSaveSettings()
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
    viewModel.handleNameChange(with: textField)
  }
  
  @objc private func handleProfessionChange(textField: UITextField) {
    viewModel.handleProfessionChange(with: textField)
  }
  
  @objc private func handleAgeChange(textField: UITextField) {
    viewModel.handleAgeChange(with: textField)
  }
  
  @objc private func handleBioChange(textField: UITextField) {
    viewModel.handleBioChange(with: textField)
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
      cell.textField.text = viewModel.user?.name
      cell.textField.placeholder = Strings.enterName
      cell.textField.addTarget(self, action: #selector(handleNameChange(textField:)),
                               for: .editingChanged)
    case 2:
      cell.textField.text = viewModel.user?.profession
      cell.textField.placeholder = Strings.enterProfession
      cell.textField.addTarget(self, action: #selector(handleProfessionChange(textField:)),
                               for: .editingChanged)
    case 3:
      if let age = viewModel.user?.age {
        cell.textField.text = String(age)
      }
      cell.textField.placeholder = Strings.enterAge
      cell.textField.addTarget(self, action: #selector(handleAgeChange(textField:)),
                               for: .editingChanged)
    case 4:
      cell.textField.text = viewModel.user?.bio
      cell.textField.placeholder = Strings.enterBio
      cell.textField.addTarget(self, action: #selector(handleBioChange(textField:)),
                               for: .editingChanged)
    default:
      print("")
    }
    
    if indexPath.section == 5 {
      let ageRangeCell = AgeRangeTableViewCell(style: .default, reuseIdentifier: nil)
      ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinAgeChange(slider:)), for: .valueChanged)
      ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxAgeChange(slider:)), for: .valueChanged)
      
      let minSeekingAge = viewModel.user?.minSeekingAge ?? SettingsViewController.defaultMinSeekingAge
      let maxSeekingAge = viewModel.user?.maxSeekingAge ?? SettingsViewController.defaultMaxSeekingAge
      
      // Set the AgeRangeCell min and max labels
      ageRangeCell.minLabel.text = "Min: \(minSeekingAge)"
      ageRangeCell.maxLabel.text = "Max: \(maxSeekingAge)"
      
      // Set the AgeRangeCell min and max sliders
      ageRangeCell.minSlider.value = Float(minSeekingAge)
      ageRangeCell.maxSlider.value = Float(maxSeekingAge)
      
      return ageRangeCell
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
      headerLabel.text = Strings.capitalName
    case 2:
      headerLabel.text = Strings.capitalProfession
    case 3:
      headerLabel.text = Strings.capitalAge
    case 4:
      headerLabel.text = Strings.capitalBio
    default:
      headerLabel.text = Strings.seekingAgeRange
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
          strongSelf.viewModel.user?.imageUrl1 = url?.absoluteString
        } else if imageButton == strongSelf.imageButton2 {
          strongSelf.viewModel.user?.imageUrl2 = url?.absoluteString
        } else {
          strongSelf.viewModel.user?.imageUrl3 = url?.absoluteString
        }
      }
    }
  }
}
