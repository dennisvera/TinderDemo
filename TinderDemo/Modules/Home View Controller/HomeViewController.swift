//
//  ViewController.swift
//  TinderDemo
//
//  Created by Dennis Vera on 7/9/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
  
  // MARK: - Properties
  
  private let cardsDeckView: UIView = {
    let view = UIView()
    return view
  }()
  
  private let topStackView = TopNavigationStackView()
  private let bottomStackView = HomeBottomControlStackView()
  
  private let users = [
    User(name: "Kelly", age: 23, profession: "Music DJ", imageName: "kelly"),
    User(name: "Jane", age: 18, profession: "Teacher", imageName: "jane")
  ]
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    setupCardview()
  }
  
  // MARK: - Helper Methods
  
  private func setupView() {
    view.backgroundColor = .white
    
    let mainStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomStackView])
    mainStackView.axis = .vertical
    
    view.addSubview(mainStackView)
    mainStackView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
    
    mainStackView.bringSubviewToFront(cardsDeckView)
    
    // Set constraints Relative to the SuperView Margins
    mainStackView.isLayoutMarginsRelativeArrangement = true
    mainStackView.layoutMargins = .init(top: Layout.zero,
                                        left: Layout.leadingMarging,
                                        bottom: Layout.zero,
                                        right: Layout.leadingMarging)
  }
  
  private func setupCardview() {
    users.forEach { (user) in
      let cardView = CardView()
      cardView.profileImageView.image = UIImage(named: user.imageName)
      
      let attributedText = NSMutableAttributedString(string: user.name,
                                                     attributes: [.font: UIFont.systemFont(ofSize: 34,
                                                                                           weight: .heavy)])
      attributedText.append(NSAttributedString(string: " \(user.age)",
        attributes: [.font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
      
      attributedText.append(NSAttributedString(string: "\n\(user.profession)",
        attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
      
      cardView.userInformationLabel.attributedText = attributedText
      
      cardsDeckView.addSubview(cardView)
      cardView.snp.makeConstraints { make in
        make.edges.equalToSuperview()
      }
    }
  }
}

extension HomeViewController {
  
  // MARK: - Types
  
  enum Layout {
    static let zero: CGFloat = 0
    static let leadingMarging: CGFloat = 8
  }
}
