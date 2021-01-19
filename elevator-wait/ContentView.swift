//
//  ContentView.swift
//  elevator-wait
//
//  Created by Stephen Astels on 2021-01-19.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var stopWatchManager = StopWatchManager()
  
  var timerName = "test"
  
  var body: some View {
    VStack {
      Text("Timer: \(timerName)")
      Spacer()
      
        let minutes = stopWatchManager.secondsElapsed / 60
        let seconds = stopWatchManager.secondsElapsed % 60
        Text("Elapsed: \(String(format: "%02d:%02d", minutes, seconds))")
      
      Spacer()
      switch stopWatchManager.mode {
        case .stopped:
          Button(action: { stopWatchManager.start() }) {
            Text("Start")
              .fontWeight(.bold)
              .font(.title2)
              .frame(width:100)
              .padding()
              .background(Color.purple)
              .cornerRadius(40)
              .foregroundColor(.white)
          }
        case .running:
          Button(action: { stopWatchManager.pause() }) {
            Text("Pause")
              .fontWeight(.bold)
              .font(.title2)
              .frame(width:100)
              .padding()
              .background(Color.purple)
              .cornerRadius(40)
              .foregroundColor(.white)
          }
        case .paused:
          VStack {
            HStack {
              Button(action: { stopWatchManager.start() }) {
                Text("Continue")
                  .fontWeight(.bold)
                  .font(.title2)
                  .frame(width:100)
                  .padding()
                  .background(Color.purple)
                  .cornerRadius(40)
                  .foregroundColor(.white)
              }
              Spacer()
              Button(action: {}) {
                Text("Submit")
                  .fontWeight(.bold)
                  .font(.title2)
                  .frame(width:100)
                  .padding()
                  .background(Color.purple)
                  .cornerRadius(40)
                  .foregroundColor(.white)
                  
              }
            }
            
            Button(action: { stopWatchManager.stop() }) {
              Text("Reset")
                .fontWeight(.bold)
                .font(.title2)
                .frame(width:100)
                .padding()
                .background(Color.red)
                .cornerRadius(40)
                .foregroundColor(.white)
            }.padding()
          }
      }
      
      Spacer()
    }.padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let c1 = ContentView()
    let c2 = ContentView()
    let c3 = ContentView()
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
