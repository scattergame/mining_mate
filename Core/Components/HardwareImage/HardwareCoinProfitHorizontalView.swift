//
//  HardwareCoinProfitHorizontalView.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/31/22.
//

import SwiftUI

struct HardwareCoinProfitHorizontalView: View {

    let coin: SupportCoinDetail
    
    var body: some View {
        HStack (spacing: 0) {
            HardwareCoinImageView(coin: coin)
                .frame(width: 35, height: 35)
            VStack (spacing: 0) {
                Text(coin.symbol?.uppercased() ?? "unknown")
                    .font(.caption)
                    .foregroundColor(Color.theme.accent)
                    //.background(Color.theme.secondaryText.opacity(0.2))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(2)
                //Spacer()
                Text(coin.profit?.asCurrencyWith2Decimals() ?? "$0")
                    .font(.caption)
                    .foregroundColor(Color.theme.accent)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                    .padding(2)
            }
        }
        .frame(width: 70, height: 40)
    }
}

struct HardwareCoinProfitHorizontalView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HardwareCoinProfitHorizontalView(coin: dev.details)
                .previewLayout(.sizeThatFits)
            HardwareCoinProfitHorizontalView(coin: dev.details)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

