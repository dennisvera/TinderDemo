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
  
  func sceneDidDisconnect(_ scene: UIScene) {}
  
  func sceneDidBecomeActive(_ scene: UIScene) {}
  
  func sceneWillResignActive(_ scene: UIScene) {}
  
  func sceneWillEnterForeground(_ scene: UIScene) {}
  
  func sceneDidEnterBackground(_ scene: UIScene) {}
}
