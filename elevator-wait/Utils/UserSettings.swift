//
//  UserSettings.swift
//  elevator-wait
//
//  Created by Stephen Astels on 2021-02-01.
//

import Foundation
import Combine

class UserSettings: ObservableObject {
    @Published var timerName: String {
        didSet {
            UserDefaults.standard.set(timerName, forKey: "timerName")
        }
    }
    
    init() {
        self.timerName = UserDefaults.standard.object(forKey: "timerName") as? String ?? "test"
    }
}
