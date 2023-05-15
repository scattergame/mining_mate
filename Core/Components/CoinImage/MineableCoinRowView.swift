//
//  MineableCoinRowView.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/30/22.
//

import SwiftUI

struct MineableCoinRowView: View {

    let coin: MineableCoinModel
    @State var showYourReward: Bool = true
    
    var body: some View {
        HStack (spacing: 0) {
            leftColumn
            Spacer()
            if showYourReward {
                centerColumn_profit
            } else {
                centerColumn_algorithm
            }
            Spacer()
            rightColumn
                .padding(.trailing, 5)
        }
        .font(.subheadline)
        .background(
            Color.theme.background.opacity(0.001)
        )
    }
}

struct MineableCoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        MineableCoinRowView(coin: dev.mineableCoin)
    }
}


extension MineableCoinRowView {
    
    private var leftColumn: some View {
        HStack (spacing: 0) {
            let coinrank = coin.coinrank ?? -1
            let coinrankstr = (coinrank > 250 || coinrank < 0) ? ">250" : String(coinrank)
            Text(coinrankstr)
                .font(.caption2)
                .foregroundColor(Color.theme.secondaryText)
                .frame(width: 30)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            ZStack {
                MineableCoinImageView(coin: coin)
                    .frame(width: 30, height: 30)
                    .background(
                        Circle().fill(Color.white.opacity(0.7))
                    )
            }
            VStack(alignment: .leading){
                Text(coin.symbol.uppercased())
                    .font(.headline)
                    .padding(.leading, 3)
                .foregroundColor(Color.theme.accent)
                Text(coin.name)
                    .font(.custom("test", size: 8))
                    .foregroundColor(Color.theme.secondaryText)
                    .padding(.leading, 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width/3, alignment: .leading)
    }
    
    private var rightColumn: some View {
        VStack (alignment: .trailing){
            
            Text(coin.price.asCurrencyWithFlexDecimals())
                .bold()
                .foregroundColor(Color.theme.accent)
            HStack {
                //Text(coin.algorithm ?? "unknown")
                Text("Difficulty: " + (coin.wtm_difficulty24?.formattedWithAbbreviations() ?? "N/A"))
            }
            .font(.caption2)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .foregroundColor(Color.theme.secondaryText)
        }
        .frame(width: UIScreen.main.bounds.width/3.2, alignment: .trailing)
        .padding(.trailing, 6)
    }
    
    private var centerColumn_algorithm: some View {
        VStack(alignment: .trailing) {
            Text(coin.algorithm ?? "unknown")
                .font(.caption)
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(coin.networkHashrate.formattedWithHashrate())
                .font(.caption2)
                .foregroundColor(Color.theme.secondaryText)
        }
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        .frame(width: UIScreen.main.bounds.width/4.5, alignment: .trailing)
    }
    
    private var centerColumn_profit: some View {
        
        VStack(alignment: .trailing) {
            Text(coin.my_dailyprofit?.asCurrencyWith2Decimals() ?? "n/a")
                .font(.caption)
                .bold()
                .foregroundColor(Color.theme.accent)
            
            let reward_str = coin.my_dailyreward?.asCurrencyWith2Decimals() ?? "n/a"
            let cost_str = coin.my_dailycost?.asCurrencyWith2Decimals() ?? "n/a"
            let line2_str = "(" + cost_str + ")"
            
            HStack {
                Text(reward_str)
                    .foregroundColor(Color.theme.green)
                Text(line2_str)
                    .foregroundColor(Color.theme.red)
            }
            .font(.caption2)
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .frame(alignment: .trailing)
        }
        .lineLimit(1)
        .minimumScaleFactor(0.5)
        .frame(width: UIScreen.main.bounds.width/4.5, alignment: .trailing)
    }    
}
