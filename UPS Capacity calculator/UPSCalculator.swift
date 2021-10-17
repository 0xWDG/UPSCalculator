//
//  UPSCalculator.swift
//  UPS Capacity calculator
//
//  Created by Wesley de Groot on 15/10/2021.
//

import Foundation

/// (simple) class to Calculate the battery capacity of UPS-es.
class UPSCalculator {
    /// UPS Brand
    struct Brand: Hashable {
        var name: String
        var types: [`Type`]
    }

    /// UPS Type
    struct `Type`: Hashable {
        var type: String
        var watt: Double
        var mWatt: Double
        var time: Double
    }

    /// Measurement
    struct Measurement: Hashable {
        var time: Double
        var watt: Double
    }

    /// Calculationresult
    struct CalculationResult: Hashable {
        var result: Bool
        var reason: String

        var result1: Double
        var result2: Double
        var resultTotal: Double
    }

    /// Shared instance
    public static let shared = UPSCalculator()

    /// Fake: Brand
    public let f_brand: Brand = .init(name: "", types: [.init(type: "", watt: 0, mWatt: 0, time: 0)])

    /// Fake: Type
    public let f_type: `Type` = .init(type: "", watt: 0, mWatt: 0, time: 0)

    /// UPS Types (built-in)
    public let UPS: [Brand] = [
        .init(
            name: "APC",
            types: [
                .init(type: "Type 1", watt: 100, mWatt: 100, time: 3600),
                .init(type: "Type 2", watt: 100, mWatt: 100, time: 3600),
                .init(type: "Type 3", watt: 100, mWatt: 100, time: 3600)
            ]
        )
    ]

    /// calculate capacity
    /// - Parameters:
    ///   - UPS: UPS Type
    ///   - measurement1: Measurement 1 values
    ///   - measurement2: Measurement 1 values
    /// - Returns: CalculationResult
    func calculate(UPS: `Type`, measurement1: Measurement, measurement2: Measurement) -> CalculationResult {
        print("CALCULATING")
        // Check if measurements are done on the correct watt.
        if measurement1.watt != UPS.mWatt || measurement2.watt != UPS.mWatt {
            print("Failed")
            return .init(
                result: false,
                reason: "Test with \(UPS.mWatt)W",
                result1: 0,
                result2: 0,
                resultTotal: 0
            )
        }

        // Calculation options.
        // Time @ Watt = 100%REF
        // M1 = Time @ Watt = (Time / 100%REFTime) * 100
        // M2 = Time @ Watt = (Time / 100%REFTime) * 100
        // MTot = (M1 + M2) / 2 = Percent.

        // =< 70 Change advised
        // =< 50 need to change
        // =< 30 CRITICAL need to change

        let percentageM1: Double = (measurement1.time / UPS.time) * 100
        print("""
P1 = (measurement1.time / UPS.time) * 100
P1 = (\(measurement1.time) / \(UPS.time)) * 100
P1 = (\(measurement1.time / UPS.time)) * 100
P1 = \(percentageM1)
""")
        let percentageM2: Double = (measurement2.time / UPS.time) * 100
        print("""
P2 = (measurement2.time / UPS.time) * 100
P2 = (\(measurement2.time) / \(UPS.time)) * 100
P2 = (\(measurement2.time / UPS.time)) * 100
P2 = \(percentageM2)
""")
        let percentageMT: Double = (percentageM1 + percentageM2) / 2

        print("Pm1:\(percentageM1)%\nPm2:\(percentageM2)%\nPmT:\(percentageMT)%")

        if percentageMT <= 30 {
            return .init(
                result: true,
                reason: "Critical capacity! replace battery.",
                result1: percentageM1,
                result2: percentageM2,
                resultTotal: percentageMT
            )
        } else if percentageMT <= 50 {
            return .init(
                result: false,
                reason: "We advice to change the battery",
                result1: percentageM1,
                result2: percentageM2,
                resultTotal: percentageMT
            )
        } else if percentageMT <= 70 {
            return .init(
                result: true,
                reason: "The battery has enough capacity",
                result1: percentageM1,
                result2: percentageM2,
                resultTotal: percentageMT
            )
        } else {
            return .init(
                result: true,
                reason: "The battery is in good shape",
                result1: percentageM1,
                result2: percentageM2,
                resultTotal: percentageMT
            )
        }
    }

    init () {

    }

    deinit {

    }
}
