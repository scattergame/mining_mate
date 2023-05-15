//
//  UserHardwareCardView.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 9/1/22.
//

import SwiftUI

struct UserHardwareCardView: View {
    
    let hardware: Hardware
    
    var body: some View {
        ZStack{
            if ( hardware.brand_short == "NVDA" ) {
                Color.theme.background
                    .opacity(0.8)
                    .cornerRadius(8)
                    //.blur(radius: 10)
            } else if ( hardware.brand_short == "AMD" ) {
                Color.theme.background
                    .opacity(0.8)
                    .cornerRadius(8)
                    //.blur(radius: 10)
            } else {
                Color.theme.background
                    .opacity(0.8)
                    .cornerRadius(8)
                    //.blur(radius: 10)
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
                        .frame(width: 35, height: 75)
                }
                .frame(width: 35, height: 75)
                
                
                // MARK: Hardware Name and Coin
                VStack (alignment: .leading, spacing: 3) {
                    
                    Text(hardware.name)
                        .font(.subheadline)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.theme.accent)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.leading, 3)
                                                                                        
                    HStack {
                        HardwareCoinProfitHorizontalView(coin:hardware.myCoin ?? SupportCoinDetail(id:"3232", name: "Ethereum", symbol: "ETH",price: 2.135, yeild: 0.33, reward: 0.59,profit: 0.45, blocktime: 13.67, blockreward:2.0155, algorithm: "Ethash", nethash:136669432132, power: 210, speed: 120000000,image: "eff"))
                            .padding(.leading, 3)
                            .padding(.bottom, 3)

                        Divider()
                        Spacer()
                        VStack (alignment: .trailing) {
                            let speed = hardware.myCoin?.speed ?? 0
                            Text(speed <= 0 ? "N/A H/s" : "\(speed.formattedWithHashrate())")
                                .font(.system(size: 12))
                                .foregroundColor(Color.theme.accent)
                                .bold()
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .padding(.trailing, 3)
                                                        
                            let power = hardware.unit_power ?? 0
                            Text(power <= 0 ? "N/A W" :"\(power.asNumberWith0Decimals()) W")
                                .font(.system(size: 12))
                                .foregroundColor(Color.theme.accent)
                                .bold()
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .padding(.trailing, 3)
                            
                            let reward = hardware.myCoin?.reward ?? 0
                            let profit = hardware.myCoin?.profit ?? 0
                            let cost = reward - profit
                            
                            Text(reward.asCurrencyWith2Decimals())
                                .font(.system(size: 12))
                                .foregroundColor(Color.theme.green)
                                .bold()
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .padding(.trailing, 3)
                            Text("(-\(cost.asCurrencyWith2Decimals()))")
                                .font(.system(size: 12))
                                .foregroundColor(Color.theme.red)
                                .bold()
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .padding(.trailing, 3)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width/2.5)
                }
                .frame(width: UIScreen.main.bounds.width/2.5, height: 75)
                
                Divider()
                    .padding(.horizontal, 10)
                                
                HStack {
                    VStack (alignment: .leading, spacing: 2) {
                        let quan = Double(hardware.myQuantity ?? 0)
                        let total_hash = (hardware.myCoin?.speed ?? 0) * quan
                        let power = Double(hardware.myCoin?.power ?? 0)
                        let total_power = power * quan
                        let total_profit = (hardware.myCoin?.profit ?? 0) * quan
                        let bestCoin = hardware.bestCoin?.symbol ?? "unknown"

                        HStack {
                            Text(Image(systemName: "speedometer"))
                                .font(.caption)
                                .foregroundColor(Color.theme.accent)
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                            Spacer()
                            Text(" \(total_hash.formattedWithHashrate())")
                                .font(.caption)
                                .foregroundColor(Color.theme.accent)
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                        }
                        HStack {
                            Text(Image(systemName: "bolt.circle"))
                                .font(.caption)
                                .foregroundColor(Color.theme.accent)
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                            Spacer()
                            Text(power != 0 ? "\(total_power.asNumberWith0Decimals()) W" : "0 ? W" )
                                .font(.caption)
                                .foregroundColor(Color.theme.accent)
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                        }
                        HStack {
                            Text(Image(systemName: "dollarsign.circle"))
                                .font(.caption)
                                .foregroundColor(Color.theme.accent)
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                            Spacer()
                            Text("\(total_profit.asCurrencyWith2Decimals())")
                                .font(.caption)
                                .foregroundColor(Color.theme.accent)
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                        }
                        HStack {
                            Text(Image(systemName: "lightbulb"))
                                .font(.caption)
                                .foregroundColor(Color.theme.accent)
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                            Spacer()
                            let bestcoinprofit = hardware.bestCoin?.profit ?? 0
                            Text("\(bestCoin) \(bestcoinprofit.asCurrencyWith2Decimals())")
                                .font(.caption)
                                .foregroundColor(Color.theme.accent)
                                .lineLimit(1)
                            .minimumScaleFactor(0.6)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width/4, height: 75)
                    .padding(.horizontal, 5)
                }
                
                Divider()
                    .padding(.horizontal)
                
                VStack {
                    Spacer()
                    Text("x \(hardware.myQuantity ?? 0)")
                        .font(.subheadline)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.theme.accent)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .padding(.trailing, 3)
                    Spacer()
                    RingBar(progress: hardware.profitRate ?? 0)
                    Spacer()
                }
            }
        }
        .frame(height: 75)
        .cornerRadius(10)
    }
}

struct UserHardwareCardView_Previews: PreviewProvider {
    static var previews: some View {
        UserHardwareCardView(hardware: dev.amdprotype)
    }
}
