//
//  CombinedChart.swift
//  elevator-wait
//
//  Created by Stephen Astels on 2021-02-04.
//

import Charts
import SwiftUI

struct CombinedChart: UIViewRepresentable {
  var entries: [ChartDataEntry]

  // this func is required to conform to UIViewRepresentable protocol
  func makeUIView(context: Context) -> CombinedChartView {
    // crate new chart
    let chart = CombinedChartView()
    let leftAxis = chart.leftAxis
    leftAxis.axisMinimum = 0
//    leftAxis.axisMaximum = 6
//    leftAxis.setLabelCount(7, force: true)

    chart.rightAxis.enabled = false

//    let xAxis = chart.xAxis
//    xAxis.axisMaximum = 24
//    xAxis.axisMinimum = 0
//    xAxis.setLabelCount(7, force: true)

    // it is convenient to form chart data in a separate func
    let data = CombinedChartData()
    data.scatterData = addScatterData()
    chart.data = data
    chart.data?.calcMinMax()
    chart.notifyDataSetChanged()
    return chart
  }

  // this func is required to conform to UIViewRepresentable protocol
  func updateUIView(_ uiView: CombinedChartView, context: Context) {
    // when data changes chartd.data update is required
    let data = CombinedChartData()
    data.scatterData = addScatterData()
    uiView.data = data
  }

  func addScatterData() -> ScatterChartData {
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

struct CombinedChart_Previews: PreviewProvider {
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
