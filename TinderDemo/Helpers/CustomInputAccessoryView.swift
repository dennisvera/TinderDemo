//
//  CustomInputAccessoryView.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/21/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit

final class CustomInputAccessoryView: UIView {
  
  // MARK: - Properties
  
  private let placeHolderLabel: UILabel = {
    let label = UILabel()
    label.text = "Enter Comment"
    label.textColor = .lightGray
    label.font = .systemFont(ofSize: 16)
    return label
  }()
  
  private let textView: UITextView = {
    let textView = UITextView()
    textView.isScrollEnabled = false
    textView.font = .systemFont(ofSize: 16)
    return textView
  }()
  
  private let sendButton: UIButton = {
    let button = UIButton()
    button.setTitle("Send", for: .normal)
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupView()
    setupShadow()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: - Overrides
  
  override var intrinsicContentSize: CGSize {
    return .zero
  }
  
  // MARK: Helper Methods
  
  private func setupView() {
    // Set background color
    backgroundColor = .white
    
    // Resize views height
    autoresizingMask = .flexibleHeight
    
    // Configure Send Button
    sendButton.snp.makeConstraints {
      $0.width.height.equalTo(60)
    }
    
    // Instantiate Stack View
    let stackView = UIStackView(arrangedSubviews: [textView, sendButton])
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.isLayoutMarginsRelativeArrangement = true
    
    // Configure Stack View
    addSubview(stackView)
    stackView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.leading.equalToSuperview().offset(16)
      $0.trailing.equalToSuperview().offset(-16)
    }
    
    // Configure Placeholder Label
    addSubview(placeHolderLabel)
    placeHolderLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalTo(sendButton.snp.centerY)
      $0.trailing.equalTo(sendButton.snp.leading)
    }
    
    // Set Text View Notification Center
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(handleTextChange),
                                           name: UITextView.textDidChangeNotification,
                                           object: nil)
  }
  
  private func setupShadow() {
    layer.shadowRadius = 8
    layer.shadowOpacity = 0.2
    layer.shadowOffset = CGSize(width: 0, height: -10)
    layer.shadowColor = UIColor(white: 0, alpha: 0.3).cgColor
  }
  
  @objc private func handleTextChange() {
    placeHolderLabel.isHidden = textView.text.count != 0
  }
}
