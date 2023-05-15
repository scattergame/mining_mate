//
//  HardwareStatisticView.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 9/7/22.
//

import SwiftUI

struct HardwareStatisticView: View {
    
    let stat: HardwareStatisticModel
    
    var body: some View {
        
        VStack (alignment: .center) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            
            let valueStr = stat.value.asNumberWith0Decimals()
            let asicColor = Color.blue
            let amdColor = Color.theme.red
            let nvdaColor = Color.theme.green
            let valueColor = ( stat.title == "ASIC" ) ? asicColor : ( stat.title == "AMD GPU" ? amdColor : nvdaColor)
            
            let strategeStr = stat.value.asCurrencyWith2Decimals()
            let strategeColor = stat.value >= 0 ? Color.theme.green : Color.theme.red
            
            let efficiencyStr = stat.value == -9999 ? "Turn off your Rig!" : ( stat.value == -9998 ? "Add Hardwares" : stat.value.asPercentString())
            
            //let efficiencyStr = stat.value == -9999 ? "Turn off your Rig!" : stat.value.asPercentString()
            let efficiencyColor = stat.value >= 80 ? Color.theme.green : ( stat.value >= 60 ? Color.theme.yellow : ( stat.value >= 40 ? Color.orange : ( stat.value >= 20 ? Color.pink : Color.theme.red)) )

            Text( (stat.title == "ASIC" || stat.title == "AMD GPU" || stat.title == "Nvidia GPU") ? valueStr : ( stat.title == "Overall Efficiency" ? efficiencyStr : strategeStr) )
                .font(.headline)
                .bold()
                .foregroundColor((stat.title == "ASIC" || stat.title == "AMD GPU" || stat.title == "Nvidia GPU") ? valueColor : ( stat.title == "Overall Efficiency" ? efficiencyColor : strategeColor) )
            
            Text((stat.note != nil) ? (stat.note?.asNumberWith0Decimals() ?? "N/A") + " W" : "")
                .font(.caption)
                .bold()
                .foregroundColor(Color.theme.accent)
        }
        .lineLimit(1)
        .minimumScaleFactor(0.5)
    }
}

struct HardwareStatisticView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HardwareStatisticView(stat: dev.hardwarestate1)
                .previewLayout(.sizeThatFits)
            HardwareStatisticView(stat: dev.hardwarestate2)
                .previewLayout(.sizeThatFits)
            HardwareStatisticView(stat: dev.hardwarestate3)
                .previewLayout(.sizeThatFits)
            HardwareStatisticView(stat: dev.hardwarestate4)
                .previewLayout(.sizeThatFits)
            HardwareStatisticView(stat: dev.hardwarestate5)
                .previewLayout(.sizeThatFits)
            HardwareStatisticView(stat: dev.hardwarestate6)
                .previewLayout(.sizeThatFits)
        }
    }
}
