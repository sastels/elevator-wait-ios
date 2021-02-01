//
//  DataView.swift
//  elevator-wait
//
//  Created by Stephen Astels on 2021-01-26.
//

import Charts
import SwiftUI

struct DataView: View {
  @State var data: [ElevatorData] = []
  @State var timerName: String = "test"
  @State var entries: [ChartDataEntry] = []

  var body: some View {
    return (
      VStack {
        Text("\(timerName): \(data.count)")
        Scatter(entries: entries)
      }.onAppear {
        getWithAuth(collection: self.timerName) {
          records in
          self.data = records
          self.entries = processData(data: records)
        }
      }
    )
  }
}

func processData(data: [ElevatorData]) -> [ChartDataEntry] {
  return data.map {
    let when = $0.when
    print("when: \"\(when)\"")
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: when)
    let minutes = calendar.component(.minute, from: when)
    let seconds = calendar.component(.second, from: when)
    let x:Double = Double(hour) + Double(minutes) / 60.0
    print("time = \(hour):\(minutes):\(seconds)  x:\(x)")
    return ChartDataEntry(x: 1, y: $0.wait)
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
