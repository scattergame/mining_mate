//
//  MineableCoinDetailViewModel.swift
//  MiningMate
//
//  Created by Chenxi Wang on 8/29/22.
//

import Foundation
import Combine
import SwiftUI

class MineableCoinDetailViewModel: ObservableObject {
    
    @Published var mineableCoinDetailOverViewStatistics: [StatisticModel] = []
    @Published var mineableCoinDetailAdditionalStatistics: [StatisticModel] = []
    @Published var mineableCoinsparklinein7d: SparklineIn7D = SparklineIn7D(price: [])
    @Published var mineableCoinlastUpdated: String = ""
    @Published var mineableCoinDescription: String? = nil
    @Published var mineableCoinWebsite: String? = nil
    @Published var mineableCoinResourceLink: String? = nil
    //@Published var mineableCoinDetail: MineableCoinDetailModel = MineableCoinDetailModel(id: nil, symbol: nil, name: nil, description: nil, links: nil, market_data: nil)
    
    @Published var mineableCoin: MineableCoinModel
    private let mineableCoinDetailDataService : MineableCoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(mineableCoin: MineableCoinModel) {
        self.mineableCoin = mineableCoin
        self.mineableCoinDetailDataService = MineableCoinDetailDataService(mineableCoin: mineableCoin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        mineableCoinDetailDataService.$mineableCoinDetail
            .combineLatest($mineableCoin)
            .map({ (mineablecoindetail, mineablecoin) -> (
                overview: [StatisticModel],
                additional: [StatisticModel],
                sparklinedata: SparklineIn7D,
                lastUpdated: String,
                description: String,
                coinwebsite: String,
                resourcelink: String) in
                
                //let price = mineablecoindetail?.market_data?.current_price
                //let overviewarray: [StatisticModel] = []
        
                // Use for Price GraphChart
                let sparkline = mineablecoindetail?.market_data?.sparkline_7d ?? SparklineIn7D(price: [])
                let lastUpdated = mineablecoindetail?.market_data?.last_updated ?? "N/A"
                
                // Overall Statistics
                // Price
                let priceUSD = mineablecoindetail?.market_data?.current_price?["usd"]?.asCurrencyWithFlexDecimals()
                let priceChangePercentage = mineablecoindetail?.market_data?.price_change_percentage_24h
                let priceStat = StatisticModel(title: "Price", value: priceUSD ?? "N/A", percentageChange: priceChangePercentage)
                    
                // Market Cap
                let marketCap = mineablecoindetail?.market_data?.market_cap?["usd"]?.formattedWithAbbreviations()
                let marketCapChangePercentage = mineablecoindetail?.market_data?.market_cap_change_percentage_24h
                let marketCapStat = StatisticModel(title: "Market Cap", value: marketCap ?? "N/A", percentageChange: marketCapChangePercentage)
                    
                // Rank
                let rank = Double(mineablecoindetail?.market_data?.market_cap_rank ?? 0).asNumberWith0Decimals()
                let rankStat = StatisticModel(title: "Rank", value: rank == "0" ? "N/A" : rank)
                    
                // 24h Low/High
                let price24Low = mineablecoindetail?.market_data?.low_24h?["usd"]?.asCurrencyWithFlexDecimals()
                let price24Hig = mineablecoindetail?.market_data?.high_24h?["usd"]?.asCurrencyWithFlexDecimals()
                let price24HigStat = StatisticModel(title: "24H High", value: price24Hig ?? "N/A")
                let price24LowStat = StatisticModel(title: "24H Low", value: price24Low ?? "N/A")
                    
                // Volumn
                let volume = mineablecoindetail?.market_data?.total_volume?["usd"]?.formattedWithAbbreviations()
                let volumeStat = StatisticModel(title: "Volume", value: volume ?? "N/A")
                    
                let overviewarray: [StatisticModel] = [priceStat, marketCapStat, rankStat,
                                                        price24HigStat, price24LowStat, volumeStat]
                
                // Additional Statistics
                
                // Algorithm
                let algorithm = mineablecoin.algorithm ?? "N/A"
                let algorithmStat = StatisticModel(title: "Algorithm", value: algorithm)
                
                // Network Difficulty
                let difficulty = mineablecoin.wtm_difficulty24?.formattedWithAbbreviations()
                let difficultyStat = StatisticModel(title: "Difficulty (24H)", value: difficulty ?? "N/A")
                
                // Network Hash
                let hashrate = mineablecoin.networkHashrate.formattedWithHashrate()
                let hashrateStat = StatisticModel(title: "Network Hash (24H)", value: hashrate )
                
                // BlockTime
                let blockTime = mineablecoin.wtm_blocktime?.asNumberWith6Decimals()
                let blockTimeStat = StatisticModel(title: "Block Time (s)", value: blockTime ?? "N/A")
                
                // BlockReward
                let blockReward = mineablecoin.wtm_blockreward24?.asNumberWith6Decimals()
                let blockRewardStat = StatisticModel(title: "Block Reward (24H)", value: blockReward ?? "N/A")
                
                // Last Block
                let lastBlock = mineablecoin.wtm_lastblock ?? -1
                let lastBlockStat = StatisticModel(title: "Last Block", value: lastBlock>0 ? Double(lastBlock).asNumberWith0Decimals() : "N/A")
                
                let additionalarray: [StatisticModel] = [algorithmStat, difficultyStat, hashrateStat,
                                                         blockTimeStat, blockRewardStat, lastBlockStat]
                
                                
                return ( overviewarray, additionalarray, sparkline, lastUpdated,
                         mineablecoindetail?.description?.en ?? "N/A",
                         mineablecoindetail?.links?.homepage?.first ?? "N/A",
                         mineablecoindetail?.links?.subredditURL ?? "N/A")
            })
            .sink { [weak self] returnarray in
                self?.mineableCoinsparklinein7d = returnarray.sparklinedata
                self?.mineableCoinDetailOverViewStatistics = returnarray.overview
                self?.mineableCoinDetailAdditionalStatistics = returnarray.additional
                self?.mineableCoinlastUpdated = returnarray.lastUpdated
                self?.mineableCoinDescription = returnarray.description
                self?.mineableCoinWebsite = returnarray.coinwebsite
                self?.mineableCoinResourceLink = returnarray.resourcelink
            }
            .store(in: &cancellables)

    }
    
}
