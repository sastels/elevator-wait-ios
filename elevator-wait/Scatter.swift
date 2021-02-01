//
//  Scatter.swift
//  elevator-wait
//
//  Created by Stephen Astels on 2021-01-26.
//

import Charts
import SwiftUI

struct Scatter: UIViewRepresentable {
  var entries: [ChartDataEntry]

  // this func is required to conform to UIViewRepresentable protocol
  func makeUIView(context: Context) -> ScatterChartView {
    // crate new chart
    let chart = ScatterChartView()
    let leftAxis = chart.leftAxis
    leftAxis.axisMinimum = 0
//    leftAxis.axisMaximum = 6
//    leftAxis.setLabelCount(7, force: true)

    chart.rightAxis.enabled = false

    let xAxis = chart.xAxis
//    xAxis.axisMaximum = 6
    xAxis.axisMinimum = 0
    xAxis.setLabelCount(7, force: true)

    // it is convenient to form chart data in a separate func
    chart.data = addData()
    return chart
  }

  // this func is required to conform to UIViewRepresentable protocol
  func updateUIView(_ uiView: ScatterChartView, context: Context) {
    // when data changes chartd.data update is required
    uiView.data = addData()
  }

  func addData() -> ScatterChartData {
    let data = ScatterChartData()
    let dataSet = ScatterChartDataSet(entries: entries, label: "DS 1")
    dataSet.setScatterShape(.circle)
    dataSet.colors = [NSUIColor.blue]
    dataSet.label = "My Data"
    data.addDataSet(dataSet)
    return data
  }

  typealias UIViewType = ScatterChartView
}

struct Scatter_Previews: PreviewProvider {
  static var previews: some View {
    Scatter(entries: [
      ChartDataEntry(x: 1, y: 1),
      ChartDataEntry(x: 2, y: 2),
      ChartDataEntry(x: 3, y: 3),
      ChartDataEntry(x: 4, y: 4),
      ChartDataEntry(x: 5, y: 5)
    ])
  }
}
