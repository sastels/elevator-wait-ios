//
//  elevator_waitApp.swift
//  elevator-wait WatchKit Extension
//
//  Created by Stephen Astels on 2021-01-19.
//

import SwiftUI

@main
struct elevator_waitApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
