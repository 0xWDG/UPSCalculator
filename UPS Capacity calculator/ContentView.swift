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
    @State var selectedWatt = "100 W"

    let UPSCalc = UPSCalculator.shared

    let brand = UPSCalculator.shared.UPS
    var type = ""


    let watt = ["100 W", "200 W", "300 W"]

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
                        ForEach(brand, id: \.self) {
                            Text($0.name)
                        }
                    }
                    Picker("Type", selection: $selectedType) {
                        // Want here to use the SELECTED
                        // brand items only
                        let filter = brand.filter {
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
                        Text("Please fill in all fields.")
                            .foregroundColor(.orange)
                    }
                    HStack {
                        Text("Capacity")
                        Spacer()
                        Text("0%")
                            .foregroundColor(.orange)
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
                            Text($0)
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
                            Text($0)
                        }
                    }
                }

                Section() {
                    Button("Calculate") {
                        // ..
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
