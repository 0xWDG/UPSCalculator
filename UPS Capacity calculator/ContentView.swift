//
//  ContentView.swift
//  UPS Capacity calculator
//
//  Created by Wesley de Groot on 11/10/2021.
//

import SwiftUI

struct ContentView: View {
    @State var time_1 = ""
    @State var time_2 = ""

    @State var selectedBrand = UPSCalculator.shared.f_brand
    @State var selectedType = UPSCalculator.shared.f_type
    @State var selectedWatt = 100.0

    @State var capacity = "0%"
    @State var capacityColor: Color = .orange
    @State var capacityText = "Please fill in all fields."

    let brands = UPSCalculator.shared.UPS
    var type = ""


    let watt = [100, 200, 300]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Info")) {
                    HStack {
                        Spacer()
                        Image(systemName: "server.rack")
                            .frame(
                                width: 150,
                                height: 150
                            )
                        Spacer()
                    }

                    Picker("Brand", selection: $selectedBrand) {
                        ForEach(brands, id: \.self) {
                            Text($0.name)
                        }
                    }
                    Picker("Type", selection: $selectedType) {
                        // Want here to use the SELECTED
                        // brand items only
                        let filter = brands.filter {
                            $0 == selectedBrand
                        }.first?.types

                        if let filtered = filter {
                            ForEach(filtered, id: \.self) {
                                Text($0.type)
                            }
                        }
                    }

                    HStack {
                        Text("Status")
                        Spacer()
                        Text(capacityText)
                            .foregroundColor(.orange)
                    }
                    HStack {
                        Text("Capacity")
                        Spacer()
                        Text(capacity)
                            .foregroundColor(capacityColor)
                    }
                }

                Section(header: Text("Measurement 1")) {
                    HStack {
                        Text("Time")
                        TextField(
                            "Type Time",
                            text: $time_1
                        )
                    }
                    Picker("Tested at", selection: $selectedWatt) {
                        ForEach(watt, id: \.self) {
                            Text("\($0) Watt")
                        }
                    }
                }

                Section(header: Text("Measurement 2")) {
                    HStack {
                        Text("Time")
                        TextField(
                            "Type time",
                            text: $time_2
                        )
                    }
                    Picker("Tested at", selection: $selectedWatt) {
                        ForEach(watt, id: \.self) {
                            Text("\($0) Watt")
                        }
                    }
                }

                Section() {
                    Button("Calculate") {
                        guard let time1 = Double(time_1),
                              let time2 = Double(time_2) else {
                                  return
                              }

                        let m1 = UPSCalculator.Measurement.init(time: time1, watt: selectedWatt)
                        let m2 = UPSCalculator.Measurement.init(time: time2, watt: selectedWatt)
                        let val = UPSCalculator.shared.calculate(
                            UPS: selectedType,
                            measurement1: m1,
                            measurement2: m2
                        )

                        capacity = "\(val.resultTotal)%"

                        capacityText = val.reason
                        
                        if val.resultTotal < 30 {
                            capacityColor = .red
                        } else if val.resultTotal <= 50 {
                            capacityColor = .orange
                        } else {
                            capacityColor = .green
                        }

                        // 50
                        // 70

                    }
                }
            }
            .navigationTitle(
                Text("UPS Capacity Calculator")
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 12 Pro Max")
        }
    }
}
