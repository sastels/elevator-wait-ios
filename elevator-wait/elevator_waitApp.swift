//
//  elevator_waitApp.swift
//  elevator-wait
//
//  Created by Stephen Astels on 2021-01-19.
//

import Firebase
import SwiftUI
import UIKit

// no changes in your AppDelegate class
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct elevator_waitApp: App {
  // inject into SwiftUI life-cycle via adaptor !!!
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup {
      TimerView()
    }
  }
}
