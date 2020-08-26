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
    }
  }
  
  // MARK: -
  
  private var photoControllers = [UIViewController]()
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
  }
  
  // MARK: - Helper Methods
  
  private func setupView() {
    // Set Background Color
    view.backgroundColor = .white
    
    // Set Paging DataSource to self
    dataSource = self
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
