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
          self.entries = groupByHour(data: records)
        }
      }
    )
  }
}

func groupByHour(data: [ElevatorData]) -> [ChartDataEntry] {
  let processedData:[ChartDataEntry] = data.map {
    let when = $0.when
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
    let whenString = dateFormatter.string(from: when)
    
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: when)
    let minute = calendar.component(.minute, from: when)
    let x:Double = Double(hour) + Double(minute) / 60.0
    let y = $0.wait
    print ("\(whenString) : \(x), \(y)")
    return ChartDataEntry(x: x, y: y)
  }
  
  return processedData
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
