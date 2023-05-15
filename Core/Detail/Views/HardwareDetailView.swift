//
//  HardwareDetailView.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 9/10/22.
//

import SwiftUI
import SwiftUIX

struct HardwareDetailLoadingView: View {
    
    @Binding var hardware: Hardware?
    
    var body: some View {
        ZStack {
            if let hardware = hardware {
                HardwareDetailView(hardware: hardware)
            }
        }
    }
}

struct HardwareDetailView: View {
    
    @StateObject private var vm: HardwareDetailViewModel
    @Environment(\.colorScheme) var colorScheme
    
    private let columns: [GridItem] = [GridItem(.flexible()),
                                       GridItem(.flexible())]
    
    private let columnsMining: [GridItem] = [GridItem(.flexible()),
                                             GridItem(.flexible()),
                                             GridItem(.flexible())]
    private let spacing: CGFloat = 20
        
    init(hardware: Hardware) {
        _vm = StateObject(wrappedValue: HardwareDetailViewModel(hardware: hardware))
    }
    
    var body: some View {
        ZStack {
            
            if (colorScheme == .light) {
                LightBackgroundView()
                    .ignoresSafeArea(.all, edges: [.top, .trailing])
            } else {
                DarkBackgroundView()
                    .ignoresSafeArea(.all, edges: [.top, .trailing])
            }
            
            ScrollView {
                
                VStack (spacing: 10) {
                    Text("Hardware Information")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.theme.accent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    LazyVGrid(columns: columns,
                        alignment: .center,
                        spacing: spacing,
                        pinnedViews: [],
                        content:{
                        ForEach(vm.hardwareDetailOverViewStatistics) { stat in
                            StatisticView(stat: stat)
                                .padding(.leading)
                                .padding(.top)
                        }
                    })
                    .background(
                        VisualEffectBlurView(blurStyle: .systemUltraThinMaterial)
                            .cornerRadius(10)
                    )
                    .overlay(RoundedRectangle(cornerRadius: 10,style: .continuous).stroke(lineWidth: 1).fill(Color.theme.background))
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)

                }
                .padding()
                
                VStack (alignment: .leading, spacing: 10) {
                    Text("Your Choice vs. Best Choice")
                        .font(.title)
                        .bold()
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(Color.theme.accent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Daily profits are shown under coin Icons. Unit Power Consumption/Daily Reward/Daily Cost are shown in black/green/red, respectively.The percentage bar shows the profit comparison between your choice and suggestion.")
                        .font(.footnote)
                        .bold()
                        .foregroundColor(Color.theme.secondaryText)
                        .multilineTextAlignment(.leading)
                                    
                    HStack {
                        Spacer()
                        HardwareCoinProfitVerticalBiggerView(coin: vm.hardware.myCoin ?? SupportCoinDetail(id: "N/A", name: "N/A", symbol: "N/A", price: 0, yeild: 0, reward: 0, profit: 0, blocktime: 0, blockreward: 0, algorithm: "N/A", nethash: 0, power: 0, speed: 0, image: "N/A"))
                            .padding()
                        
                        VStack{
                            let power = vm.hardware.unit_power ?? 0
                            Text(power <= 0 ? "N/A W" :"\(power.asNumberWith0Decimals()) W")
                                .font(.system(size: 12))
                                .foregroundColor(Color.theme.accent)
                                .bold()
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .padding(.trailing, 3)
                            
                            let reward = vm.hardware.myCoin?.reward ?? 0
                            let profit = vm.hardware.myCoin?.profit ?? 0
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
                        
                        Spacer()
                        let score = vm.hardware.profitRate
                        RingBar(progress: score ?? 0)
                        Spacer()
                        VStack{
                            let power = Double(vm.hardware.bestCoin?.power ?? 0)
                            Text(power <= 0 ? "N/A W" :"\(power.asNumberWith0Decimals()) W")
                                .font(.system(size: 12))
                                .foregroundColor(Color.theme.accent)
                                .bold()
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .padding(.trailing, 3)
                            
                            let reward = vm.hardware.bestCoin?.reward ?? 0
                            let profit = vm.hardware.bestCoin?.profit ?? 0
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
                        HardwareCoinProfitVerticalBiggerView(coin: vm.hardware.bestCoin ?? SupportCoinDetail(id: "N/A", name: "N/A", symbol: "N/A", price: 0, yeild: 0, reward: 0, profit: 0, blocktime: 0, blockreward: 0, algorithm: "N/A", nethash: 0, power: 0, speed: 0, image: "N/A"))
                            .padding()
                        Spacer()
                    }
                    .background(
                        VisualEffectBlurView(blurStyle: .systemUltraThinMaterial)
                            .cornerRadius(10)
                    )
                    .overlay(RoundedRectangle(cornerRadius: 10,style: .continuous).stroke(lineWidth: 1).fill(Color.theme.background))
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding()
                
                VStack (alignment: .leading, spacing: 10) {
                    
                    Text("Support Coins")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.theme.accent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Daily profits are shown under coin symbols")
                        .font(.footnote)
                        .bold()
                        .foregroundColor(Color.theme.secondaryText)
                    
                    LazyVGrid(columns: columnsMining,
                              alignment: .center,
                              spacing: spacing,
                              pinnedViews: [],
                              content:{
                                ForEach (vm.hardware.support_coins_details ?? [], id: \.name) { item in
                                    HardwareCoinProfitVerticalBiggerView(coin: item)
                                }
                    })
                    .background(
                        VisualEffectBlurView(blurStyle: .systemUltraThinMaterial)
                            .cornerRadius(10)
                    )
                    .overlay(RoundedRectangle(cornerRadius: 10,style: .continuous).stroke(lineWidth: 1).fill(Color.theme.background))
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding()
                
                VStack (spacing: 10) {
                    Text("Support Algorithms")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.theme.accent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    LazyVGrid(columns: columns,
                        alignment: .center,
                        spacing: spacing,
                        pinnedViews: [],
                        content:{
                        ForEach(vm.algorithmDetailStatistics) { stat in
                            AlgorithmStatisticView(stat: stat)
                                .padding(.leading)
                                .padding(.top)
                        }
                    })
                    .background(
                        VisualEffectBlurView(blurStyle: .systemUltraThinMaterial)
                            .cornerRadius(10)
                    )
                    .overlay(RoundedRectangle(cornerRadius: 10,style: .continuous).stroke(lineWidth: 1).fill(Color.theme.background))
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding()
            }
            .navigationTitle(vm.hardware.name)
            
        }
    }
}

struct HardwareDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HardwareDetailView(hardware: dev.amdprotype)
    }
}
