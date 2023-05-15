//
//  HomeView.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/29/22.
//

import SwiftUI
import SwiftUIX

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @Environment(\.colorScheme) var colorScheme

    @State private var selectMarketViewTab: CoinViewTabs = .all
    @State private var selectMineableCoinViewTab: CoinViewTabs = .all
    
    @State private var showCoinSearchBar: Bool = false
    
    @State private var showMineableCoinSearchBar: Bool = false
    
    @State private var showHardwareSearchBar: Bool = false
    //@State private var searchHardwareText: String = ""
    
    @State private var showWatchlistCoinEditView: Bool = false
    @State private var showHardwareEditView: Bool = false
    
    @State private var showDeleteUserHardwareConfirmation = false
    @State private var userHardwaretoDelete: Hardware? = nil
    
    @State private var selectedCoin: CoinModel? = nil
    @State private var showCoinDetailView: Bool = false
    
    @State private var selectedMineableCoin: MineableCoinModel? = nil
    @State private var showMineableCoinDetailView: Bool = false
    
    @State private var selectedHardware: Hardware? = nil
    @State private var showHardwareDetailView: Bool = false
        
    let minimumRefreshMinute: Double = 1
        
    enum CoinViewTabs: String {
        case all = "all coins"
        case list = "watchlist coins"
    }
        
    private let columns: [GridItem] = [GridItem(.flexible()),
                                       GridItem(.flexible())]
    
    private let columnsMining: [GridItem] = [GridItem(.flexible()),
                                             GridItem(.flexible()),
                                             GridItem(.flexible())]

    var body: some View {
        // MARK: TabView Level 1
        ZStack {
            
            TabView {
                
                // MARK: TabView Level 1 - Summary View
                
                ZStack {
                    if (colorScheme == .light) {
                        LightBackgroundView()
                            .ignoresSafeArea(.all, edges: [.top, .trailing])
                    } else {
                        DarkBackgroundView()
                            .ignoresSafeArea(.all, edges: [.top, .trailing])
                    }
                    HomeSummaryView()
                    
                }
                .tabItem({
                    Image(systemName: "person.crop.circle.fill")
                        .foregroundColor(Color.theme.accent)
                    Text("Summary")
                })
                
                // MARK: TabView Level 1 - Hardware View
                ZStack {
                    userHardwareView
                }
                .fullScreenCover(isPresented: $showHardwareEditView, content: {
                    UserHardwareEditView()
                        .environmentObject(vm)
                })
                .tabItem({
                    Image(systemName: "cpu.fill")
                        .foregroundColor(Color.theme.accent)
                    Text("Hardware")
                })
            
                
                // MARK: TabView Level 1 - Mineable Coin View
                ZStack {
                    mineableCoinView
                }
                .tabItem({
                    Image(systemName: "hammer.circle.fill")
                        .foregroundColor(Color.theme.accent)
                    Text("Mining")
                })
                                
                
                // MARK: TabView Level 1 - Crypto Market View
                ZStack {
                    cryptoMarketView
                }
                .fullScreenCover(isPresented: $showWatchlistCoinEditView, content: {
                    WatchlistCoinEditView()
                        .environmentObject(vm)
                })
                .tabItem({
                    Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                        .foregroundColor(Color.theme.accent)
                    Text("Market")
                })
                
                
                
                
                
                
            }
        }
        .onReceive(vm.timer) { value in
            //dateNow = value
            //print (value - vm.lastRefresh, vm.refreshRate, vm.refreshRateAS)
            if Double(value - vm.lastRefresh)/60.0 > Double(vm.refreshRate) {
                //print (
                vm.reloadAllData()
            }
        }
        .onAppear{
            //print ("Sync refreshRate")
            var refreshminute: Int {
                switch vm.refreshRateAS {
                case .one:
                    return 1
                case .two:
                    return 2
                case .three:
                    return 3
                case .five:
                    return 5
                case .ten:
                    return 10
                case .fifteen:
                    return 15
                case .thirty:
                    return 30
                case .sixty:
                    return 60
                }
            }
            vm.refreshRate = refreshminute
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(dev.homeVM)
            .preferredColorScheme(.light)
    }
}


extension HomeView {
    
    // MARK: View 1 - Crypto Market View
    private var cryptoMarketView: some View {
        NavigationView {
            ZStack {
                
                if (colorScheme == .light) {
                    LightBackgroundView()
                        .ignoresSafeArea(.all, edges: [.top, .trailing])
                } else {
                    DarkBackgroundView()
                        .ignoresSafeArea(.all, edges: [.top, .trailing])
                }
                
                VStack {
                    
                    cryptoMarketViewHeader
                    cryptoMarketOverView
                    updateLastBar
                    
                    VStack {
                        
                        cryptoCoinListTitle
                            .padding(.vertical)
                        
                        TabView(selection: $selectMarketViewTab) {
                            VStack {
                                cryptoCoinAllView
                            }
                            .tabItem {
                                Image(systemName: "circle").foregroundColor(Color.theme.accent)
                            }
                            .tag(CoinViewTabs.all)
                            
                            VStack {
                                cryptoCoinMylistView
                            }
                            .tabItem {
                                Image(systemName: "circle").foregroundColor(Color.theme.accent)
                            }
                            .tag(CoinViewTabs.list)
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .onAppear() {
                            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.theme.accent)
                            UIPageControl.appearance().pageIndicatorTintColor = .gray
                        }
                    }
                    .background(
                        VisualEffectBlurView(blurStyle: .systemMaterial)
                            .cornerRadius(10)
                    )
                    .overlay(RoundedRectangle(cornerRadius: 10,style: .continuous).stroke(lineWidth: 1).fill(Color.theme.background))
                    .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: -10)
                    .padding()
                }
                .navigationBarHidden(true)
                .background(
                    NavigationLink(destination: CoinDetailLoadingView(coin: $selectedCoin),
                                   isActive: $showCoinDetailView,
                                   label: { EmptyView() } )
                )
            }
        }
    }

    // MARK: View 1 - 1 Crypto Market View Header
    private var cryptoMarketViewHeader: some View {
        HStack {
            CircleButtonView(iconName: "plus")
                .transaction { transaction in
                    transaction.animation = nil
                }
                .onTapGesture {
                    showWatchlistCoinEditView.toggle()
                    selectMarketViewTab = .list
                }
            
            Spacer()
            if !showCoinSearchBar {
                Text(selectMarketViewTab == .all ? "All Coins" : "Watchlist")
                    .font(.headline)
                    .bold()
                    .foregroundColor(Color.theme.accent)
            }
            
            HStack (spacing: 0) {
                
                SearchBarView(searchText: $vm.searchCoinText)
                    .opacity(showCoinSearchBar ? 1.0 : 0)
                
                Button {
                    withAnimation {
                        showCoinSearchBar.toggle()
                        UIApplication.shared.endEditing()
                    }
                } label: {
                    CircleButtonView(iconName: showCoinSearchBar ? "xmark" : "magnifyingglass")
                }
            }
        }
        .frame(height: 55)
    }
    
    // MARK: View 1 - 2 Crypto Market View Market Data OverView
    private var cryptoMarketOverView: some View {
        VStack {
            LazyVGrid(columns: columns,
                alignment: .center,
                spacing: 20,
                pinnedViews: [],
                content:{
                ForEach(vm.statistics) { stat in
                    StatisticView(stat: stat)
                        .padding(.leading)
                }
            })
            .padding(.top)
        }
        .frame(maxWidth: .infinity)
        .background(
            VisualEffectBlurView(blurStyle: .systemUltraThinMaterial)
                .cornerRadius(10)
        )
        .overlay(RoundedRectangle(cornerRadius: 10,style: .continuous).stroke(lineWidth: 1).fill(Color.theme.background))
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
        .padding()
    }
    
    private var updateLastBar: some View {
        HStack{
            let n = vm.allCoins.count
            if (n>0) {
                let highrankcoin = vm.allCoins.min { a, b in a.rank < b.rank }
                
                Text( "As of " + (highrankcoin?.last_updated?.dateasString() ?? "null") )
                    .foregroundColor(Color.theme.secondaryText)
                    .bold()
                    .font(.caption)
            }
        }
    }
    
    // MARK: View 1 - 3.0 All crypto Coins List column Title
    private var cryptoCoinListTitle: some View {
        HStack {
            //MARK: Rank Title
            HStack (spacing: 3) {
                Text("   # ")
                    .fontWeight((vm.coinSortOption == .rank || vm.coinSortOption == .rankReversed) ? .bold : .none)
                    .foregroundColor( (vm.coinSortOption == .rank || vm.coinSortOption == .rankReversed) ? Color.theme.accent : Color.theme.secondaryText )
                Image(systemName: "chevron.down")
                    .opacity( (vm.coinSortOption == .rank || vm.coinSortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.coinSortOption == .rank ? 0 : 180.0))
            }
            .background(Color.clear)
            .padding(.horizontal, 10)
            .onTapGesture {
                withAnimation (.default) {
                    vm.coinSortOption = (vm.coinSortOption == .rank) ? .rankReversed : .rank
                }
            }
            
            //MARK: CoinName (alphabetically)
            HStack (spacing: 3) {
                Text("Coin")
                    .fontWeight((vm.coinSortOption == .alphabetical || vm.coinSortOption == .alphabeticalReversed) ? .bold : .none)
                    .foregroundColor( (vm.coinSortOption == .alphabetical || vm.coinSortOption == .alphabeticalReversed) ? Color.theme.accent : Color.theme.secondaryText )
                
                Image(systemName: "chevron.down")
                    .opacity( (vm.coinSortOption == .alphabetical || vm.coinSortOption == .alphabeticalReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.coinSortOption == .alphabetical ? 0 : 180.0))

            }
            .padding(.leading, 10)
            .frame(width: UIScreen.main.bounds.width/3.2, alignment: .leading)
            .onTapGesture {
                withAnimation (.default) {
                    vm.coinSortOption = (vm.coinSortOption == .alphabetical) ? .alphabeticalReversed : .alphabetical
                }
            }
            
            Spacer()
            
            if (selectMarketViewTab == .list) {
                HStack {
                    Text("Holdings")
                        .fontWeight((vm.coinSortOption == .holding || vm.coinSortOption == .holdingReversed) ? .bold : .none)
                        .foregroundColor( (vm.coinSortOption == .holding || vm.coinSortOption == .holdingReversed) ? Color.theme.accent : Color.theme.secondaryText )
                    Image(systemName: "chevron.down")
                        .opacity( (vm.coinSortOption == .holding || vm.coinSortOption == .holdingReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.coinSortOption == .holding ? 0 : 180.0))
                }
                .onTapGesture {
                    withAnimation (.default) {
                        vm.coinSortOption = (vm.coinSortOption == .holding) ? .holdingReversed : .holding
                    }
                }
            }
            
            HStack {
                Text("Price")
                    .fontWeight((vm.coinSortOption == .price || vm.coinSortOption == .priceReversed) ? .bold : .none)
                    .foregroundColor( (vm.coinSortOption == .price || vm.coinSortOption == .priceReversed) ? Color.theme.accent : Color.theme.secondaryText )
                Image(systemName: "chevron.down")
                    .opacity( (vm.coinSortOption == .price || vm.coinSortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.coinSortOption == .price ? 0 : 180.0))
            }
            .frame(width: UIScreen.main.bounds.width/4, alignment: .trailing)
            .onTapGesture {
                withAnimation (.default) {
                    vm.coinSortOption = (vm.coinSortOption == .price) ? .priceReversed : .price
                }
            }

        }
        .font (.caption)
        .foregroundColor(Color.theme.secondaryText)
        .lineLimit(1)
        .minimumScaleFactor(0.1)
    }
    
    // MARK: View 1 - 3.1 All Crypto Coins List
    private var cryptoCoinAllView: some View {
        VStack{
            List {
                ForEach(vm.allCoins) { coin in
                    CoinRowView(coin: coin, showHolding: false)
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                        .listRowBackground(Color.clear)
                        .onTapGesture {
                            segue(coin: coin)
                        }
                }
            }
            .listStyle(PlainListStyle())
            .refreshable {
                let secondSinceLastRefresh = Double(Date() - vm.lastRefresh)/60.0
                if (secondSinceLastRefresh > minimumRefreshMinute) {
                    vm.reloadAllData()
                }
            }
        }
    }
    
    // MARK: View 1 - 3.2 Watch list Coins
    private var cryptoCoinMylistView: some View {
        VStack{
            List {
                ForEach(vm.watchlistCoins) { coin in
                    CoinRowView(coin: coin, showHolding: true)
                        .listRowInsets(.init(top:10, leading: 0, bottom: 10, trailing: 0))
                        .listRowBackground(Color.clear)
                        .onTapGesture {
                            segue(coin: coin)
                        }
                }
            }
            .listStyle(PlainListStyle())
            .refreshable {
                let secondSinceLastRefresh = Double(Date() - vm.lastRefresh)/60.0
                if (secondSinceLastRefresh > minimumRefreshMinute) {
                    vm.reloadAllData()
                }
            }
        }
    }
    
    
    // MARK: View 2 - Mineable Coin View
    private var mineableCoinView: some View {
        NavigationView {
            
            ZStack {
                
                if (colorScheme == .light) {
                    LightBackgroundView()
                        .ignoresSafeArea(.all, edges: [.top, .trailing])
                } else {
                    DarkBackgroundView()
                        .ignoresSafeArea(.all, edges: [.top, .trailing])
                }
                
                VStack {
                    
                    mineableCoinsViewHeader
                    miningOverView
                    updateLastBar
                    
                    VStack {
                        mineableCoinListTitle
                            .padding(.vertical)
                        
                        TabView(selection: $selectMineableCoinViewTab) {
                            VStack {
                                mineableCoinAllView
                            }
                            .tabItem {
                                Image(systemName: "circle").foregroundColor(Color.theme.accent)
                            }
                            .tag(CoinViewTabs.all)
                            
                            VStack {
                                mineableCoinCurrentView
                            }
                            .tabItem {
                                Image(systemName: "circle").foregroundColor(Color.theme.accent)
                            }
                            .tag(CoinViewTabs.list)
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .onAppear() {
                            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.theme.accent)
                            UIPageControl.appearance().pageIndicatorTintColor = .gray
                        }
                    }
                    .background(
                        VisualEffectBlurView(blurStyle: .systemMaterial)
                            .cornerRadius(10)
                    )
                    .overlay(RoundedRectangle(cornerRadius: 10,style: .continuous).stroke(lineWidth: 1).fill(Color.theme.background))
                    .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: -10)
                    .padding()
                    
                }
                .navigationBarHidden(true)
                .background(
                    NavigationLink(destination: MineableCoinDetailLoadingView(mineableCoin: $selectedMineableCoin),
                        isActive: $showMineableCoinDetailView,
                        label: { EmptyView() } )
                    )
            }
        }
    }
    
    // MARK: View 2 - 1 Mineable Coins View Header
    private var mineableCoinsViewHeader: some View {
        HStack {
            CircleButtonView(iconName: "plus")
                .opacity(0)
            Spacer()
            if !showMineableCoinSearchBar {
                Text(selectMineableCoinViewTab == .all ? "All Mineable Coins" : "Mining Coins")
                    .font(.headline)
                    .bold()
                    .foregroundColor(Color.theme.accent)
            }
            
            HStack (spacing: 0) {
                SearchBarView(searchText: $vm.searchMineableCoinText)
                    .opacity(showMineableCoinSearchBar ? 1.0 : 0)
                Button {
                    withAnimation {
                        showMineableCoinSearchBar.toggle()
                        UIApplication.shared.endEditing()
                    }
                } label: {
                    CircleButtonView(iconName: showMineableCoinSearchBar ? "xmark" : "magnifyingglass")
                }
            }
        }
        .frame(height: 55)
    }
    
    // MARK: View 2 - 2 Mining Overall View
    private var miningOverView: some View {
        
        VStack {
            LazyVGrid(columns: columnsMining,
                alignment: .center,
                spacing: 15,
                pinnedViews: [],
                content:{
                ForEach(vm.miningstatistics) { stat in
                    MiningStatisticView(stat: stat)
                        .padding(.leading)
                }
            })
            .padding()
        }
        .background(
            VisualEffectBlurView(blurStyle: .systemUltraThinMaterial)
                .cornerRadius(10)
        )
        .overlay(RoundedRectangle(cornerRadius: 10,style: .continuous).stroke(lineWidth: 1).fill(Color.theme.background))
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
        .padding()
    }
    
    // MARK: View 2 - 3.0 Mineable Coins List column Title
    private var mineableCoinListTitle: some View {
        HStack {
            //MARK: Rank Title
            HStack (spacing: 3) {
                Text("   # ")
                    .fontWeight((vm.mineablecoinSortOption == .rank || vm.coinSortOption == .rankReversed) ? .bold : .none)
                    .foregroundColor( (vm.mineablecoinSortOption == .rank || vm.mineablecoinSortOption == .rankReversed) ? Color.theme.accent : Color.theme.secondaryText )
                Image(systemName: "chevron.down")
                    .opacity( (vm.mineablecoinSortOption == .rank || vm.mineablecoinSortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.mineablecoinSortOption == .rank ? 0 : 180.0))
            }
            .padding(.horizontal, 5)
            .background(Color.clear)
            .onTapGesture {
                withAnimation (.default) {
                    vm.mineablecoinSortOption = (vm.mineablecoinSortOption == .rank) ? .rankReversed : .rank
                }
            }
            
            //MARK: CoinName (alphabetically)
            HStack (spacing: 3) {
                Text("Coin")
                    .fontWeight((vm.mineablecoinSortOption == .alphabetical || vm.mineablecoinSortOption == .alphabeticalReversed) ? .bold : .none)
                    .foregroundColor( (vm.mineablecoinSortOption == .alphabetical || vm.mineablecoinSortOption == .alphabeticalReversed) ? Color.theme.accent : Color.theme.secondaryText )
                
                Image(systemName: "chevron.down")
                    .opacity( (vm.mineablecoinSortOption == .alphabetical || vm.mineablecoinSortOption == .alphabeticalReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.mineablecoinSortOption == .alphabetical ? 0 : 180.0))
            }
            .padding(.leading, 10)
            .frame(width: UIScreen.main.bounds.width/3, alignment: .leading)
            .onTapGesture {
                withAnimation (.default) {
                    vm.mineablecoinSortOption = (vm.mineablecoinSortOption == .alphabetical) ? .alphabeticalReversed : .alphabetical
                }
            }
            
            Spacer()
            
            if (selectMineableCoinViewTab == .list) {
                HStack {
                    Text("Profit")
                        .fontWeight((vm.mineablecoinSortOption == .profit || vm.mineablecoinSortOption == .profitReversed) ? .bold : .none)
                        .foregroundColor( (vm.mineablecoinSortOption == .profit || vm.mineablecoinSortOption == .profitReversed) ? Color.theme.accent : Color.theme.secondaryText )
                    Image(systemName: "chevron.down")
                        .opacity( (vm.mineablecoinSortOption == .profit || vm.mineablecoinSortOption == .profitReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.mineablecoinSortOption == .profit ? 0 : 180.0))
                }
                .onTapGesture {
                    withAnimation (.default) {
                        vm.mineablecoinSortOption = (vm.mineablecoinSortOption == .profit) ? .profitReversed : .profit
                    }
                }
            } else {
                HStack {
                    Text("Algorithm")
                        .fontWeight((vm.mineablecoinSortOption == .algorithm || vm.mineablecoinSortOption == .algorithmReversed) ? .bold : .none)
                        .foregroundColor( (vm.mineablecoinSortOption == .algorithm || vm.mineablecoinSortOption == .algorithmReversed) ? Color.theme.accent : Color.theme.secondaryText )
                    Image(systemName: "chevron.down")
                        .opacity( (vm.mineablecoinSortOption == .algorithm || vm.mineablecoinSortOption == .algorithmReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.mineablecoinSortOption == .algorithm ? 0 : 180.0))
                }
                .onTapGesture {
                    withAnimation (.default) {
                        vm.mineablecoinSortOption = (vm.mineablecoinSortOption == .algorithm) ? .algorithmReversed : .algorithm
                    }
                }                
            }
            
            HStack {
                Text("Price")
                    .fontWeight((vm.mineablecoinSortOption == .price || vm.mineablecoinSortOption == .priceReversed) ? .bold : .none)
                    .foregroundColor( (vm.mineablecoinSortOption == .price || vm.mineablecoinSortOption == .priceReversed) ? Color.theme.accent : Color.theme.secondaryText )
                Image(systemName: "chevron.down")
                    .opacity( (vm.mineablecoinSortOption == .price || vm.mineablecoinSortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.mineablecoinSortOption == .price ? 0 : 180.0))
            }
            .frame(width: UIScreen.main.bounds.width/4, alignment: .trailing)
            .onTapGesture {
                withAnimation (.default) {
                    vm.mineablecoinSortOption = (vm.mineablecoinSortOption == .price) ? .priceReversed : .price
                }
            }

        }
        .font (.caption)
        .foregroundColor(Color.theme.secondaryText)
        .lineLimit(1)
        .minimumScaleFactor(0.1)
    }
    
    
    // MARK: View 2 - 3.1 All Mineable Coins List
    private var mineableCoinAllView: some View {
        VStack{
            List {
                ForEach(vm.allMineableCoins) { coin in
                    MineableCoinRowView(coin: coin, showYourReward: false)
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                        .listRowBackground(Color.clear)
                        .onTapGesture {
                            seguemineable(mineableCoin: coin)
                        }
                }
            }
            .listStyle(PlainListStyle())
            .refreshable {
                let secondSinceLastRefresh = Double(Date() - vm.lastRefresh)/60.0
                if (secondSinceLastRefresh > minimumRefreshMinute) {
                    vm.reloadAllData()
                }
            }
        }
    }
    
    // MARK: View 2 - 3.2 Currently Mining Coins List
    private var mineableCoinCurrentView: some View {
        VStack{
            List {
                ForEach(vm.currentMiningCoins) { coin in
                    MineableCoinRowView(coin: coin, showYourReward: true)
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                        .listRowBackground(Color.clear)
                        .onTapGesture {
                            seguemineable(mineableCoin: coin)
                        }
                }
            }
            .listStyle(PlainListStyle())
            .refreshable {
                let secondSinceLastRefresh = Double(Date() - vm.lastRefresh)/60.0
                if (secondSinceLastRefresh > minimumRefreshMinute) {
                    vm.reloadAllData()
                }
            }
        }
    }
    
    // MARK: View 3 - User Hardware View
    private var userHardwareView: some View {
        NavigationView {
            ZStack {
                if (colorScheme == .light) {
                    LightBackgroundView()
                        .ignoresSafeArea(.all, edges: [.top, .trailing])
                } else {
                    DarkBackgroundView()
                        .ignoresSafeArea(.all, edges: [.top, .trailing])
                }
                VStack {
                    hardwareViewHeader
                    userhardwareOverView
                    userHardwareListView

                }
                .navigationBarHidden(true)
                .background(
                    NavigationLink(destination: HardwareDetailLoadingView(hardware: $selectedHardware),
                                   isActive: $showHardwareDetailView,
                                   label: { EmptyView() } )
                )
            }
        }
    }
    
    // MARK: View 3 - 1 Hardware View Header
    private var hardwareViewHeader: some View {
        HStack {
            CircleButtonView(iconName: "plus")
                .transaction { transaction in
                    transaction.animation = nil
                }
                .onTapGesture {
                    //print ("Edit hardware list")
                    showHardwareEditView.toggle()
                }
            Spacer()
            if !showHardwareSearchBar {
                Text("My Equipments")
                    .font(.headline)
                    .bold()
            }
            
            HStack (spacing: 0) {
                SearchBarView(searchText: $vm.searchHardwareText)
                    .opacity(showHardwareSearchBar ? 1.0 : 0)
                Button {
                    withAnimation {
                        showHardwareSearchBar.toggle()
                        UIApplication.shared.endEditing()
                    }
                } label: {
                    CircleButtonView(iconName: showHardwareSearchBar ? "xmark" : "magnifyingglass")
                }
            }
        }
        .frame(height: 55)
    }
    
    // MARK: View 3 - 2 Hardware Overall View
    private var userhardwareOverView: some View {
        VStack {
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
            .padding()
        }
        .background(
            VisualEffectBlurView(blurStyle: .systemUltraThinMaterial)
                .cornerRadius(10)
        )
        .overlay(RoundedRectangle(cornerRadius: 10,style: .continuous).stroke(lineWidth: 1).fill(Color.theme.background))
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
        .padding()
    }
    
    // MARK: View 3 - 3 User Hardware List
    private var userHardwareListView: some View {
        VStack{
            List {
                ForEach(vm.userHardwares) { hardware in
                    UserHardwareCardView(hardware: hardware)
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive, action: {
                                print ("you are swiping \(hardware.name)")
                                userHardwaretoDelete = hardware
                                //vm.deleteHardwareList(hardware: hardware)
                                showDeleteUserHardwareConfirmation = true})
                            {
                                Label("Remove", systemImage: "trash")
                            }
                        }
                        .onTapGesture {
                            seguehardware(hardware: hardware)
                        }
                    }
                .listRowBackground(Color.clear)
            }
            .listStyle(PlainListStyle())
            .confirmationDialog("",
                isPresented: $showDeleteUserHardwareConfirmation) {
                Button("Delete this item.", role: .destructive) {
                    if let hardware = userHardwaretoDelete {
                        withAnimation {
                            vm.deleteHardwareList(hardware: hardware)
                        }
                    }
                }
            }
        }
    }
    
    
    private func segue(coin: CoinModel) {
        //print ("Link to detail view for coin: \(coin.name)")
        selectedCoin = coin
        showCoinDetailView.toggle()
    }
    
    private func seguemineable(mineableCoin: MineableCoinModel) {
        //print ("Link to detail view for coin: \(coin.name)")
        selectedMineableCoin = mineableCoin
        showMineableCoinDetailView.toggle()
    }
    
    private func seguehardware(hardware: Hardware) {
        //print ("Link to detail view for coin: \(coin.name)")
        selectedHardware = hardware
        showHardwareDetailView.toggle()
    }
    
}
