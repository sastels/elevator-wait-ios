//
//  TimerView.swift
//  elevator-wait WatchKit Extension
//
//  Created by Stephen Astels on 2021-01-21.
//

import SwiftUI

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
            Text("Start")
              .fontWeight(.bold)
              .font(.callout)
              .frame(width: 60)
              .padding()
              .background(Color.purple)
              .cornerRadius(40)
              .foregroundColor(.white)
          }
        case .running:
          Button(action: { stopWatchManager.pause() }) {
            Text("Pause")
              .fontWeight(.bold)
              .font(.callout)
              .frame(width: 60)
              .padding()
              .background(Color.purple)
              .cornerRadius(40)
              .foregroundColor(.white)
          }

        case .paused:
          VStack {
            Button(action: { stopWatchManager.start() }) {
              Text("Continue")
                .fontWeight(.bold)
                .font(.callout)
                .frame(width: 80)
                .padding()
                .background(Color.purple)
                .cornerRadius(40)
                .foregroundColor(.white)
            }
            Button(action: {
              // TODO: submit somehow!!
              stopWatchManager.stop()
              }) {
              Text("Submit")
                .fontWeight(.bold)
                .font(.callout)
                .frame(width: 70)
                .padding()
                .background(Color.purple)
                .cornerRadius(40)
                .foregroundColor(.white)
            }
            Button(action: { stopWatchManager.stop() }) {
              Text("Reset")
                .fontWeight(.bold)
                .font(.callout)
                .frame(width: 70)
                .padding()
                .background(Color.red)
                .cornerRadius(40)
                .foregroundColor(.white)
            }
          }
      }
    }
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
