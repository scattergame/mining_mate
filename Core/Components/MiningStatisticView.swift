//
//  MiningStatisticView.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 9/7/22.
//

import SwiftUI

struct MiningStatisticView: View {
    
    let stat: MiningStatisticModel
    
    var body: some View {
        VStack (alignment: .center) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            let colorPosNeg = (stat.value >= 0) ? Color.theme.green : Color.theme.red
            let valueStr = (stat.title == "Mining Coins" || stat.title == "Power") ? stat.value.asNumberWith0Decimals() : stat.value.asCurrencyWith2Decimals()
            let valueColor = (stat.title == "Mining Coins" || stat.title == "Electricity Rate" || stat.title == "Power") ? Color.theme.accent : colorPosNeg
            
            let suffix = (stat.title == "Power") ? " W" : ""
            Text(valueStr + suffix)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(valueColor)
        }
    }
}

struct MiningStatisticView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MiningStatisticView(stat: dev.miningstate1)
                .previewLayout(.sizeThatFits)
            MiningStatisticView(stat: dev.miningstate2)
                .previewLayout(.sizeThatFits)
            MiningStatisticView(stat: dev.miningstate3)
                .previewLayout(.sizeThatFits)
            MiningStatisticView(stat: dev.miningstate4)
                .previewLayout(.sizeThatFits)
            MiningStatisticView(stat: dev.miningstate5)
                .previewLayout(.sizeThatFits)
            MiningStatisticView(stat: dev.miningstate6)
                .previewLayout(.sizeThatFits)
        }
    }
}
