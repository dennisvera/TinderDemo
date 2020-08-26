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
  private var photoTopBarStackView = UIStackView(arrangedSubviews: [])
  private let deselectedPhotoBarColor = UIColor(white: 0.0, alpha: 0.1)
  
  // MARK: -
  
  private let isCardViewMode: Bool
  
  // MARK: - Initialization
  
  init(isCardViewMode: Bool = false) {
    self.isCardViewMode = isCardViewMode
    
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
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
    
    // Disable Paging if isCardViewMode
    if isCardViewMode {
      disablePhotoPaging()
    }
    
    // Set tap Gesture
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:))))
  }
  
  private func setupPhotoBarsView() {
    cardViewModel.imageUrls.forEach { _ in
      let barView = UIView()
      barView.layer.cornerRadius = 2
      barView.backgroundColor = deselectedPhotoBarColor
      
      photoTopBarStackView.addArrangedSubview(barView)
    }
    
    photoTopBarStackView.spacing = 4
    photoTopBarStackView.axis = .horizontal
    photoTopBarStackView.distribution = .fillEqually
    photoTopBarStackView.arrangedSubviews.first?.backgroundColor = .white
    
    // Using the SafeAreaLayoutGuide caused flickering when pulling the image down,
    // instead we are grabbing the statusBarFrame height to anchor the top of the photoBarsStackView
    let statusBarFrameHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    var photoBarTopPadding = 8
    
    if !isCardViewMode {
      photoBarTopPadding += Int(statusBarFrameHeight)
    }
    
    view.addSubview(photoTopBarStackView)
    photoTopBarStackView.snp.makeConstraints { make in
      make.height.equalTo(4)
      make.leading.equalToSuperview().offset(8)
      make.trailing.equalToSuperview().offset(-8)
      make.top.equalTo(view.snp.topMargin).offset(photoBarTopPadding)
    }
  }
  
  // Helper method to disable the scrolling when
  // the PagingPhotosViewController is used in the CardView
  private func disablePhotoPaging() {
    view.subviews.forEach { view in
      if let view = view as? UIScrollView {
        view.isScrollEnabled = false
      }
    }
  }
  
  // MARK: - Actions
  
  @objc private func handleTap(gesture: UITapGestureRecognizer) {
    // Grab the first controller
    guard let currenController = viewControllers?.first else { return }
    guard let index = photoControllers.firstIndex(of: currenController) else { return }
    
    // Set Photo Top Bar color to dark for non selected images
    photoTopBarStackView.arrangedSubviews.forEach { $0.backgroundColor = deselectedPhotoBarColor }
    
    // Move to the next controller when tapped on the right side of the screen
    if gesture.location(in: self.view).x > view.frame.width / 2 {
      let nextIndex = min(index + 1, photoControllers.count - 1)
      let nextController = photoControllers[nextIndex]
      setViewControllers([nextController], direction: .forward, animated: false)
      
      // Set Photo Top Bar color to white for selected images
      photoTopBarStackView.arrangedSubviews[nextIndex].backgroundColor = .white
      
      // Move to the previous controller when tapped on the left side of the screen
    } else {
      let previousIndex = max(0, index - 1)
      let previousController = photoControllers[previousIndex]
      setViewControllers([previousController], direction: .reverse, animated: false)
      
      // Set Photo Top Bar color to white for selected images
      photoTopBarStackView.arrangedSubviews[previousIndex].backgroundColor = .white
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
    
    photoTopBarStackView.arrangedSubviews.forEach { $0.backgroundColor = deselectedPhotoBarColor }
    photoTopBarStackView.arrangedSubviews[index].backgroundColor = .white
  }
}
