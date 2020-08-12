//
//  SettingsTableViewCell.swift
//  TinderDemo
//
//  Created by Dennis Vera on 8/4/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit

final class SettingsTableViewCell: UITableViewCell {
  
  // MARK: - Static Properties
  
  static var reuseIdentifier: String {
    return String(describing: self)
  }
  
  // MARK - Properties
  
  
  // MARK: Initialization
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .lightGray
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
