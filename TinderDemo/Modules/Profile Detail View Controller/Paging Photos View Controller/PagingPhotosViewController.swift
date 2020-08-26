//
//  PagingPhotosViewController.swift
//  TinderDemo
//
//  Created by Dennis Vera on 8/16/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import SnapKit

class PagingPhotosViewController: UIPageViewController {
  
  // MARK: - Properties
  
  var cardViewModel: CardViewViewModel! {
    didSet {
      photoControllers = cardViewModel.imageUrls.map({ imageUrl -> UIViewController in
        let photoController = PhotoViewController(imageUrl: imageUrl)
        return photoController
      })
      
      // Set View Controllers paging starting at the first index of the photoControllers array
      guard let firstController = photoControllers.first else { return }
      setViewControllers([firstController], direction: .forward, animated: false)
      
      setupPhotoBarsView()
    }
  }
  
  // MARK: -
  
  private var photoControllers = [UIViewController]()
  private var photoBarsStackView = UIStackView(arrangedSubviews: [])
  private let deselectedPhotoBarColor = UIColor(white: 0.0, alpha: 0.1)
    
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
  }
  
  // MARK: - Helper Methods
  
  private func setupView() {
    // Set Background Color
    view.backgroundColor = .white
    
    // Set Paging DataSource & Delegate to self
    dataSource = self
    delegate = self
  }
  
  private func setupPhotoBarsView() {
    cardViewModel.imageUrls.forEach { _ in
      let barView = UIView()
      barView.layer.cornerRadius = 2
      barView.backgroundColor = deselectedPhotoBarColor
      
      photoBarsStackView.addArrangedSubview(barView)
    }
    
    photoBarsStackView.spacing = 4
    photoBarsStackView.axis = .horizontal
    photoBarsStackView.distribution = .fillEqually
    photoBarsStackView.arrangedSubviews.first?.backgroundColor = .white
    
    // Using the SafeAreaLayoutGuide caused flickering when pulling the image down,
    // instead we are grabbing the statusBarFrame height to anchor the top of the photoBarsStackView
    let statusBarFrameHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    let photoBarTopPadding = Int(statusBarFrameHeight) + 8
    
    view.addSubview(photoBarsStackView)
    photoBarsStackView.snp.makeConstraints { make in
      make.height.equalTo(4)
      make.leading.equalToSuperview().offset(8)
      make.trailing.equalToSuperview().offset(-8)
      make.top.equalTo(view.snp.topMargin).offset(photoBarTopPadding)
    }
  }
}

// MARK: - UIPageViewControllerDataSource

extension PagingPhotosViewController: UIPageViewControllerDataSource {
  
  func pageViewController(_ pageViewController: UIPageViewController,
                          viewControllerAfter viewController: UIViewController) -> UIViewController? {
    // Set index to start at the first item of the photoControllers array
    let index = photoControllers.firstIndex(where: { $0 == viewController }) ?? 0
    
    // return nil when you reach the last item of the photoControllers array
    if index == photoControllers.count - 1 { return nil }
    
    // Increment the controller by one as you swipe right
    return photoControllers[index + 1]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController,
                          viewControllerBefore viewController: UIViewController) -> UIViewController? {
    // Set index to start at the first item of the photoControllers array
    let index = photoControllers.firstIndex(where: { $0 == viewController }) ?? 0
    
    // return nil if the arrray equals zero
    if index == 0 { return nil }
    
    // Decrease the controller by one as you swipe left
    return photoControllers[index - 1]
  }
}

// MARK: - UIPageViewControllerDelegate

extension PagingPhotosViewController: UIPageViewControllerDelegate {
 
  func pageViewController(_ pageViewController: UIPageViewController,
                          didFinishAnimating finished: Bool,
                          previousViewControllers: [UIViewController],
                          transitionCompleted completed: Bool) {
    
    let currentPhotoController = viewControllers?.first
    guard let index = photoControllers.firstIndex(where: { $0 == currentPhotoController }) else { return }
    
    photoBarsStackView.arrangedSubviews.forEach { $0.backgroundColor = deselectedPhotoBarColor }
    photoBarsStackView.arrangedSubviews[index].backgroundColor = .white
  }
}
