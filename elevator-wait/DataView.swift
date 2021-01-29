//
//  DataView.swift
//  elevator-wait
//
//  Created by Stephen Astels on 2021-01-26.
//

import Charts
import SwiftUI

struct DataView: View {
  var timerName: String
  var entries: [ChartDataEntry]

  var body: some View {
    
    getWithAuth(collection: timerName)
    
    return (
      VStack {
        Text(timerName)
        Scatter(entries: entries)
    })
  }
}

struct DataView_Previews: PreviewProvider {
  static var previews: some View {
    DataView(timerName: "test", entries: [
      ChartDataEntry(x: 1, y: 1),
      ChartDataEntry(x: 2, y: 2),
      ChartDataEntry(x: 3, y: 3),
      ChartDataEntry(x: 4, y: 4),
      ChartDataEntry(x: 5, y: 5)
    ])
  }
}
