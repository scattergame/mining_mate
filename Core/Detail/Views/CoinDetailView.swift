//
//  CoinDetailView.swift
//  MiningMate
//
//  Created by Chenxi Wang on 8/28/22.
//

import SwiftUI
import SwiftUIX

struct CoinDetailLoadingView: View {
    
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                CoinDetailView(coin: coin)
            }
        }
    }
}

struct CoinDetailView: View {
    
    @StateObject private var vm: CoinDetailViewModel
    @Environment(\.colorScheme) var colorScheme
    
    private let columns: [GridItem] = [GridItem(.flexible()),
                                       GridItem(.flexible())]
    private let spacing: CGFloat = 30
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
    }
    
    @State var showfullDescription: Bool = false
    
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
                    ZStack (alignment: .topLeading) {
                        LineGraphView(coin: vm.coin)
                            .frame(height: 200)
                            .background(
                                VisualEffectBlurView(blurStyle: .systemUltraThinMaterial)
                                    .cornerRadius(10)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10,style: .continuous).stroke(lineWidth: 1).fill(Color.theme.background)
                            )
                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        CoinImageView(coin: vm.coin)
                            .frame(width: 50, height: 50)
                            .padding()
                    }
                    
                    Text("Overview")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.theme.accent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    
                    
                    LazyVGrid(columns: columns,
                        alignment: .center,
                        spacing: spacing,
                        pinnedViews: [],
                        content:{
                        ForEach(vm.overviewStatistics) { stat in
                            StatisticView(stat: stat)
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
                        Text(vm.coinDescription?.removingHTMLOccurances ?? "N/A")
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
                        if let coinwebsite = vm.coinWebsite,
                           let url1 = URL(string: coinwebsite) {
                            Link("\(vm.coin.name) website: \(vm.coinWebsite ?? "N/A")", destination: url1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(Color.blue)
                                .padding(10)
                        }
                        if let resourcewebsite = vm.resourceLink,
                           let url2 = URL(string: resourcewebsite) {
                            Link("Reddit link: \(vm.resourceLink ?? "N/A")", destination: url2)
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
            .navigationTitle(vm.coin.name)
        }
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CoinDetailView(coin: dev.coin)
        }
    }
}
