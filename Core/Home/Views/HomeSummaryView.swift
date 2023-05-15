//
//  HomeSummaryView.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 9/5/22.
//

import SwiftUI
import SwiftUIX

func getCurrentTime() -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    formatter.dateStyle = .none
    let timeString = formatter.string(from: Date())
    return timeString
}

func getCurrentDate() -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .none
    formatter.dateStyle = .medium
    let dateString = formatter.string(from: Date())
    return dateString
}

func getDateString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .none
    formatter.dateStyle = .medium
    let dateString = formatter.string(from: date)
    return dateString
}

func getTimeString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    formatter.dateStyle = .none
    let timeString = formatter.string(from: date)
    return timeString
}

struct HomeSummaryView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showUserSettingView: Bool = false    
    
    private let columnsMarket: [GridItem] = [GridItem(.flexible()),
                                             GridItem(.flexible())]
    
    private let columnsMining: [GridItem] = [GridItem(.flexible()),
                                             GridItem(.flexible()),
                                             GridItem(.flexible())]
    
    @State var dateNow: Date = Date()
    @State var summaryIndex: Int = 0
    @State var summaryIndexChangeCount: Int = 1
    let summaryIndexChangeMax: Int = 5
    
    var body: some View {
        // MARK: Full screen ZStack Layer
                        
        VStack (alignment: .leading) {
            //Text("")
            //    .frame( height: 20)
            
            HStack {
                Spacer()
                CircleButtonView(iconName: "gear")
                    .onTapGesture {
                        showUserSettingView.toggle()
                    }
            }
            .fullScreenCover(isPresented: $showUserSettingView, content: {
                UserSettingView()
                    .environmentObject(vm)
            })
            
            VStack (alignment: .leading, spacing: 10) {
                Text("Mining Mate")
                    .font(.title).bold()
                    .padding()
                HStack {
                    Spacer()
                    Text(getTimeString(date:dateNow))
                        .font(.system(size: 72))
                        .lineLimit(1)
                        .minimumScaleFactor(0.3)
                    Spacer()
                }
                .padding()
                HStack {
                    Spacer()
                    Text(getDateString(date:dateNow))
                        .font(.system(size: 32))
                        .lineLimit(1)
                        .minimumScaleFactor(0.3)
                    Spacer()
                }
                .padding()
                
            }
            .padding()
            .foregroundColor(Color.theme.accent)
            
            VStack {
                TabView(selection: $summaryIndex) {
                    summaryMarket
                        .tabItem({
                            Image(systemName: "circle")
                                .foregroundColor(Color.theme.accent)
                        })
                        .tag(0)
                    summaryMining
                        .tabItem({
                            Image(systemName: "circle")
                                .foregroundColor(Color.theme.accent)
                        })
                        .tag(1)
                    summaryHardware
                        .tabItem({
                            Image(systemName: "circle")
                                .foregroundColor(Color.theme.accent)
                        })
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .onAppear() {
                    UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.theme.accent)
                    UIPageControl.appearance().pageIndicatorTintColor = .gray
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .background(
                VisualEffectBlurView(blurStyle: .systemUltraThinMaterial)
                    .cornerRadius(10)
            )
            .overlay(RoundedRectangle(cornerRadius: 10,style: .continuous).stroke(lineWidth: 1).fill(Color.theme.background))
            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
            .padding()
            
        }
        .onReceive(vm.timer) { value in
            dateNow = value
            withAnimation(.easeInOut) {
                summaryIndexChangeCount = summaryIndexChangeCount < summaryIndexChangeMax ? summaryIndexChangeCount + 1 : 0
                if ( summaryIndexChangeCount == 0 ) {
                    summaryIndex = summaryIndex == 2 ? 0 : summaryIndex + 1
                }
            }
        }
        .onChange(of: summaryIndex) { selection in
            summaryIndexChangeCount = 1
        }
    }
}

struct HomeSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeSummaryView()
                .environmentObject(dev.homeVM)
                .preferredColorScheme(.light)
//                .previewLayout(.sizeThatFits)
//            HomeSummaryView()
//                .environmentObject(dev.homeVM)
//                .preferredColorScheme(.dark)
//                .previewLayout(.sizeThatFits)
        }
    }
}

extension HomeSummaryView {
    

    private var summaryMarket: some View {
        VStack {
            Text("Crypto Market Summary")
                .bold()
                .padding()
                .foregroundColor(Color.theme.accent)
            LazyVGrid(columns: columnsMarket,
                alignment: .center,
                spacing: 20,
                pinnedViews: [],
                content:{
                ForEach(vm.statistics) { stat in
                    StatisticView(stat: stat)
                        .padding(.leading)
                }
                })
        }
    }
    
    private var summaryMining: some View {
        VStack {
            Text("Mining Status")
                .bold()
                .padding()
                .foregroundColor(Color.theme.accent)
            LazyVGrid(columns: columnsMining,
                alignment: .center,
                spacing: 20,
                pinnedViews: [],
                content:{
                ForEach(vm.miningstatistics) { stat in
                    MiningStatisticView(stat: stat)
                        .padding(.leading)
                }
            })
        }
    }
    
    private var summaryHardware: some View {
        VStack {
            Text("Hardware Status")
                .bold()
                .padding()
                .foregroundColor(Color.theme.accent)
            LazyVGrid(columns: columnsMining,
                alignment: .center,
                spacing: 20,
                pinnedViews: [],
                content:{
                ForEach(vm.hardwarestatistics) { stat in
                    HardwareStatisticView(stat: stat)
                        .padding(.leading)
                }
            })
            
        }
    }
    
}
