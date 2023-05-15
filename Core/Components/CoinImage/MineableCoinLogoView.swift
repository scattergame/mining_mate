//
//  MineableCoinLogoView.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/30/22.
//

import SwiftUI

struct MineableCoinLogoView: View {

    let coin: MineableCoinModel
    
    var body: some View {
        VStack (spacing: 0) {
            MineableCoinImageView(coin: coin)
                .frame(width: 35, height: 35)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .frame(width: 40, height: 18)
            Text(coin.name)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .lineLimit(2)
                .minimumScaleFactor(0.75)
                .multilineTextAlignment(.center)
                .frame(width: 40, height: 18)
        }
    }
    
}

struct MineableCoinLogoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MineableCoinLogoView(coin: dev.mineableCoin)
                .previewLayout(.sizeThatFits)
            MineableCoinLogoView(coin: dev.mineableCoin)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

