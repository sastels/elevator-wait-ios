//
//  CombinedChart.swift
//  elevator-wait
//
//  Created by Stephen Astels on 2021-02-04.
//

import Charts
import SwiftUI

struct CombinedChart: UIViewRepresentable {
  let entries: [ChartDataEntry]
  var chart = CombinedChartView()

  func makeUIView(context: Context) -> CombinedChartView {
    let leftAxis = chart.leftAxis
    leftAxis.axisMinimum = 0
    chart.rightAxis.enabled = false

    let data = CombinedChartData()
    data.scatterData = scatterData()
    data.lineData = lineData()
    chart.data = data
    chart.data?.calcMinMax()
    chart.notifyDataSetChanged()
    return chart
  }

  func updateUIView(_ uiView: CombinedChartView, context: Context) {
    let data = CombinedChartData()
    data.scatterData = scatterData()
    data.lineData = lineData()
    uiView.data = data
  }

  func scatterData() -> ScatterChartData {
    let entriesNormalized = entries.map { ChartDataEntry(x: $0.x, y: $0.y / 60.0) }
    let data = ScatterChartData()
    let dataSet = ScatterChartDataSet(entries: entriesNormalized, label: "Times")
    dataSet.setScatterShape(.circle)
    dataSet.colors = [NSUIColor.blue]
    data.addDataSet(dataSet)
    return data
  }

  func medianY(entries: [ChartDataEntry], x: Double) -> Double {
    let yValues = entries
      .filter { data in abs(data.x - x) < 0.5 }
      .map { $0.y }

    let median = yValues.count < 3 ? -666.0 : yValues.sorted(by: <)[yValues.count / 2]
    return median
  }

  func lineData() -> LineChartData {
    let entriesNormalized = entries.map { ChartDataEntry(x: $0.x, y: $0.y / 60.0) }
    var xMin = self.entries.isEmpty ? 0 : self.entries[0].x
    var xMax = xMin
    for data in self.entries {
      if data.x < xMin {
        xMin = data.x
      } else if data.x > xMax {
        xMax = data.x
      }
    }
    let entries = stride(from: Double(xMin), to: Double(xMax), by: 0.5).map { (i) -> ChartDataEntry in
      ChartDataEntry(x: i, y: medianY(entries:entriesNormalized, x: i))
    }.filter { data in data.y > 0 }

    let set = LineChartDataSet(entries: entries, label: "Median")
    set.setColor(UIColor.black)
    set.lineWidth = 2.5
    set.circleRadius = 0
    set.circleHoleRadius = 0
    set.mode = .cubicBezier
    set.drawValuesEnabled = false
    set.axisDependency = .left

    return LineChartData(dataSet: set)
  }

  typealias UIViewType = CombinedChartView
}

struct CombinedChart_Previews: PreviewProvider {
  static var previews: some View {
    let entries = stride(from: 0.0, to: 24.0, by: 0.4)
      .map { (i) -> ChartDataEntry in
        ChartDataEntry(x: i, y: abs(i - 12) * 15.0 + Double(arc4random_uniform(60) + 120))
      }
    CombinedChart(entries: entries)
  }
}
