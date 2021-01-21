//
//  StopWatchManager.swift
//  elevator-wait
//
//  Created by Stephen Astels on 2021-01-19.
//
// from https://blckbirds.com/post/creating-a-simple-stopwatch-in-swiftui/

import Foundation

import SwiftUI
enum StopWatchMode {
  case running
  case stopped
  case paused
}

class StopWatchManager: ObservableObject {
  @Published var secondsElapsed = 0.0
  @Published var mode: StopWatchMode = .stopped

  var timer = Timer()

  func start() {
    print("Timer started!")
    mode = .running
    timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
      self.secondsElapsed += 0.1
    }
  }

  func pause() {
    timer.invalidate()
    mode = .paused
  }

  func stop() {
    timer.invalidate()
    secondsElapsed = 0
    mode = .stopped
  }
}
