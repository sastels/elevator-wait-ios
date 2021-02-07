//
//  DataTableView.swift
//  elevator-wait
//
//  Created by Stephen Astels on 2021-02-05.
//

import SwiftUI

struct DataTableRow: View {
  var entry: ElevatorData

  var body: some View {
    let min: Int = Int(entry.wait / 60.0)
    let sec: Int = Int(entry.wait - Double(min) * 60.0)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return (
      HStack {
        Text(dateFormatter.string(from: entry.when))
        Spacer()
        Text("\(min):\(sec, specifier: "%.2d") min")
      }
    )
  }
}

struct DataTableView: View {
  var data: [ElevatorData]

  var body: some View {
    return (
      
      VStack {
        Text("Times").font(.title2).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        List(data.sorted { $0.when > $1.when }, id: \.when) { entry in
          DataTableRow(entry: entry)
        }
      }.frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: 100, maxWidth: 350, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    )
  }
}

struct DataTableView_Previews: PreviewProvider {
  static var previews: some View {
    DataTableView(data: [ElevatorData(when: Date(), wait: 1.0),
                         ElevatorData(when: Date() + 60, wait: 3.0)])
  }
}
