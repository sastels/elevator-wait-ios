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
  var chart = CombinedChartView()
  
  // this func is required to conform to UIViewRepresentable protocol
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

  // this func is required to conform to UIViewRepresentable protocol
  func updateUIView(_ uiView: CombinedChartView, context: Context) {
    let data = CombinedChartData()
    data.scatterData = scatterData()
    data.lineData = lineData()
    uiView.data = data
  }

  func scatterData() -> ScatterChartData {
    let data = ScatterChartData()
    let dataSet = ScatterChartDataSet(entries: entries, label: "DS 1")
    dataSet.setScatterShape(.circle)
    dataSet.colors = [NSUIColor.blue]
    dataSet.label = "My Data"
    data.addDataSet(dataSet)
    return data
  }

  func lineData() -> LineChartData {
    
    let set = LineChartDataSet(entries: entries, label: "Line DataSet")
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
    let entries = (0..<40).map { (i) -> ChartDataEntry in
      ChartDataEntry(x: Double(i) + 0.5, y: Double(i) * 1.0 + Double(arc4random_uniform(15) + 5))
    }

    CombinedChart(entries:entries)
  }
}
