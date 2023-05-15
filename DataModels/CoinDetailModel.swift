//
//  CoinDetailModel.swift
//  MiningMate
//
//  Created by Chenxi Wang on 8/28/22.
//

import Foundation

// MARK: - Welcome
struct CoinDetailModel: Codable {
    let id, symbol, name: String?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let description: Description?
    let links: Links?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hashing_algorithm"
        case description, links
    }
}


// MARK: - Links
struct Links: Codable {
    let homepage: [String]?
    let subredditURL: String?
    
    enum CodingKeys: String, CodingKey {
        case homepage
        case subredditURL = "subreddit_url"
    }
}


// MARK: - Description
struct Description: Codable {
    let en: String?
}
