//
//  MineableCoinModel.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/30/22.
//

import Foundation

//struct MineableCoinModel: Codable, Identifiable {
//    let id: String
//    let coin: String
//    let name: String
//    let type: String
//    let algorithm: String
//    let network_hashrate: Double
//    let difficulty: Double
//    let reward : Double
//    let reward_unit: String
//    let reward_block: Double
//    let price: Double
//    let volume: Double
//    let updated: Int
//}

// MARK: - WelcomeElement
struct MineableCoinModel: Codable, Identifiable {
    let id, name: String
    let symbol: String
    let type: TypeEnum
    let algorithm: String?
    let networkHashrate: Double
    let difficulty: Difficulty
    let reward: Double
    let rewardUnit: String
    //let rewardBlock: Double?
    let price : Double
    let volume: Double?
    let updated: Int
    var image: String?
    var coinid: String? // use this to get details from coingecko api
    var coinrank: Int? // try to get coin rank from coingecko api
    
    // here are all from what to mine
    var wtm_difficultynow: Double?
    var wtm_difficulty24: Double?
    var wtm_blockreward: Double?
    var wtm_blockreward24: Double?
    var wtm_blocktime: Double?
    var wtm_lastblock: Int?
    var wtm_nethash: Double?
    var wtm_market_cap: String?
    var wtm_timestamp: Int?
    
    var my_dailyprofit: Double?
    var my_dailyyeild: Double?
    var my_dailyreward: Double?
    var my_dailycost: Double?
    var my_dailyspeed: Double?

    //let double_difficulty: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case symbol = "coin"
        case name, type, algorithm, image
        case networkHashrate = "network_hashrate"
        case difficulty, reward
        case rewardUnit = "reward_unit"
        //case rewardBlock = "reward_block"
        case price, volume, updated
    }
    
    var difficultyasdouble: Double {
        let difficulty_string = String(describing: difficulty)
        //print ("full string:", difficulty_string)
        var difficulty_substring = ""
        if (difficulty_string.range(of: "string(") == nil) {
            //print ("check double")
            if let index0 = difficulty_string.range(of: "double("),
               let index1 = difficulty_string.range(of: ")") {
                difficulty_substring = String(difficulty_string[index0.upperBound..<index1.lowerBound])
                //difficulty_substring = "1.52"
            }
        } else {
            //print ("check string")
            if let index0 = difficulty_string.range(of: "string(\""),
               let index1 = difficulty_string.range(of: "\")") {
                difficulty_substring = String(difficulty_string[index0.upperBound..<index1.lowerBound])
                //difficulty_substring = "1.52"
            }
        }
        return Double(difficulty_substring) ?? 0.0
    }
    
}

enum Difficulty: Codable {
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
        throw DecodingError.typeMismatch(Difficulty.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Difficulty"))
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

enum TypeEnum: String, Codable {
    case coin = "coin"
    case pool = "pool"
}


struct Top5CurrentMiningCoin: Codable {
    let coinname: String
    let dailyprofit: Double
}
