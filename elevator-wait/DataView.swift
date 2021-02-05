//
//  DataView.swift
//  elevator-wait
//
//  Created by Stephen Astels on 2021-01-26.
//

import Charts
import SwiftUI

struct DataView: View {
  @State var timerName: String
  @State var data: [ElevatorData]

  var body: some View {
    let entries = groupByHour(data: data)
    return (
      VStack {
        Text("\(timerName): \(data.count)")
        CombinedChart(entries: entries)
        DataTableView(data: data)
      }.onAppear {
        getWithAuth(collection: self.timerName) {
          records in
          self.data = records
        }
      }
    )
  }
}

func groupByHour(data: [ElevatorData]) -> [ChartDataEntry] {
  let processedData: [ChartDataEntry] = data.map {
    let when = $0.when
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
    let whenString = dateFormatter.string(from: when)

    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: when)
    let minute = calendar.component(.minute, from: when)
    let x: Double = Double(hour) + Double(minute) / 60.0
    let y = $0.wait
    print("\(whenString) : \(x), \(y)")
    return ChartDataEntry(x: x, y: y)
  }

  return processedData
}

func genData(x: Double) -> ElevatorData {
  return (ElevatorData(when: Date() + x * 60 * 60, wait: abs(x - 12) * 15.0 + Double(arc4random_uniform(60) + 120)))
}

struct DataView_Previews: PreviewProvider {
  static var previews: some View {
    let entries = stride(from: 0.0, to: 24.0, by: 0.4)
      .map { (x) -> ElevatorData in
        genData(x: x)
      }
    DataView(timerName: "test", data: entries)
  }
}
