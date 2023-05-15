//
//  CoinRowView.swift
//  MiningMate
//
//  Created by Chenxi Wang on 8/6/22.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    @State var showHolding: Bool
    
    var body: some View {
        HStack (spacing: 0) {
            leftColumn
            Spacer()
            if showHolding {
                centerColumn
            }
            Spacer()
            rightColumn
                .padding(.trailing, 5)
        }
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: dev.coin, showHolding: true)
            .preferredColorScheme(.dark)
    }
}

extension CoinRowView {
    
    private var leftColumn: some View {
        HStack (spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            ZStack {
                CoinImageView(coin: coin)
                    .frame(width: 30, height: 30)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.7))
                    )
            }
            VStack(alignment: .leading){
                Text(coin.symbol.uppercased())
                    .font(.headline)
                    .padding(.leading, 3)
                    .foregroundColor(Color.theme.accent)
                Text(coin.name)
                    .font(.system(size: 8))
                    .foregroundColor(Color.theme.secondaryText)
                    .padding(.leading, 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width/3.1, alignment: .leading)
        .lineLimit(1)
        .minimumScaleFactor(0.1)
    }
    
    private var rightColumn: some View {
        VStack (alignment: .trailing){
            Text(coin.current_price.asCurrencyWith6Decimals())
                .bold()
                .foregroundColor(
                    (coin.price_change_percentage_24h ?? 0) >= 0 ?
                        Color.theme.green :
                        Color.theme.red
                    )
            Text(coin.price_change_percentage_24h?.asPercentString() ?? "0.00%")
                .font(.caption)
                .foregroundColor(
                    (coin.price_change_percentage_24h ?? 0) >= 0 ?
                    Color.theme.green :
                    Color.theme.red
                )
        }
        .frame(width: UIScreen.main.bounds.width/3.8, alignment: .trailing)
        .lineLimit(1)
        .minimumScaleFactor(0.1)
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing) {
            let holdingValue: Double = (coin.currentHolding ?? 0.0) * coin.current_price
            Text("$"+holdingValue.formattedWithAbbreviations())
                .foregroundColor((coin.price_change_percentage_24h ?? 0)>=0 ?
                                 Color.theme.green:
                                 Color.theme.red)
                .bold()
            
            Text( (coin.currentHolding ?? 0.0).suffixNumber() )
                .foregroundColor(Color.theme.secondaryText)
                .font(.caption)
        }
        .frame(width: UIScreen.main.bounds.width/3.5, alignment: .trailing)
        .lineLimit(1)
        .minimumScaleFactor(0.1)
    }
}
