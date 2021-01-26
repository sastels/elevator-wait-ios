//
//  ButtonStyles.swift
//  elevator-wait
//
//  Created by Stephen Astels on 2021-01-25.
//

import Foundation
import SwiftUI

struct CapsuleButtonStyle: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .font(.footnote)
      .foregroundColor(.white)
      .padding(.horizontal, 11)
      .padding(.vertical, 6)
      .background(Color.blue)
      .cornerRadius(.infinity)
  }
}

// based on https://sarunw.com/posts/swiftui-buttonstyle/

struct WatchzzButtonStyle: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
//      .padding()
//      .frame(minWidth: 0,
//             maxWidth: .infinity)
      .frame(width: 60)
      .foregroundColor(.white)
      .cornerRadius(40)
      .background(Color.red)
//      .padding()
//      .background(RoundedRectangle(cornerRadius: 40.0).fill(Color.orange))
  }
}

struct KasukuButtonStyle: ButtonStyle {
  var bgColor: Color = Color.blue

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .foregroundColor(.white)
      .padding(10)
      .background(ZStack {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
          .shadow(color: .black, radius: configuration.isPressed ? 7 : 10, x: configuration.isPressed ? 5 : 15, y: configuration.isPressed ? 5 : 15)
          .blendMode(.overlay)
        RoundedRectangle(cornerRadius: 10, style: .continuous)
          .fill(bgColor)
        })
      .scaleEffect(configuration.isPressed ? 0.95 : 1)
      .animation(.spring())
  }
}
