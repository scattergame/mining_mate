//
//  HardwareDetailViewModel.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 9/10/22.
//

import Foundation
import Combine
import SwiftUI

class HardwareDetailViewModel: ObservableObject {
    
    @Published var hardwareDetailOverViewStatistics: [StatisticModel] = []
    @Published var algorithmDetailStatistics: [AlgorithmStatisticModel] = []
    @Published var hardware: Hardware
        
    init(hardware: Hardware) {
        self.hardware = hardware
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        
        // Hardware Type: GPU or ASIC
        let hardwareType = hardware.brand_short == "ASIC" ? "ASIC" : (hardware.brand_short == "AMD" ? "GPU (AMD)" : "GPU (Nvidia)")
        let typeStat = StatisticModel(title: "Type", value: hardwareType)
        
        // Hardware Model
        let hardwareModel = hardware.name
        let modelStat = StatisticModel(title: "Model", value: hardwareModel)
        
        // Hardware Memory Type
        let hardwareMemType = hardware.specs?.memoryType ?? "N/A"
        let memTypeStat = StatisticModel(title: "Memory Type", value: hardwareMemType)
        
        // Hardware Memory Size
        let hardwareMemSize = hardware.specs?.correctMemSize ?? "N/A"
        let memSizeStat = StatisticModel(title: "Memory Size", value: hardwareMemSize)
                
        hardwareDetailOverViewStatistics = [typeStat, modelStat, memTypeStat, memSizeStat]
        
        //
        algorithmDetailStatistics = []
        for (key, value) in hardware.algorithms ?? [:] {

            let speed = value.speed
            let power = Double(value.power)
            let speedStr = speed > 0 ? speed.formattedWithHashrate() : "N/A"
            let powerStr = power > 0 ? (power.asNumberWith0Decimals() + " W") : "N/A"
            let algorithm = AlgorithmStatisticModel(name: key, speed: speedStr , power: powerStr)
            algorithmDetailStatistics.append(algorithm)
        }
    }
    
}
