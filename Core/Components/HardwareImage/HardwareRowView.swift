//
//  HardwareRowView.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/31/22.
//

import SwiftUI

struct HardwareRowView: View {
    
    let hardware: Hardware
        
    var body: some View {

        HStack{
            leftColumn
                .padding(.leading, 5)
            Spacer()
            centerColumn
            Spacer()
            rightColumn
                .padding(.trailing, 5)
        }
    }
}

struct HardwareRowView_Previews: PreviewProvider {
    static var previews: some View {
        HardwareRowView(hardware: dev.amdprotype)
    }
}

extension HardwareRowView {
    
    private var leftColumn: some View {
        HStack (spacing: 0) {

            if ( hardware.brand_short == "NVDA" ) {
                Circle()
                    .fill(Color.theme.green)
                    .frame(width: 30, height: 30)
            } else if ( hardware.brand_short == "AMD" ) {
                Circle()
                    .fill(Color.theme.red)
                    .frame(width: 30, height: 30)
            } else {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 30, height: 30)
            }
            
            VStack(alignment: .leading){
                Text(hardware.name)
                    .font(.system(size: 15))
                    .fontWeight(.bold)
                    .padding(.leading, 3)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                .foregroundColor(Color.theme.accent)
                Text(hardware.specs?.correctMemSize ?? "N/A")
                    //.font(.custom("test", size: 8))
                    .font(.system(size: 10))
                    .foregroundColor(Color.theme.secondaryText)
                    .padding(.leading, 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width/2.5, alignment: .leading)
    }
    
    private var centerColumn: some View {
        HStack (alignment: .center) {
            HardwareCoinProfitHorizontalView(coin: hardware.bestCoin ?? SupportCoinDetail(id: "abc",name: "Ergo", symbol: "ERG", yeild: 0.433, reward: 0.897, profit: 0.675,image: "abc"))
        }
        .frame(width: UIScreen.main.bounds.width/3.75, alignment: .trailing)
    }
    
    private var rightColumn: some View {
        VStack (alignment: .trailing) {
            let best_power = hardware.bestCoin?.power ?? 0
            let price = hardware.bestCoin?.price ?? 0
            Text(price > 0 ? price.asCurrencyWithFlexDecimals() : "N/A")
                .font(.system(size: 12))
                .fontWeight(.bold)
                .padding(.leading, 3)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(best_power > 0 ? "\(best_power) Watt" : "N/A")
                .font(.system(size: 12))
                .fontWeight(.bold)
                .padding(.leading, 3)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .frame(width: UIScreen.main.bounds.width/3.75, alignment: .trailing)
    }

}
