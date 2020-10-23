//
//  SceneDelegate.swift
//  TinderDemo
//
//  Created by Dennis Vera on 7/9/20.
//  Copyright © 2020 Dennis Vera. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UNUserNotificationCenterDelegate {
  
  // MARK: - Properties
  
  var window: UIWindow?
  
  // MARK: -
  
  private let appCoordinator = AppCoordinator()
  
  // MARK: - Application Life Cycle
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Configure Firebase - Must be Called Before Main Window is Initialized
    FirebaseApp.configure()
    let firestore = Firestore.firestore()
    let settings = firestore.settings
    settings.areTimestampsInSnapshotsEnabled = true
    firestore.settings = settings
    
    // Initialize and Configure Window
    guard let windowScene = scene as? UIWindowScene else { return }
    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = appCoordinator.rootViewController
    window?.makeKeyAndVisible()
    
    // Start Coordinator
    appCoordinator.start()
    
    // Setup Push Notifications
    setupPushNotifications()
  }
  
  // MARK: - Push Notifications Methods
  
  private func setupPushNotifications() {
    UNUserNotificationCenter.current().delegate = self
    
    // Request Permission to Show Push Notifications
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(granted, error) in
      // Make sure permission to receive push notifications is granted
      print("Permission is granted: \(granted)")
    }
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    print("Push notification received in foreground.")
    completionHandler([.alert, .sound, .badge])
  }
  
  // MARK: - Scene Helper methods
  
  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }
}
