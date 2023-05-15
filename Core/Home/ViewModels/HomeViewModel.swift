//
//  HomeViewModel.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/27/22.
//

import Foundation
import Combine
import SwiftUI


class HomeViewModel: ObservableObject {
    
    let timer = Timer.publish(every: 1.0, tolerance: 0.1, on: .main, in: .common).autoconnect()
 
    @Published var isLoading: Bool = false
    @Published var lastRefresh: Date = Date()
    
    // MARK: Subscribe variables
    
    //@Published var electricityRate: Double = 0.1
    @AppStorage("refreshRateInt") var refreshRate: Int = 2
    
    // MARK: Apple Storage
    @AppStorage("electricityRate") var electricityRateAS: Double = 0.1
    @AppStorage("refreshRate") var refreshRateAS: AutoRefreshOption = AutoRefreshOption.two
    
    // MARK: Market Coins and watch list coins
    @Published var allCoins: [CoinModel] = []
    @Published var watchlistCoins: [CoinModel] = []
    @Published var restCoins: [CoinModel] = []
    @Published var searchCoinText: String = ""
    @Published var coinSortOption: CoinSortOption = .holding
    
    @Published var statistics: [StatisticModel] = [
        StatisticModel(title: "Market Cap", value: "$10.5Bn", percentageChange: 13.2)
    ]
    
    // MARK: Mineable Coins and my mining coins
    @Published var allMineableCoins: [MineableCoinModel] = []
    @Published var currentMiningCoins: [MineableCoinModel] = []
    @Published var top5currentMiningCoins: [Top5CurrentMiningCoin] = []
    @Published var extraCoins: [ExtraCoinModel] = []
    @Published var top5CoinsMarketCap: [Top5CoinMarket] = []
    @Published var whattomineCoins: [String: WhattominCoinModel] = [:]
    @Published var searchMineableCoinText: String = ""
    @Published var mineablecoinSortOption: MineableCoinSortOption = .profit
    
    @Published var miningstatistics: [MiningStatisticModel] = [
        MiningStatisticModel(title: "Mining Coins:", value: 2)
    ]
    
    // MARK: Hardware Data and User Hardwares
    @Published var allHardwares: [Hardware] = []
    @Published var allGPUs: [Hardware] = []
    @Published var allASICs: [Hardware] = []
    @Published var userHardwares: [Hardware] = []
    @Published var userGPUs: [Hardware] = []
    @Published var userASICs: [Hardware] = []
    @Published var searchHardwareText: String = ""
    
    @Published var hardwarestatistics: [HardwareStatisticModel] = [
        HardwareStatisticModel(title: "Nvidia GPU", value: 3)
    ]
    
    // MARK: Data Service for Coin Market View
    private let coindataService = CoinDataService()
    private let marketdataService = MarketDataService()
    private let watchlistcoindataService = WatchlistCoinDataService()
    
    // MARK: Data Service for Mineable Coins
    private let mineablecoindataService = MineableCoinDataService()
    private let extracoindataService = ExtraCoinDataService()
    private let whattominecoindataService = WhattomineCoinDataService()
    
    // MARK: Data Service for Hardwares
    private let hardwaredataService = HardwareDataService()
    private let userhardwaredataService = UserHardwareDataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Sort option
    enum CoinSortOption {
        case rank, rankReversed, holding, holdingReversed, price, priceReversed, alphabetical, alphabeticalReversed
    }
    enum MineableCoinSortOption {
        case rank, rankReversed, profit, profitReversed, price, priceReversed, alphabetical, alphabeticalReversed, algorithm, algorithmReversed
    }
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
        
        // update crypto coins data
        $searchCoinText
            .combineLatest(coindataService.$allCoins, $coinSortOption)
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .map(filterandsortCoins)
            .sink { [weak self] returnCoins in
                self?.allCoins = returnCoins
            }
            .store(in: &cancellables)
        
        // update watchlist and rest coins
        $allCoins
            .combineLatest(watchlistcoindataService.$savedEntities)
            .map(mapallCoins2watchlistCoins)
            .sink { [weak self] returnArray in
                guard let self = self else { return }
                self.watchlistCoins = self.sortWatchListCoinsIfNeeded(coins: returnArray.watchlistcoins)
                self.restCoins = returnArray.restcoins
            }
            .store(in: &cancellables)
        
        
        // update market data
        marketdataService.$marketData
            .combineLatest($watchlistCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedArray in
                self?.statistics = returnedArray.stats
                self?.top5CoinsMarketCap = returnedArray.top5Coins
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        // update extra coins
        extracoindataService.$extraCoins
            .sink { [weak self] returnCoins in
                self?.extraCoins = returnCoins
            }
            .store(in: &cancellables)
        
        // update whattomine coins
        whattominecoindataService.$whattomineCoins
            .sink { [weak self] returnCoins in
                self?.whattomineCoins = returnCoins
            }
            .store(in: &cancellables)
        
        // update hardware information and split them into [GPU/ASIC GPU--> AMD/NVDA]
        $searchHardwareText
            .combineLatest(hardwaredataService.$allHardwareData, $allMineableCoins)
            .map(updateHardwareProfit)
            .sink { [weak self] returnHardware in
                self?.allHardwares = returnHardware
                self?.allGPUs = returnHardware.filter{ $0.type.lowercased() == "gpu" }
                self?.allASICs = returnHardware.filter{ $0.type.lowercased() == "asic" }
                //print (returnHardware)
            }
            .store(in: &cancellables)
        
//        userhardwaredataService.$savedEntities
//            .combineLatest(self.$allHardwares)
//            .map(mapAllHardwareToWatchlistHardware)
//            .sink { [weak self] returnHardware in
////                print ("-----------Start----------")
////                for index in returnHardware.indices {
////                    print (returnHardware[index].name, returnHardware[index].myQuantity!, returnHardware[index].myCoin?.name!)
////                }
////                print ("-----------End----------")
//                self?.userHardwares = returnHardware
//                self?.userGPUs = returnHardware.filter{$0.type.lowercased() == "gpu"}
//                self?.userASICs = returnHardware.filter{ $0.type.lowercased() == "asic" }
//            }
//            .store(in: &cancellables)
        
        userhardwaredataService.$savedEntities
            .combineLatest(self.$allHardwares)
            .map(mapAllHardwareToWatchlistHardware_v2)
            .sink { [weak self] returnArray in
                self?.userHardwares = returnArray.returnhardware
                self?.userGPUs = returnArray.returnhardware.filter{$0.type.lowercased() == "gpu"}
                self?.userASICs = returnArray.returnhardware.filter{ $0.type.lowercased() == "asic" }
                self?.hardwarestatistics = returnArray.hardwareStats
            }
            .store(in: &cancellables)
        
        // update searchMiningCoinText
        $searchMineableCoinText
            .combineLatest(mineablecoindataService.$allMineableCoins, $extraCoins, $whattomineCoins)
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .map(filterMineableCoins_bysearch)
            .sink { [weak self] returnCoins in
                guard let self = self else { return }
                //var updateCoins = returnCoins
                self.allMineableCoins = returnCoins
                self.currentMiningCoins = returnCoins.filter { $0.my_dailyreward ?? 0 > 0 }
            }
            .store(in: &cancellables)
        
        $mineablecoinSortOption
            .combineLatest($allMineableCoins, $currentMiningCoins)
            .map(mapsortMineableCoins)
            .sink { [weak self] returnArray in
                self?.allMineableCoins = returnArray.sortedallcoins
                self?.currentMiningCoins = returnArray.sortedcurrentcoins
            }
            .store(in: &cancellables)
        
//        // TEST ONLY, maybe works need more tests
        $userHardwares
            .combineLatest($allMineableCoins)
            .map(update_coinreward)
            .sink { [weak self] returnArray in
                self?.allMineableCoins = returnArray.mineablecoins
                self?.miningstatistics = returnArray.stats
                guard let self = self else { return }
                //sort returncurrentcoins if needed
                self.currentMiningCoins = self.sortCurrentMiningCoinsIfNeeded(coins: returnArray.mineablecoins.filter{ $0.my_dailyreward ?? 0 > 0 })
                if (self.currentMiningCoins.isEmpty) {
                    self.top5currentMiningCoins = []
                } else if ( self.currentMiningCoins.count > 0) {
                    self.top5currentMiningCoins = []
                    let sortedcurrentMiningCoins = self.currentMiningCoins.sorted{ $0.my_dailyprofit ?? 0 > $1.my_dailyprofit ?? 0 }
                    let daily_profits = sortedcurrentMiningCoins.map {$0.my_dailyprofit ?? 0}
                    if ( self.currentMiningCoins.count <= 5 ) {
                        for coin in sortedcurrentMiningCoins {
                            let miningcoin = Top5CurrentMiningCoin(coinname: coin.symbol.uppercased(), dailyprofit: coin.my_dailyprofit ?? 0)
                            self.top5currentMiningCoins.append(miningcoin)
                        }
                    } else if ( self.currentMiningCoins.count > 5 ) {
                        for coin in sortedcurrentMiningCoins[0..<5] {
                            let miningcoin = Top5CurrentMiningCoin(coinname: coin.symbol.uppercased(), dailyprofit: coin.my_dailyprofit ?? 0)
                            self.top5currentMiningCoins.append(miningcoin)
                        }
                        let restProfit = daily_profits.reduce(5, +)
                        let miningcoin = Top5CurrentMiningCoin(coinname: "Other", dailyprofit: restProfit)
                        self.top5currentMiningCoins.append(miningcoin)
                    }
                }
            }
            .store(in: &cancellables)
        
        // Update Mineable Ranks
        $allCoins
            .combineLatest($allMineableCoins)
            .map(updateMineableCoinsRank)
            .sink { [weak self] returnCoins in
                self?.allMineableCoins = returnCoins
            }
            .store(in: &cancellables)
    }
    
    // MARK: sort mineable coins
    private func mapsortMineableCoins (sort: MineableCoinSortOption, allcoins: [MineableCoinModel], currentcoins: [MineableCoinModel]) ->
    ( sortedallcoins: [MineableCoinModel], sortedcurrentcoins: [MineableCoinModel] ) {
        var updatedallcoins = allcoins
        sortMineableCoins(sort: sort, coins: &updatedallcoins)
        return (updatedallcoins,updatedallcoins.filter{ $0.my_dailyreward ?? 0 > 0 } )
    }
    
    private func sortMineableCoins(sort: MineableCoinSortOption, coins: inout [MineableCoinModel]) {
        switch sort {
        case .rank:
            coins.sort(by: { $0.coinrank ?? 100000 < $1.coinrank ?? 100000 } )
        case .rankReversed:
            coins.sort(by: { $0.coinrank ?? 100000 > $1.coinrank ?? 100000 } )
        case .price:
            coins.sort(by: { $0.price > $1.price } )
        case .priceReversed:
            coins.sort(by: { $0.price < $1.price } )
        case .alphabetical:
            coins.sort(by: { $0.symbol.uppercased() < $1.symbol.uppercased() } )
        case .alphabeticalReversed:
            coins.sort(by: { $0.symbol.uppercased() > $1.symbol.uppercased() } )
        case .profit:
            coins.sort(by: { $0.my_dailyprofit ?? -9999999999 > $1.my_dailyprofit ?? -9999999999 } )
        case .profitReversed:
            coins.sort(by: { $0.my_dailyprofit ?? -9999999999 < $1.my_dailyprofit ?? -9999999999 } )
        case .algorithm:
            coins.sort(by: { $0.algorithm?.uppercased() ?? "N/A" < $1.algorithm?.uppercased() ?? "N/A" } )
        case .algorithmReversed:
            coins.sort(by: { $0.algorithm?.uppercased() ?? "N/A" > $1.algorithm?.uppercased() ?? "N/A" } )
        }
    }
    
    private func sortCurrentMiningCoinsIfNeeded(coins: [MineableCoinModel]) -> [MineableCoinModel] {
        // will only sorted by holdings or reversedholdings if needed
        switch mineablecoinSortOption {
            case .profit:
            return coins.sorted { $0.my_dailyprofit ?? -9999999999 > $1.my_dailyprofit ?? -9999999999 }
            case .profitReversed:
                return coins.sorted { $0.my_dailyprofit ?? -9999999999 < $1.my_dailyprofit ?? -9999999999 }
            default:
                return coins
        }
    }
    
    
    // MARK: mapping functions
    private func filterandsortCoins(text: String, coins: [CoinModel], sort: CoinSortOption) -> [CoinModel] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &updatedCoins)
        return updatedCoins
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        let lowercasedText = text.lowercased()
        return coins.filter { coin -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
                    coin.symbol.lowercased().contains(lowercasedText) ||
                    coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func sortCoins(sort: CoinSortOption, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .holding:
            coins.sort(by: { $0.rank < $1.rank } )
        case .rankReversed, .holdingReversed:
            coins.sort(by: { $0.rank > $1.rank } )
        case .price:
            coins.sort(by: { $0.current_price > $1.current_price } )
        case .priceReversed:
            coins.sort(by: { $0.current_price < $1.current_price } )
        case .alphabetical:
            coins.sort(by: { $0.symbol.uppercased() < $1.symbol.uppercased() } )
        case .alphabeticalReversed:
            coins.sort(by: { $0.symbol.uppercased() > $1.symbol.uppercased() } )
        }
    }
    
    private func sortWatchListCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        
        // will only sorted by holdings or reversedholdings if needed
        switch coinSortOption {
        case .holding:
            return coins.sorted { $0.currentHoldingsValues > $1.currentHoldingsValues }
        case .holdingReversed:
            return coins.sorted { $0.currentHoldingsValues < $1.currentHoldingsValues }
        default:
            return coins
        }
    }
    
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?,
                                        watchListCoins: [CoinModel]) -> (stats: [StatisticModel], top5Coins: [Top5CoinMarket]) {
        
        var stats: [StatisticModel] = []
        var top5Coins: [Top5CoinMarket] = []
        
        guard let data = marketDataModel else {return (stats, top5Coins)}
                
        let marketCap = StatisticModel(title: "Market Cap",
                                       value: data.marketCap,
                                       percentageChange: data.market_cap_change_percentage_24h_usd)
        stats.append(marketCap)
        
        let marketVolume = StatisticModel(title: "24h Volume", value: data.volume)
        stats.append(marketVolume)
        
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        stats.append(btcDominance)
        
        let portfolioValue =
            watchListCoins
                .map( { $0.currentHoldingsValues } )
                .reduce(0, +)
        
        let portfolio = StatisticModel(title: "Portfolio", value: portfolioValue.asCurrencyWith2Decimals())
        stats.append(portfolio)
        
        let sortedCoins = marketDataModel?.market_cap_percentage.sorted(by: {$0.value > $1.value} )
        let marketCapUSD = marketDataModel?.marketCapDouble ?? 0
        
        if (sortedCoins?.count ?? 0 >= 5) {
            
            let coin1 = Top5CoinMarket(coinname: sortedCoins?[0].key.uppercased() ?? "N/A", marketcap: (sortedCoins?[0].value ?? 0.0) * marketCapUSD * 0.01)
            let coin2 = Top5CoinMarket(coinname: sortedCoins?[1].key.uppercased() ?? "N/A", marketcap: (sortedCoins?[1].value ?? 0.0) * marketCapUSD * 0.01)
            let coin3 = Top5CoinMarket(coinname: sortedCoins?[2].key.uppercased() ?? "N/A", marketcap: (sortedCoins?[2].value ?? 0.0) * marketCapUSD * 0.01)
            let coin4 = Top5CoinMarket(coinname: sortedCoins?[3].key.uppercased() ?? "N/A", marketcap: (sortedCoins?[3].value ?? 0.0) * marketCapUSD * 0.01)
            let coin5 = Top5CoinMarket(coinname: sortedCoins?[4].key.uppercased() ?? "N/A", marketcap: (sortedCoins?[4].value ?? 0.0) * marketCapUSD * 0.01)

            let rest_perc =
                100.0 - (sortedCoins?[0].value ?? 0.0) - (sortedCoins?[1].value ?? 0.0) -
                (sortedCoins?[2].value ?? 0.0) - (sortedCoins?[3].value ?? 0.0) - (sortedCoins?[3].value ?? 0.0)
            
            let coinrest = Top5CoinMarket(coinname: "Other", marketcap: rest_perc * marketCapUSD * 0.01)
            top5Coins.append(coin1)
            top5Coins.append(coin2)
            top5Coins.append(coin3)
            top5Coins.append(coin4)
            top5Coins.append(coin5)
            top5Coins.append(coinrest)
        }
        
        return (stats, top5Coins)
    }
    
    
    private func updateMineableCoinsRank( allcoins: [CoinModel], mineablecoins: [MineableCoinModel] ) -> [MineableCoinModel] {
        
        if !mineablecoins.isEmpty {
            var returncoins = mineablecoins
            for index in returncoins.indices {
                let current_id = returncoins[index].coinid
                let coin = allcoins.filter { $0.id == current_id }
                if (coin.count >= 1) {
                    returncoins[index].coinrank = coin[0].rank
                    //print (coin[0].name, returncoins[index].coinrank ?? -1)
                }
            }
            return returncoins
        }
        return mineablecoins
    }

    private func filterMineableCoins_bysearch(text: String,
                                              mineableCoins: [MineableCoinModel],
                                              extraCoins: [ExtraCoinModel],
                                              whattomineCoins: [String: WhattominCoinModel]) -> [MineableCoinModel] {
        if mineableCoins.isEmpty {
            return []
        } else {
            var filteredStatus = mineableCoins.filter { mineableCoin -> Bool in
                return mineableCoin.type == .coin &&
                mineableCoin.networkHashrate >= 0 &&
                mineableCoin.price >= 0 &&
                mineableCoin.difficultyasdouble > 0 &&
                mineableCoin.reward >= 0
            }
            
            for index in filteredStatus.indices {
                let current_symbol = filteredStatus[index].symbol.lowercased()
                let coin = extraCoins.filter { $0.symbol == current_symbol }
                if (coin.count >= 1) {
                    //update coin image
                    filteredStatus[index].image = coin[0].image
                    filteredStatus[index].coinid = coin[0].id
                }
            }
            let uniqueStatus = removeDuplicated_Coins(allmineableCoins: filteredStatus)
            
            // remove coins that are not from the what to mine web
            var final_selection: [MineableCoinModel] = []
            
            for coin in uniqueStatus {
                let find_coin = whattomineCoins.first { key, value in
                    value.tag.lowercased() == coin.symbol.lowercased()
                }
                if (find_coin == nil) {continue}
                var add_coin = coin
                add_coin.wtm_nethash = find_coin?.value.nethash
                add_coin.wtm_blocktime = find_coin?.value.blocktimeasDouble
                //print (add_coin.wtm_blocktime, find_coin?.value.block_time)
                add_coin.wtm_lastblock = find_coin?.value.last_block
                add_coin.wtm_timestamp = find_coin?.value.timestamp
                add_coin.wtm_difficultynow = find_coin?.value.difficulty
                add_coin.wtm_difficulty24 = find_coin?.value.difficulty24
                add_coin.wtm_market_cap = find_coin?.value.market_cap
                add_coin.wtm_blockreward = find_coin?.value.block_reward
                add_coin.wtm_blockreward24 = find_coin?.value.block_reward24
                
                final_selection.append(add_coin)
            }
            
            guard !text.isEmpty else {
                return final_selection
            }
            
            let lowercasedText = text.lowercased()
            return final_selection.filter { coin -> Bool in
                return coin.name.lowercased().contains(lowercasedText) ||
                        coin.symbol.lowercased().contains(lowercasedText)
            }
            
        }
    }
    
    private func removeDuplicated_Coins(allmineableCoins: [MineableCoinModel]) -> [MineableCoinModel] {
        var uniqmineableCoin: [MineableCoinModel] = []
        for coin in allmineableCoins {
            if !uniqmineableCoin.contains(where: {$0.symbol == coin.symbol }) {
                uniqmineableCoin.append(coin)
            }
        }
        return uniqmineableCoin
    }
    
    private func mapallCoins2watchlistCoins(allCoins: [CoinModel], watchlistEntities: [WatchListEntity]) ->
        (watchlistcoins : [CoinModel], restcoins:[CoinModel]) {
        let watchcoins = allCoins
            .compactMap { coin -> CoinModel? in
                guard let entity = watchlistEntities.first(where: { $0.coinID == coin.id }) else {
                    return nil
                }
                return coin.updateWatchList(amount: entity.coinAmount)
            }
        var restcoins = allCoins
        if (!watchcoins.isEmpty) {
            for coin in watchcoins {
                restcoins.removeAll {$0.symbol == coin.symbol}
            }
        }
        return (watchcoins, restcoins)
    }
    
    
    func updateWatchlist(coin: CoinModel, amount: Double) {
        //print ("now update watch list coin amount:", amount)
        watchlistcoindataService.updateWatchList(coin: coin, amount: amount)
    }
    
    func updateWatchlist_noamount(coin: CoinModel) {
        //print ("now update watch list coin amount:", amount)
        watchlistcoindataService.updateWatchList_noamount(coin: coin)
    }
    
    func deleteWatchlistCoin(coin: CoinModel) {
        watchlistcoindataService.removeCoinFromWatchList(coin: coin)
        reloadData()
    }
    
    func reloadData() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
            self.coindataService.getCoins()
            self.marketdataService.getMarketData()
            //HapticManager.notification(type: .success)
        }
        self.lastRefresh = Date()
    }
    
    func reloadAllData() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
            self.coindataService.getCoins()
            self.marketdataService.getMarketData()
            self.hardwaredataService.getHardwareData()
            //HapticManager.notification(type: .success)
        }
        self.lastRefresh = Date()
    }
    
    
    private func updateHardwareProfit(text: String, hardwares: [Hardware], mineablecoins: [MineableCoinModel]) -> [Hardware] {
        //print ("I'm here")
        //print (hardwares.isEmpty, mineablecoins.isEmpty)
        if hardwares.isEmpty || mineablecoins.isEmpty {
            return []
        }
        
        
        var hardwares_return: [Hardware] = []
        for hardware in hardwares {
            var hardware_copy = hardware
            
            hardware_copy.support_coins = []
            hardware_copy.support_coins_details = []
            
            //print (hardware_copy.name)
            for (key, value) in hardware_copy.algorithms ?? [:] {

                let find_coins = mineablecoins.filter { $0.algorithm?.lowercased() == key.lowercased() }
                                
                for find_coin in find_coins {
                    
                    hardware_copy.support_coins?.append(find_coin)
                    let price = find_coin.price
                    let nethash = find_coin.wtm_nethash ?? 1e20
                    let hash = value.speed
                    let power = value.power
                    let blocktime = find_coin.wtm_blocktime ?? 1e20
                    //let blockreward = find_coin?.wtm_blockreward ?? 0
                    let blockreward24 = find_coin.wtm_blockreward24 ?? 0
                    
                    let reward24_coin = (hash/nethash) * blockreward24 * (86400/blocktime)
                    let reward24_usd  = reward24_coin * price
                    let cost24_usd = self.electricityRateAS * Double(power) * 24 / 1000.0
                    let reward24_profit = reward24_usd - cost24_usd
                    
                    var details: SupportCoinDetail = SupportCoinDetail()
                    details.name = find_coin.name
                    details.symbol = find_coin.symbol
                    details.price = find_coin.price
                    details.yeild = reward24_coin
                    details.reward = reward24_usd
                    details.profit = reward24_profit
                    details.image = find_coin.image
                    details.algorithm = key.lowercased()
                    details.nethash = nethash
                    details.power = power
                    details.speed = hash
                    details.blocktime = blocktime
                    details.blockreward = blockreward24
                    hardware_copy.support_coins_details?.append(details)
                    
                }
            }
            if (hardware_copy.support_coins?.count ?? -1) >= 1 {
                hardware_copy.support_coins_details = hardware_copy.support_coins_details?.sorted(by: { $0.profit ?? 0 > $1.profit ?? 0 } )
                //print (hardware_copy.name, hardware_copy.specs?.memorySize, hardware_copy.specs?.maxMemorySize, hardware_copy.specs?.memorySizeVRAM)
                //print (hardware_copy.support_coins_details)
                hardwares_return.append(hardware_copy)
            }
        }
                
        guard !text.isEmpty else {
            return hardwares_return
        }
        
        let lowercasedText = text.lowercased()
        return hardwares_return.filter { hardware -> Bool in
            return hardware.name.lowercased().contains(lowercasedText)
        }
    }
    
    
    private func update_coinreward(myhardwares: [Hardware],
                                      coins: [MineableCoinModel]) -> (mineablecoins: [MineableCoinModel], stats: [MiningStatisticModel]) {

        var stats: [MiningStatisticModel] = []
        
        if myhardwares.isEmpty {
            return (coins, stats)
        } else {
            var coins_copy = coins
            for index in 0..<coins_copy.count {
                coins_copy[index].my_dailyprofit = 0
                coins_copy[index].my_dailyyeild = 0
                coins_copy[index].my_dailyreward = 0
                coins_copy[index].my_dailycost = 0
                coins_copy[index].my_dailyspeed = 0
            }
            
            for hardware in myhardwares {
                //print( hardware.myCoin?.profit )
                if ( hardware.myCoin?.profit != nil && hardware.myQuantity != nil) {
                    let coin_name = hardware.myCoin?.symbol?.lowercased() ?? ""
                    let ind = coins_copy.firstIndex{ $0.symbol.lowercased() == coin_name } ?? -1
                    if (ind < 0) {continue}
                    let quan = Double(hardware.myQuantity ?? 0)
                    let unit_yeild = Double(hardware.myCoin?.yeild ?? 0)
                    let unit_profit = Double(hardware.myCoin?.profit ?? 0)
                    let unit_reward = Double(hardware.myCoin?.reward ?? 0)
                    let unit_speed = Double(hardware.myCoin?.speed ?? 0)
                    let yeild = unit_yeild * quan
                    let profit = unit_profit * quan
                    let reward = unit_reward * quan
                    let speed = unit_speed * quan
                    let cost = profit - reward
                    
                    coins_copy[ind].my_dailyyeild = (coins_copy[ind ].my_dailyyeild ?? 0) + yeild
                    coins_copy[ind].my_dailyprofit = (coins_copy[ind ].my_dailyprofit ?? 0) + profit
                    coins_copy[ind].my_dailyreward = (coins_copy[ind ].my_dailyreward ?? 0) + reward
                    coins_copy[ind].my_dailyspeed = (coins_copy[ind ].my_dailyspeed ?? 0) + speed
                    coins_copy[ind].my_dailycost = (coins_copy[ind ].my_dailycost ?? 0) + cost
                }
            }
            
            let currentCoins = coins_copy.filter{ $0.my_dailyreward ?? 0 > 0 }
                                
            let currentMiningCoinModel = MiningStatisticModel(title: "Mining Coins",value: Double(currentCoins.count))
            stats.append(currentMiningCoinModel)
            
            let dailyProfit = currentCoins
                                .map( { $0.my_dailyprofit ?? 0} )
                                .reduce(0, +)
            let dailyProfitModel = MiningStatisticModel(title: "24h Profit", value: dailyProfit)
            stats.append(dailyProfitModel)
            
            let dailyReward = currentCoins
                                .map( { $0.my_dailyreward ?? 0} )
                                .reduce(0, +)
            let dailyRewardModel = MiningStatisticModel(title: "24h Reward", value: dailyReward)
            stats.append(dailyRewardModel)
            
            let dailyCost = currentCoins
                                .map( { $0.my_dailycost ?? 0} )
                                .reduce(0, +)
            let dailyCostModel = MiningStatisticModel(title: "24h Cost", value: dailyCost)
            stats.append(dailyCostModel)
            
            let power = dailyCost * (-1000.0) / electricityRateAS / 24.0
            let powerModel = MiningStatisticModel(title: "Power", value: power)
            stats.append(powerModel)
            
            //let erate = self.electricityRate
            let erate = self.electricityRateAS
            let erateModel = MiningStatisticModel(title: "Electricity Rate", value: erate)
            stats.append(erateModel)
            
            return (coins_copy, stats)
        }
        
    }
    
    
    private func mapAllHardwareToWatchlistHardware(watchlistEntities: [UserHardwareListEntity], allhardwares: [Hardware]) -> [Hardware] {

        var return_hardwares: [Hardware] = []

        for watchlistEntity in watchlistEntities {
            //print (watchlistEntity.hardware_name)
            let hardware = allhardwares.first { $0.name == watchlistEntity.hardware_name }
            if (hardware != nil) {
                var return_hardware = hardware
                let return_hardware_coin = return_hardware?.support_coins_details?.first{ $0.name == watchlistEntity.coin_name }
                return_hardware?.myCoin = return_hardware_coin
                return_hardware?.myQuantity = watchlistEntity.amount
                return_hardwares.append(return_hardware!)
            }
        }
        return return_hardwares
    }
    
    
    private func mapAllHardwareToWatchlistHardware_v2(watchlistEntities: [UserHardwareListEntity], allhardwares: [Hardware]) -> (returnhardware: [Hardware], hardwareStats: [HardwareStatisticModel]) {

        var return_hardwares: [Hardware] = []
        var hardware_stats: [HardwareStatisticModel] = []

        for watchlistEntity in watchlistEntities {
            //print (watchlistEntity.hardware_name)
            let hardware = allhardwares.first { $0.name == watchlistEntity.hardware_name }
            if (hardware != nil) {
                var return_hardware = hardware
                let return_hardware_coin = return_hardware?.support_coins_details?.first{ $0.name == watchlistEntity.coin_name }
                return_hardware?.myCoin = return_hardware_coin
                return_hardware?.myQuantity = watchlistEntity.amount
                return_hardwares.append(return_hardware!)
            }
        }
        
        var nvdaQuan = 0.0
        var amdQuan = 0.0
        var asicQuan = 0.0
        
        var nvdaPower = 0.0
        var amdPower = 0.0
        var asicPower = 0.0
        
        var totalProfit = 0.0
        var bestProfit = 0.0
        
        var bestPower = 0.0
        
        for gpu in return_hardwares {
            nvdaQuan = gpu.brand_short == "NVDA" ? nvdaQuan + Double(gpu.myQuantity ?? 0) : nvdaQuan
            amdQuan = gpu.brand_short == "AMD" ? amdQuan + Double(gpu.myQuantity ?? 0) : amdQuan
            asicQuan = gpu.brand_short == "ASIC" ? asicQuan + Double(gpu.myQuantity ?? 0) : asicQuan
            
            nvdaPower = gpu.brand_short == "NVDA" ? nvdaPower + (gpu.total_power ?? 0) : nvdaPower
            amdPower = gpu.brand_short == "AMD" ? amdPower + (gpu.total_power ?? 0) : amdPower
            asicPower = gpu.brand_short == "ASIC" ? asicPower + (gpu.total_power ?? 0) : asicPower
            
            totalProfit = totalProfit + (gpu.total_profit ?? 0)
            bestProfit = bestProfit + (gpu.bestCoin?.profit ?? 0) * Double(gpu.myQuantity ?? 0)
            
            bestPower = bestPower + Double((gpu.bestCoin?.power ?? 0)) * Double(gpu.myQuantity ?? 0)
        }
        let allPower = nvdaPower + amdPower + asicPower
        
        let userNVDAModel = HardwareStatisticModel(title: "Nvidia GPU", value: Double(nvdaQuan), note: nvdaPower)
        let userAMDModel = HardwareStatisticModel(title: "AMD GPU", value: Double(amdQuan), note: amdPower)
        let userASICModel = HardwareStatisticModel(title: "ASIC", value: Double(asicQuan), note: asicPower)
        
        let totalProfitModel = HardwareStatisticModel(title: "Current Strategy", value: totalProfit, note: allPower)
        let bestProfitModel = HardwareStatisticModel(title: "Best Strategy", value: bestProfit, note: bestPower)
        
        let totalQuan = Int(nvdaQuan + amdQuan + asicQuan)
        let efficiencyVal = totalQuan == 0 ? -9998 : (bestProfit > 0 ? totalProfit*100.0/bestProfit : -9999)
        
        //let efficiencyVal = bestProfit > 0 ? totalProfit*100.0/bestProfit : -9999
        let efficiencyModel = HardwareStatisticModel(title: "Overall Efficiency", value: efficiencyVal)
        
        hardware_stats.append(userNVDAModel)
        hardware_stats.append(userAMDModel)
        hardware_stats.append(userASICModel)
        hardware_stats.append(totalProfitModel)
        hardware_stats.append(bestProfitModel)
        hardware_stats.append(efficiencyModel)
        
        return (return_hardwares, hardware_stats)
    }
    
    func updateUserHardwareList(hardware: Hardware, amount: Int, coin: SupportCoinDetail) {
        userhardwaredataService.updateUserHardwareWatchList(hardware: hardware, coin: coin, amount: Int16(amount))
    }
    
    func deleteHardwareList(hardware: Hardware) {
        userhardwaredataService.removeUserHardware(hardware: hardware)
    }
    
}
