//
//  HardwareCoinProfitVerticalBiggerView.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 9/10/22.
//

import SwiftUI

struct HardwareCoinProfitVerticalBiggerView: View {
    
    let coin: SupportCoinDetail

        
    var body: some View {
        VStack (spacing: 0) {
            HardwareCoinImageView(coin: coin)
                .frame(width: 50, height: 40)
            Text(coin.symbol?.uppercased() ?? "unknown")
                .font(.caption)
                .foregroundColor(Color.theme.accent)
                //.background(Color.theme.secondaryText.opacity(0.2))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .frame(width: 50, height: 20)
            Text(coin.profit?.asCurrencyWith2Decimals() ?? "$0")
                .font(.body)
                .bold()
                .foregroundColor(coin.profit ?? 0 >= 0 ? Color.theme.green : Color.theme.red)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .frame(width: 50, height: 15)
        }
    }
}


struct HardwareCoinProfitVerticalBiggerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HardwareCoinProfitVerticalBiggerView(coin: dev.details)
                .previewLayout(.sizeThatFits)
            HardwareCoinProfitVerticalBiggerView(coin: dev.details)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
