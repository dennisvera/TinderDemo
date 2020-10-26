//
//  SettingsTableViewCell.swift
//  TinderDemo
//
//  Created by Dennis Vera on 8/4/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit

final class SettingsTableViewCell: UITableViewCell {
  
  // MARK: - Static Properties
  
  static var reuseIdentifier: String {
    return String(describing: self)
  }
  
  // MARK: - Properties
  
  let textField: UITextField = {
    let textField = SettingsTextField()
    return textField
  }()
  
  // MARK: Initialization
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupTextField()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private Methods
  
  private func setupTextField() {
    addSubview(textField)
    textField.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  // MARK: - Public Methods
  
  func configureName(with user: User?) {
    textField.text = user?.name
    textField.placeholder = Strings.enterName
  }
  
  func configureProfession(with user: User?) {
    textField.text = user?.profession
    textField.placeholder = Strings.enterProfession
  }
  
  func configureAge(with user: User?) {
    if let age = user?.age {
      textField.text = String(age)
    }
    
    textField.placeholder = Strings.enterAge
  }
  
  func configureBio(with user: User?) {
    textField.text = user?.bio
    textField.placeholder = Strings.enterBio
  }
}
