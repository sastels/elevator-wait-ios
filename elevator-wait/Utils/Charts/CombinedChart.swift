//
//  CombinedChart.swift
//  elevator-wait
//
//  Created by Stephen Astels on 2021-02-04.
//

import Charts
import SwiftUI

/* web app
 const INTERVAL_LENGTH = 30.0 / 60; // in hours
 const INTERVAL_SPACING = 30.0 / 60; // in hours

 const smoothedData = data => {
 let smoothedTimes = Array(24 / INTERVAL_SPACING)
   .fill()
   .map((x, i) => i * INTERVAL_SPACING);

 let smoothedData = smoothedTimes.map(t => {
   return [
     t,
     data.filter(pt => Math.abs(t - pt[0]) < INTERVAL_LENGTH / 2.0)
   ];
 });
 smoothedData = smoothedData.filter(pt => pt[1].length > 1);
 smoothedData = smoothedData.map(pt => [
   pt[0],
   pt[1].reduce((total, pt) => total + pt[1], 0) / pt[1].length
 ]);
 return smoothedData;
 };

 */

struct CombinedChart: UIViewRepresentable {
  var entries: [ChartDataEntry]
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
    dataSet.label = "Times"
    data.addDataSet(dataSet)
    return data
  }

  func medianY(x: Double) -> Double {
    let yValues = entries
      .filter { data in abs(data.x - x) < 0.5 }
      .map { $0.y }

    let median = yValues.count < 3 ? -666.0 : yValues.sorted(by: <)[yValues.count / 2]
    return median
  }

  func lineData() -> LineChartData {
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
      ChartDataEntry(x: i, y: medianY(x: i))
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
        ChartDataEntry(x: i + 0.5, y: i * 1.0 + Double(arc4random_uniform(15) + 5))
      }

    CombinedChart(entries: entries)
  }
}
