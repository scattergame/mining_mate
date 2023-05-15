//
//  DetailViewModel.swift
//  MiningMate
//
//  Created by Chenxi Wang on 8/28/22.
//

import Foundation
import Combine
import SwiftUI

class CoinDetailViewModel: ObservableObject {
    
    //@Published var coinDetails: CoinDetailModel = nil
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    
    @Published var coinDescription: String? = nil
    @Published var coinWebsite: String? = nil
    @Published var resourceLink: String? = nil
    
    @Published var coin: CoinModel
    private let coinDetailDataService : CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailDataService = CoinDetailDataService(coin:coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        
        coinDetailDataService.$coinDetail
            .combineLatest($coin)
            .map({ (coindetail, coin) -> (overview: [StatisticModel],
                                          additional: [StatisticModel],
                                          description: String,
                                          coinwebsite: String,
                                          resourcelink: String) in
                
                let price = coin.current_price.asCurrencyWith6Decimals()
                let price_change_percentage = coin.price_change_percentage_24h
                let price_stat = StatisticModel(title: "Price", value: price, percentageChange: price_change_percentage)
                
                let marketCap = "$" + (coin.market_cap?.formattedWithAbbreviations() ?? "N/A")
                let marketCap_change_percentage = coin.market_cap_change_percentage_24h
                let marketCap_stat = StatisticModel(title: "Market Cap", value: marketCap, percentageChange: marketCap_change_percentage)
                
                let rank = "\(coin.rank)"
                let rank_stat = StatisticModel(title: "Coin Rank", value: rank)
                
                let volume = "$" + (coin.total_volume?.formattedWithAbbreviations() ?? "N/A")
                let volume_stat = StatisticModel(title: "Volume", value: volume)
                
                let high = coin.high_24h?.asCurrencyWith6Decimals() ?? "N/A"
                let high_stat = StatisticModel(title: "24H High", value: high)
                
                let low = coin.low_24h?.asCurrencyWith6Decimals() ?? "N/A"
                let low_stat = StatisticModel(title: "24H Low", value: low)
                
                let overviewArray: [StatisticModel] = [
                    price_stat, marketCap_stat, rank_stat, volume_stat, high_stat, low_stat
                ]
                
                //additional
                
                let blocktime = coindetail?.blockTimeInMinutes ?? -1
                var blocktime_str = "N/A"
                if (blocktime>0) {
                    blocktime_str = "\(blocktime)"
                } else if (blocktime == 0) {
                    blocktime_str = "< 1"
                }
                
                let block_stat = StatisticModel(title: "Block Time (min)", value: blocktime_str)
                
                let hash_algorithm = coindetail?.hashingAlgorithm ?? "N/A"
                let hash_algorithm_stat = StatisticModel(title: "Algorithm", value: hash_algorithm)
                
                let additionalArray: [StatisticModel] = [block_stat, hash_algorithm_stat]
                
                return (overviewArray,
                        additionalArray,
                        coindetail?.description?.en ?? "N/A",
                        coindetail?.links?.homepage?.first ?? "N/A",
                        coindetail?.links?.subredditURL ?? "N/A")
                
            })
            .sink { [weak self] returnArrays in
                //print ("return details for coin \(returnDetails?.id)")
                //self?.coinDetails = returnDetails
                self?.overviewStatistics = returnArrays.overview
                self?.additionalStatistics = returnArrays.additional
                self?.coinDescription = returnArrays.description
                self?.coinWebsite = returnArrays.coinwebsite
                self?.resourceLink = returnArrays.resourcelink
            }
            .store(in: &cancellables)
    }
    
}
