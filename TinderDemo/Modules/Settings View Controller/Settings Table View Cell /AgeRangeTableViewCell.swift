//
//  AgeRangeTableViewCell.swift
//  TinderDemo
//
//  Created by Dennis Vera on 8/13/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit

class AgeRangeTableViewCell: UITableViewCell {
  
  // MARK: - Static Properties
  
  static var reuseIdentifier: String {
    return String(describing: self)
  }

  // MARK: - Public Properties
  
  let minLabel: UILabel = {
    let label = AgeRangeLabel()
    return label
  }()
  
  let maxLabel: UILabel = {
    let label = AgeRangeLabel()
    return label
  }()
    
  let minSlider: UISlider = {
    let slider = UISlider()
    slider.minimumValue = 18
    slider.maximumValue = 100
    return slider
  }()
  
  let maxSlider: UISlider = {
    let slider = UISlider()
    slider.minimumValue = 18
    slider.maximumValue = 100
    return slider
  }()
  
  // MARK: - Initialization
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Helper Methods
  
  private func setupView() {
    backgroundColor = UIColor(white: 0.80, alpha: 1)
    
    let mainstackView = UIStackView(arrangedSubviews: [UIStackView(arrangedSubviews: [minLabel, minSlider]),
                                                       UIStackView(arrangedSubviews: [maxLabel, maxSlider])])
    mainstackView.axis = .vertical
    mainstackView.spacing = 16
    
    addSubview(mainstackView)
    mainstackView.snp.makeConstraints { make in
      make.leading.top.equalToSuperview().offset(16)
      make.trailing.bottom.equalToSuperview().offset(-16)
    }
  }
}
