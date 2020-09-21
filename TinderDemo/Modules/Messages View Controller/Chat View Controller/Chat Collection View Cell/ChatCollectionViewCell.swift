//
//  ChatCollectionViewCell.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/18/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit

class ChatCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Static Properties
  
  static var reuseIdentifier: String {
    return String(describing: self)
  }
  
  // MARK: - Properties
  
  private let textView: UITextView = {
    let textView = UITextView()
    textView.isEditable = false
    textView.isScrollEnabled = false
    textView.backgroundColor = .clear
    textView.font = .systemFont(ofSize: 20)
    return textView
  }()
  
  private let bubbleContainer: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 12
    return view
  }()
  
  private var leadingConstraint: Constraint?
  private var trailingConstraint: Constraint?
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Helper Methods
  
  private func setupView() {
    // Configure Bubble Container
    addSubview(bubbleContainer)
    bubbleContainer.snp.makeConstraints {
      $0.width.lessThanOrEqualTo(250)
      $0.topMargin.bottomMargin.equalToSuperview()
      leadingConstraint = $0.leading.equalToSuperview().offset(20).constraint
      trailingConstraint = $0.trailing.equalToSuperview().offset(-20).constraint
    }
        
    // Configure Text Label
    bubbleContainer.addSubview(textView)
    textView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(4)
      $0.bottom.equalToSuperview().offset(-4)
      $0.leading.equalToSuperview().offset(12)
      $0.trailing.equalToSuperview().offset(-12)
    }
  }
  
  // MARK: - Public Methods
  
  func configure(with message: Message) {
    if message.isCurrentLoggedUser {
      textView.text = message.text
      textView.textColor = .white
      bubbleContainer.backgroundColor = #colorLiteral(red: 0.06338243932, green: 0.7635894418, blue: 0.9986205697, alpha: 1)
      
      leadingConstraint?.deactivate()
      trailingConstraint?.activate()
    } else {
      textView.text = message.text
      textView.textColor = .black
      bubbleContainer.backgroundColor = #colorLiteral(red: 0.9058129191, green: 0.905921638, blue: 0.9057757854, alpha: 1)
      
      leadingConstraint?.activate()
      trailingConstraint?.deactivate()
    }
  }
}
