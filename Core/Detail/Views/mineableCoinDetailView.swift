//
//  mineableCoinDetailView.swift
//  MiningMate
//
//  Created by Chenxi Wang on 8/29/22.
//

import SwiftUI
import SwiftUIX

struct MineableCoinDetailLoadingView: View {
    
    @Binding var mineableCoin: MineableCoinModel?
    
    var body: some View {
        ZStack {
            if let mineableCoin = mineableCoin {
                mineableCoinDetailView(mineableCoin: mineableCoin)
            }
        }
    }
}

struct mineableCoinDetailView: View {
    
    @StateObject private var vm: MineableCoinDetailViewModel
    @Environment(\.colorScheme) var colorScheme
    
    private let columnsMining: [GridItem] = [GridItem(.flexible()),
                                             GridItem(.flexible()),
                                             GridItem(.flexible())]
    private let spacing: CGFloat = 20
    
    @State var showfullDescription: Bool = false
    
    init(mineableCoin: MineableCoinModel) {
        _vm = StateObject(wrappedValue: MineableCoinDetailViewModel(mineableCoin: mineableCoin))
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
                VStack(spacing: 20) {
                    ZStack (alignment: .topLeading)  {
                        LineGraphMinableView(data: vm.mineableCoinsparklinein7d.price ?? [], lastUpdated: vm.mineableCoinlastUpdated)
                            .frame(height: 200)
                            .background(
                                VisualEffectBlurView(blurStyle: .systemUltraThinMaterial)
                                    .cornerRadius(10)
                            )
                            .overlay(RoundedRectangle(cornerRadius: 10,style: .continuous).stroke(lineWidth: 1).fill(Color.theme.background))
                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        MineableCoinImageView(coin: vm.mineableCoin)
                            .frame(width: 50, height: 50)
                            .padding()
                    }
                    
                    Text("Overview")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.theme.accent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    LazyVGrid(columns: columnsMining,
                        alignment: .center,
                        spacing: spacing,
                        pinnedViews: [],
                        content:{
                        ForEach(vm.mineableCoinDetailOverViewStatistics) { stat in
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
                    
                    LazyVGrid(columns: columnsMining,
                        alignment: .center,
                        spacing: spacing,
                        pinnedViews: [],
                        content:{
                        ForEach(vm.mineableCoinDetailAdditionalStatistics) { stat in
                            StatisticView(stat: stat)
                                .padding(.horizontal)
                                .padding(.top)
                        }
                    })
                    .background(
                        VisualEffectBlurView(blurStyle: .systemUltraThinMaterial)
                            .cornerRadius(10)
                    )
                    .overlay(RoundedRectangle(cornerRadius: 10,style: .continuous).stroke(lineWidth: 1).fill(Color.theme.background))
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Divider()
                    
                    Text("Description")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.theme.accent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack (alignment: .trailing) {
                        Text(vm.mineableCoinDescription?.removingHTMLOccurances ?? "N/A")
                            .font(.body)
                            .lineLimit(showfullDescription ? .none : 5)
                            .padding(10)
                        Button {
                            withAnimation(.easeInOut) {
                                showfullDescription.toggle()
                            }
                        } label: {
                            Text(showfullDescription ? "show less..." : "show more ...")
                                .bold()
                                .foregroundColor(Color.blue)
                        }
                    }
                    .background(
                        VisualEffectBlurView(blurStyle: .systemUltraThinMaterial)
                            .cornerRadius(10)
                    )
                    .overlay(RoundedRectangle(cornerRadius: 10,style: .continuous).stroke(lineWidth: 1).fill(Color.theme.background))
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Divider()
                    
                    Text("Resources")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.theme.accent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack (alignment: .leading) {
                        if let coinwebsite = vm.mineableCoinWebsite,
                           let url1 = URL(string: coinwebsite) {
                            Link("\(vm.mineableCoin.name) website: \(coinwebsite )", destination: url1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(Color.blue)
                                .padding(10)
                        }
                        if let resourcewebsite = vm.mineableCoinResourceLink,
                           let url2 = URL(string: resourcewebsite) {
                            Link("Reddit link: \(resourcewebsite )", destination: url2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(Color.blue)
                                .padding(10)
                        }
                    }
                    .background(
                        VisualEffectBlurView(blurStyle: .systemUltraThinMaterial)
                            .cornerRadius(10)
                    )
                    .overlay(RoundedRectangle(cornerRadius: 10,style: .continuous).stroke(lineWidth: 1).fill(Color.theme.background))
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                }
                .padding()
            }
            .navigationTitle(vm.mineableCoin.name)
        }
    }
}

struct mineableCoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        mineableCoinDetailView(mineableCoin: dev.mineableCoin)
    }
}
