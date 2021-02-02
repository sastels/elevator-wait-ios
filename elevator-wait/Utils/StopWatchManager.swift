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
  private var previousSecondsElapsed = 0.0
  private var startTime: Date?
  private var timer = Timer()

  func start() {
    mode = .running
    startTime = Date()
    timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
      let timeDiff = Date().timeIntervalSinceReferenceDate - self.startTime!.timeIntervalSinceReferenceDate
      self.secondsElapsed = self.previousSecondsElapsed + timeDiff
    }
  }

  func pause() {
    mode = .paused
    previousSecondsElapsed = secondsElapsed
    timer.invalidate()
    startTime = nil
  }

  func stop() {
    mode = .stopped
    timer.invalidate()
    startTime = nil
    secondsElapsed = 0.0
    previousSecondsElapsed = 0.0
  }
}
