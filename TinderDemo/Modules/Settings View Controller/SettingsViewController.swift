//
//  SettingsViewController.swift
//  TinderDemo
//
//  Created by Dennis Vera on 8/3/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit

final class SettingsViewController: UIViewController {
  
  // MARK: Properties
  
  let tableView = UITableView(frame: .zero, style: .plain)
  
  // MARK: View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
        
    setupTableViewController()
    setupNavigationController()
  }
  
  private func setupNavigationController() {
    navigationItem.title = "Settings"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                       style: .plain,
                                                       target: self,
                                                       action: #selector(handleCancel))
  }
  
  private func setupTableViewController() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.allowsSelection = false
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Id")
  }
  
  // MARK: Actions
  
  @objc private func handleCancel() {
    dismiss(animated: true)
  }
}

// MARK: - TableViewDataSource

extension SettingsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "Id", for: indexPath) as? UITableViewCell else {
      return UITableViewCell()
    }
    return cell
  }
}

// MARK: UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {}
