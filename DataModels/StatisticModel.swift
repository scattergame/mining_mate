//
//  StatisticModel.swift
//  MiningMate
//
//  Created by Chenxi Wang on 8/12/22.
//

import Foundation

struct StatisticModel: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}

struct MiningStatisticModel: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: Double
    
    init(title: String, value: Double) {
        self.title = title
        self.value = value
    }
}

struct HardwareStatisticModel: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: Double
    let note: Double?
    
    init(title: String, value: Double, note: Double? = nil) {
        self.title = title
        self.value = value
        self.note = note
    }
}

struct AlgorithmStatisticModel: Identifiable {
    
    let id = UUID().uuidString
    let name: String
    let speed: String
    let power: String
    
    init(name: String, speed: String, power: String) {
        self.name = name
        self.speed = speed
        self.power = power
    }
    
}

