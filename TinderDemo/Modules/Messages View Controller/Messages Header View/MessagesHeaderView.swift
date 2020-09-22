//
//  MessagesHeaderView.swift
//  TinderDemo
//
//  Created by Dennis Vera on 9/22/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit

final class MessagesHeaderView: UICollectionReusableView {
  
  // MARK: - Static Properties
  
  static var reuseIdentifier: String {
    return String(describing: self)
  }
  
  // MARK: - Properties
  
  private let newMatchesLabel: MatchesHeaderLabel = {
    let label = MatchesHeaderLabel()
    label.text = "New Matches"
    label.textColor = #colorLiteral(red: 0.9960784314, green: 0.4352941176, blue: 0.4588235294, alpha: 1)
    label.font = .boldSystemFont(ofSize: 18)
    return label
  }()
  
  private let messagesLabel: MatchesHeaderLabel = {
    let label = MatchesHeaderLabel()
    label.text = "Messages"
    label.textColor = #colorLiteral(red: 0.9960784314, green: 0.4352941176, blue: 0.4588235294, alpha: 1)
    label.font = .boldSystemFont(ofSize: 18)
    return label
  }()
  
  private let matchesHorizontalViewController: MatchesHorizontalViewController = {
    let view = MatchesHorizontalViewController()
    return view
  }()
  
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
    backgroundColor = .white
    
    // Instantiate Stack View
    let stackView = UIStackView(arrangedSubviews: [newMatchesLabel, matchesHorizontalViewController.view, messagesLabel])
    stackView.spacing = 20
    stackView.axis = .vertical
    
    // Constraint Stack View
    addSubview(stackView)
    stackView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-20)
    }
  }
}
