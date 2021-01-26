//
//  FirebaseUtils.swift
//  elevator-wait
//
//  Created by Stephen Astels on 2021-01-25.
//

import Foundation

func postData(collection: String, fields: [String: Any], authToken: String) {
  let BASE = "https://firestore.googleapis.com/v1"
  let PROJECT_ID = "elevator-wait"
  let collectionAddress = BASE + "/projects/\(PROJECT_ID)/databases/(default)/documents/\(collection)"

  guard let serviceUrl = URL(string: collectionAddress) else { return }

  var request = URLRequest(url: serviceUrl)
  request.httpMethod = "POST"
  request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
  request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

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
        print("--------------- POST ---------------")
        print(json)
        print("--------------- POST ---------------")
      } catch {
        print("--------------- POST ERROR ---------------")
        print(error)
        print("--------------- POST ERROR ---------------")
      }
    }
  }.resume()
}

// curl 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]' \
// -H 'Content-Type: application/json' --data-binary '{"returnSecureToken":true}'

func postWithAuth(collection: String, fields: [String: Any]) {
  let API_KEY = "AIzaSyB5G-uKZFraF9HvoXRt9oi1Iiq06spWWtM"
  let BASE = "https://identitytoolkit.googleapis.com/v1/accounts:signUp"

  guard let serviceUrl = URL(string: "\(BASE)?key=\(API_KEY)") else { return }

  var request = URLRequest(url: serviceUrl)
  request.httpMethod = "POST"
  request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
  let parameters: [String: Any] = [
    "returnSecureToken": true,
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
        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        if let idToken = json["idToken"] as? String {
          postData(collection: collection, fields: fields, authToken: idToken)
        }
      } catch {
        print("--------------- AUTH ERROR ---------------")
        print(error)
        print("--------------- AUTH ERROR ---------------")
      }
    }
  }.resume()
}