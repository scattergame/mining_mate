//
//  CoinModel.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/27/22.
//

import Foundation

// CoinGecko API
/*
 URL :
 https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&sparkline=true&price_change_percentage=24h
 */

struct CoinModel: Identifiable, Codable {
    let id, symbol, name: String
    var image: String
    let current_price: Double
    let market_cap, market_cap_rank, fully_diluted_valuation: Double?
    let total_volume, high_24h, low_24h: Double?
    let price_change_24h, price_change_percentage_24h: Double?
    let market_cap_change_24h, market_cap_change_percentage_24h: Double?
    let circulating_supply, total_supply, ath: Double?
    let ath_change_percentage: Double?
    let ath_date: String?
    let atl, atl_change_percentage: Double?
    let atl_date: String?
    let last_updated: String?
    let sparkline_in_7d: SparklineIn7D?
    let price_change_percentage_24h_in_currency: Double?
    let currentHolding: Double?
    var in_watchlist: Bool?
    
    var rank: Int {
        return Int(market_cap_rank ?? 0)
    }
    
    var currentHoldingsValues: Double {
        return (currentHolding ?? 0) * current_price
    }
    
    func updateWatchList(amount: Double) -> CoinModel{
        return CoinModel(id: id, symbol: symbol, name: name, image: image, current_price: current_price,
                         market_cap: market_cap, market_cap_rank: market_cap_rank,
                         fully_diluted_valuation: fully_diluted_valuation,
                         total_volume: total_volume, high_24h: high_24h, low_24h: low_24h,
                         price_change_24h: price_change_24h,
                         price_change_percentage_24h: price_change_percentage_24h,
                         market_cap_change_24h: market_cap_change_24h,
                         market_cap_change_percentage_24h: market_cap_change_percentage_24h,
                         circulating_supply: circulating_supply, total_supply: total_supply, ath: ath,
                         ath_change_percentage: ath_change_percentage, ath_date: ath_date, atl: atl,
                         atl_change_percentage: atl_change_percentage, atl_date: ath_date, last_updated: last_updated,
                         sparkline_in_7d: sparkline_in_7d,
                         price_change_percentage_24h_in_currency:price_change_percentage_24h_in_currency,
                         currentHolding: amount)
    }
}

struct SparklineIn7D: Codable {
    let price: [Double]?
}
