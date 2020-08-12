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

final class SettingsViewController: UIViewController {
  
  // MARK: Properties
  
  let tableView = UITableView(frame: .zero, style: .plain)
  
  lazy var header = createHeader()
  lazy var imageButton1 = createHeaderButton(with: #selector(handleSelectedPhoto(button:)))
  lazy var imageButton2 = createHeaderButton(with: #selector(handleSelectedPhoto(button:)))
  lazy var imageButton3 = createHeaderButton(with: #selector(handleSelectedPhoto(button:)))
  
  var user: User?
  
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
    tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.reuseIdentifier)
  }
  
  private func fetchCurrentUser() {
    guard let userUid = Auth.auth().currentUser?.uid else { return }
    
    Firestore.firestore().collection("users").document(userUid).getDocument { [weak self] (snapshot, error) in
      guard let strongSelf = self else { return }
      
      if let error = error {
        print(error)
        return
      }
      
      // Fetch user data
      guard let dictionary = snapshot?.data() else { return }
      strongSelf.user = User(dictionary: dictionary)
      strongSelf.loadUserPhotos()
      
      // Reload data before populating the fetch user data on the view
      strongSelf.tableView.reloadData()
    }
  }
  
  private func loadUserPhotos() {
    guard let imageUrl = user?.imageUrl1, let url = URL(string: imageUrl) else { return }
    
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
  
  // MARK: Actions
  
  @objc private func handleCancel() {
    dismiss(animated: true)
  }
  
  @objc private func handleLogout() {
    dismiss(animated: true)
  }
  
  @objc private func handleSave() {
    dismiss(animated: true)
  }
  
  @objc private func handleSelectedPhoto(button: UIButton) {
    let customImagePicker = CustomImagePicker()
    customImagePicker.delegate = self
    customImagePicker.imageButton = button
    present(customImagePicker, animated: true)
  }
}

// MARK: - TableViewDataSource

extension SettingsViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == 0 ? 0 : 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseIdentifier,
                                                   for: indexPath) as? SettingsTableViewCell else {
                                                    fatalError("\n" + "Unable to Dequeue Cell") }
    switch indexPath.section {
    case 1:
      cell.textField.placeholder = "Enter Name"
      cell.textField.text = user?.name
    case 2:
      cell.textField.placeholder = "Enter Profession"
      cell.textField.text = user?.profession
    case 3:
      cell.textField.placeholder = "Enter Age"
      if let age = user?.age {
        cell.textField.text = String(age)
      }
    default:
      cell.textField.placeholder = "Enter Bio"
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
    headerLabel.font = .boldSystemFont(ofSize: 18)
    
    switch section {
    case 1:
      headerLabel.text = "Name"
    case 2:
      headerLabel.text = "Profession"
    case 3:
      headerLabel.text = "Age"
    default:
      headerLabel.text = "Bio"
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
    
    // Pass and set the selected image to the button
    let imageButton = (picker as? CustomImagePicker)?.imageButton
    imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
    
    // Dismiss UIPicker Controller
    dismiss(animated: true)
  }
}
