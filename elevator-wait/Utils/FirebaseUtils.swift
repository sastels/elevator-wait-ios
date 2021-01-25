//
//  FirebaseUtils.swift
//  elevator-wait
//
//  Created by Stephen Astels on 2021-01-25.
//

import Foundation

func postData(collection: String, fields: [String: Any]) {
  let BASE = "https://firestore.googleapis.com/v1"
  let PROJECT_ID = "elevator-wait"
  let collectionAddress = BASE + "/projects/\(PROJECT_ID)/databases/(default)/documents/\(collection)"

  guard let serviceUrl = URL(string: collectionAddress) else { return }

  var request = URLRequest(url: serviceUrl)
  request.httpMethod = "POST"
  request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
  
  let parameters: [String: Any] = [
    "fields": fields,
  ]
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
}
