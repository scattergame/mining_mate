//
//  MineableCoinDetailModel.swift
//  MiningMate
//
//  Created by Chenxi Wang on 8/29/22.
//

import Foundation

// MARK: - Welcome
struct MineableCoinDetailModel: Codable {
    let id, symbol, name: String?
    let description: Description?
    let links: Links?
    let market_data: CoinMarketDetail?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name
        case description, links
        case market_data
    }
}

// MARK: - MarketData
struct CoinMarketDetail: Codable {
    let current_price: [String: Double]?
    let market_cap: [String: Double]?
    let market_cap_rank: Int?
    let total_volume: [String: Double]?
    let price_change_24h, price_change_percentage_24h : Double?
    let market_cap_change_24h, market_cap_change_percentage_24h: Double?
    let low_24h, high_24h : [String: Double]?
    let sparkline_7d: SparklineIn7D?
    let last_updated: String?
}
