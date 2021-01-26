//
//  TimerView.swift
//  elevator-wait WatchKit Extension
//
//  Created by Stephen Astels on 2021-01-21.
//

import SwiftUI

struct WatchButtonStyle: ButtonStyle {
  var bgColor: Color

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .font(.title3)
      .frame(minWidth: 0,
             maxWidth: .infinity)
      .foregroundColor(.white)
      .cornerRadius(40)
      .padding(5)
      .background(RoundedRectangle(cornerRadius: 41.0).fill(self.bgColor)
      )
  }
}

struct TimerView: View {
  @ObservedObject var stopWatchManager = StopWatchManager()

  var timerName = "test"

  var body: some View {
    VStack {
      if stopWatchManager.mode != .paused {
        Text("Timer: \(timerName)")
        Spacer()
      }
      let minutes = (stopWatchManager.secondsElapsed / 60.0).rounded(.down)
      let seconds = (stopWatchManager.secondsElapsed - 60.0 * minutes)
      Text("Elapsed: \(String(format: "%02.0f:%02.0f", minutes, seconds))")

      Spacer()
      switch stopWatchManager.mode {
        case .stopped:
          Button(action: { stopWatchManager.start() }) {
            Text("Start").fontWeight(.bold)
          }.buttonStyle(WatchButtonStyle(bgColor: .purple))
        case .running:
          Button(action: { stopWatchManager.pause() }) {
            Text("Pause").fontWeight(.bold)
          }.buttonStyle(WatchButtonStyle(bgColor: .purple))
        case .paused:
          VStack(spacing: 10) {
            Button(action: { stopWatchManager.start() }) {
              Text("Continue").fontWeight(.bold)
            }.buttonStyle(WatchButtonStyle(bgColor: .purple))
            Button(action: {
              submit()
              stopWatchManager.stop()
              }) {
              Text("Submit").fontWeight(.bold)
            }.buttonStyle(WatchButtonStyle(bgColor: .purple))
            Button(action: { stopWatchManager.stop() }) {
              Text("Reset").fontWeight(.bold)
            }.buttonStyle(WatchButtonStyle(bgColor: .red))
          }
      }
    }
  }

  func submit() {
    let wait = round(self.stopWatchManager.secondsElapsed * 10) / 10
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzzZ"
    let dateString = dateFormatter.string(from: Date())

    let fields = [
      "wait": ["doubleValue": wait],
      "when": ["stringValue": dateString],
    ]
    postWithAuth(collection: self.timerName, fields: fields)
  }
}

struct TimerView_Previews: PreviewProvider {
  static var previews: some View {
    let c1 = TimerView()
    let c2 = TimerView()
    let c3 = TimerView()
    c2.stopWatchManager.mode = .running
    c3.stopWatchManager.mode = .paused
    return
      Group {
        c1
        c2
        c3
      }
  }
}
