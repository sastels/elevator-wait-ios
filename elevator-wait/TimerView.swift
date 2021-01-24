//
//  TimerView.swift
//  elevator-wait
//
//  Created by Stephen Astels on 2021-01-19.
//

import Firebase
import SwiftUI

struct TimerView: View {
  @ObservedObject var stopWatchManager = StopWatchManager()
  
  var timerName = "test"
  let db = Firestore.firestore()
  
  var body: some View {
    VStack {
      Text("Timer: \(timerName)")
      Spacer()
      
      let minutes = (stopWatchManager.secondsElapsed / 60.0).rounded(.down)
      let seconds = (stopWatchManager.secondsElapsed - 60.0 * minutes)
      Text("Elapsed: \(String(format: "%02.0f:%02.0f", minutes, seconds))")
      
      Spacer()
      switch stopWatchManager.mode {
        case .stopped:
          Button(action: { stopWatchManager.start() }) {
            Text("Start")
              .fontWeight(.bold)
              .font(.title2)
              .frame(width: 100)
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
              .frame(width: 100)
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
                  .frame(width: 100)
                  .padding()
                  .background(Color.purple)
                  .cornerRadius(40)
                  .foregroundColor(.white)
              }
              Spacer()
              Button(action: {
                self.submit()
                stopWatchManager.stop()
              }) {
                Text("Submit")
                  .fontWeight(.bold)
                  .font(.title2)
                  .frame(width: 100)
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
                .frame(width: 100)
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
  
  func submit() {
    let wait = round(self.stopWatchManager.secondsElapsed * 10) / 10
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzzZ"
    let dateString = dateFormatter.string(from: Date())
    
    let BASE = "https://firestore.googleapis.com/v1"
    let PROJECT_ID = "elevator-wait"
    let collectionAddress = BASE + "/projects/\(PROJECT_ID)/databases/(default)/documents/\(self.timerName)"
    
    guard let serviceUrl = URL(string: collectionAddress) else { return }
    
    let parameters: [String: Any] = [
      "fields": [
        "wait": ["doubleValue": wait],
        "when": [ "stringValue": dateString ],
      ],
    ]
    var request = URLRequest(url: serviceUrl)
    request.httpMethod = "POST"
    request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
    guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
      return
    }
    request.httpBody = httpBody
    request.timeoutInterval = 20
    let session = URLSession.shared
    session.dataTask(with: request) { data, response, error in
      if let response = response {
        print(response)
      }
      if let data = data {
        do {
          let json = try JSONSerialization.jsonObject(with: data, options: [])
          print(json)
        } catch {
          print(error)
        }
      }
    }.resume()
    
//
//
//    Auth.auth().signInAnonymously { authResult, _ in
//      guard (authResult?.user) != nil else { return }
//      self.db.collection(self.timerName)
//        .document(dateString)
//        .setData([
//          "wait": wait,
//          "when": dateString,
//        ])
//      { err in
//        if let err = err {
//          print("Error adding document: \(err)")
//        } else {
//          print("Submitted  \(dateString) : \(wait)")
//        }
//      }
//    }
//
//
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
