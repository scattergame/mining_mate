//
//  UserHardwareCardLiteView.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/31/22.
//

import SwiftUI

struct UserHardwareCardLiteView: View {
    let hardware: Hardware
    //@State var progressValue: Float = 0.0
    
    var body: some View {
        ZStack {
            
            //Tag Background Color
            if ( hardware.brand_short == "NVDA" ) {
                Color.theme.green
                    .opacity(0.3)
                    .cornerRadius(8)
            } else if ( hardware.brand_short == "AMD" ) {
                Color.theme.red
                    .opacity(0.3)
                    .cornerRadius(8)
            } else {
                Color.blue
                    .opacity(0.3)
                    .cornerRadius(8)
            }
            
            //Card View
            HStack (spacing: -1) {
                // MARK: tag = AMD/NVDA/ASIC
                ZStack {
                    if ( hardware.brand_short == "NVDA" ) {
                        Rectangle()
                            .fill(.green)
                            .cornerRadius(8, corners: [.topLeft, .bottomLeft])
                    } else if ( hardware.brand_short == "AMD" ) {
                        Rectangle()
                            .fill(.red)
                            .cornerRadius(8, corners: [.topLeft, .bottomLeft])
                    } else {
                        Rectangle()
                            .fill(.blue)
                            .cornerRadius(8, corners: [.topLeft, .bottomLeft])
                    }
                    //Tag
                    Text(hardware.brand_short ?? "??")
                        .font(.caption)
                        .bold()
                        .foregroundColor(Color.theme.background)
                        .rotationEffect(Angle.degrees(-90))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(width: 35, height: 70)
                }
                .frame(width: 35, height: 70)
                
                // MARK: Hardware Name and Coin
                HStack (spacing: 3) {
                    VStack (alignment: .leading) {
                        // Title
                        HStack {
                            Text(hardware.name)
                                .font(.subheadline)
                                .fontWeight(.heavy)
                                .foregroundColor(Color.theme.accent)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            .padding(.leading, 3)
                            
                            Spacer()
                            
                            Text("x \(hardware.myQuantity ?? 0)")
                                .font(.caption)
                                .foregroundColor(Color.theme.accent)
                                .bold()
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                            .padding(.trailing, 3)
                        }
                        .padding(.top, 3)
                                                                        
                        HStack {
                            HardwareCoinProfitHorizontalView(coin: hardware.myCoin ?? SupportCoinDetail(id: "3232", name: "Ethereum", symbol: "ETH", price: 2.135, yeild: 0.33, reward: 0.59, profit: 0.45, blocktime: 13.67, blockreward: 2.0155, algorithm: "Ethash", nethash: 136669432132, power: 210, speed: 120000000, image: "eff"))
                                .padding(.leading, 3)
                                .padding(.bottom, 3)
                            Spacer()
                                                        
                            VStack (alignment: .trailing) {
                                let total_power = hardware.total_power ?? 0
                                Text(total_power <= 0 ? "N/A W" : "\(total_power.asNumberWith0Decimals()) W")
                                    .font(.caption)
                                    .foregroundColor(Color.theme.accent)
                                    .bold()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                    .padding(.trailing, 3)
                                
                                let total_profit = hardware.total_profit ?? 0
                                Text(total_profit <= 0 ? "N/A" : "\(total_profit.asCurrencyWith2Decimals())")
                                    .font(.caption)
                                    .foregroundColor(Color.theme.accent)
                                    .bold()
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.7)
                                    .padding(.trailing, 3)
                            }
                        }
                    }
                }
                //.frame(width: UIScreen.main.bounds.width/1.2, height: 70)
            }
        }
        .frame(height: 70)
    }

}

struct UserHardwareCardLiteView_Previews: PreviewProvider {
    static var previews: some View {
        UserHardwareCardLiteView(hardware: dev.amdprotype)
    }
}

