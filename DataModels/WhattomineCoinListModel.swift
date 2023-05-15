//
//  WhattomineCoinListModel.swift
//  MiningMate
//
//  Created by Chenxi Wang on 8/21/22.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

// MARK: - Welcome
struct WhattomineCoinListModel: Codable {
    let coins: [String: WhattominCoinModel]
}

// MARK: - Coins
struct WhattominCoinModel: Codable {
    let id: Int
    let tag: String
    let algorithm: String
    let block_time: BlockTime?
    let block_reward, block_reward24: Double
    let last_block: Int
    let difficulty, difficulty24: Double?
    let nethash: Double
    let exchange_rate, exchange_rate24: Double
    let exchange_rate_vol: Double
    let exchange_rate_curr: String
    let market_cap: String
    let estimated_rewards, estimated_rewards24: String
    let btc_revenue, btc_revenue24: String
    let profitability, profitability24: Int
    let lagging: Bool
    let timestamp: Int
    
    var blocktimeasDouble: Double {
        let blocktime_string = String(describing: block_time)
        var blocktime_substring = ""
        if let index0 = blocktime_string.range(of: "(\"") ,
           let index1 = blocktime_string.range(of: "\"))") {
            //print (blocktime_string[index0.upperBound..<index1.lowerBound])
            blocktime_substring = String(blocktime_string[index0.upperBound..<index1.lowerBound])
        }
        return Double(blocktime_substring) ?? -1.0
    }
}

enum BlockTime: Codable {
    case double(Double)
    case string(String)
//
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(BlockTime.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for BlockTime"))
    }
//
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

