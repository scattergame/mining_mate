//
//  HardwareCoinProfitVerticalView.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/31/22.
//

import SwiftUI

struct HardwareCoinProfitVerticalView: View {

    let coin: SupportCoinDetail
    
    var body: some View {
        VStack (spacing: 0) {
            HardwareCoinImageView(coin: coin)
                .frame(width: 25, height: 25)
            Text(coin.symbol?.uppercased() ?? "unknown")
                .font(.caption)
                .foregroundColor(Color.theme.accent)
                //.background(Color.theme.secondaryText.opacity(0.2))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .frame(width: 25, height: 18)
            Text(coin.profit?.asCurrencyWith2Decimals() ?? "$0")
                .font(.caption)
                .foregroundColor(Color.theme.accent)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .frame(width: 25, height: 18)
        }
    }
}

struct HardwareCoinProfitVerticalView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HardwareCoinProfitVerticalView(coin: dev.details)
                .previewLayout(.sizeThatFits)
            HardwareCoinProfitVerticalView(coin: dev.details)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
