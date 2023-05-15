//
//  MarketDataModel.swift
//  MiningMate
//
//  Created by Chenxi Wang on 8/12/22.
//

import Foundation

// JSON data:

//URL: https://api.coingecko.com/api/v3/global


struct GlobalData: Codable {
    let data: MarketDataModel?
}

// MARK: - DataClass
struct MarketDataModel: Codable {
    let total_market_cap, total_volume, market_cap_percentage: [String: Double]
    let market_cap_change_percentage_24h_usd: Double
    let updated_at: Int
    
    var marketCap: String {
        if let item = total_market_cap.first( where: { $0.key == "usd" }) {
            //return "\(item.value)"
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume: String {
        if let item = total_volume.first(where: {$0.key == "usd"}) {
            //return "\(item.value)"
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var btcDominance: String {
        if let item = market_cap_percentage.first(where: {$0.key == "btc"}) {
            return item.value.asPercentString()
        }
        return ""
    }
    
    var ethDominance: String {
        if let item = market_cap_percentage.first(where: {$0.key == "eth"}) {
            return item.value.asPercentString()
        }
        return ""
    }
    
    var marketCapDouble: Double {
        if let item = total_market_cap.first(where: {$0.key == "usd"} ) {
            return item.value
        }
        return 0
    }

}

struct Top5CoinMarket: Codable {
    let coinname: String
    let marketcap: Double
}

