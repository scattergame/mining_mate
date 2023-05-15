//
//  HardwareModel.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/31/22.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let hardware = try? newJSONDecoder().decode(Hardware.self, from: jsonData)

import Foundation

// MARK: - HardwareElement
struct Hardware: Codable, Identifiable {
    let id, name, url: String
    let type: String
    let brand: String
    let algorithms: [String: Algorithm]?
    let specs: Specs?
    var support_coins: [MineableCoinModel]?
    var support_coins_details: [SupportCoinDetail]?
    var myQuantity: Int16?
    var myCoin: SupportCoinDetail?
    var bestCoin: SupportCoinDetail? {
        return support_coins_details?.max{ $0.profit ?? 0 <  $1.profit ?? 0 }
    }
    var profitRate: Double? {
        let rate: Double = (myCoin?.profit ?? 0)/(bestCoin?.profit ?? 1)
        if (rate<0) {
            return 0
        }
        return rate
    }
    var brand_short: String? {
        if (brand.lowercased() == "amd") {return "AMD"}
        if (brand.lowercased() == "nvidia") {return "NVDA"}
        return "ASIC"
    }
    var unit_profit: Double? {
        return myCoin?.profit ?? 0
    }
    var total_profit: Double? {
        let quantity = Double(myQuantity ?? 0)
        return (unit_profit ?? 0) * quantity
    }
    var unit_power: Double? {
        return Double(myCoin?.power ?? 0)
    }
    var total_power: Double? {
        let quantity = Double(myQuantity ?? 0)
        return (unit_power ?? 0) * quantity
    }
}

struct SupportCoinDetail: Codable {
    var id = UUID().uuidString
    var name: String?
    var symbol: String?
    var price: Double?
    var yeild: Double?
    var reward: Double?
    var profit: Double?
    var blocktime: Double?
    var blockreward: Double?
    var algorithm: String?
    var nethash: Double?
    var power: Int?
    var speed: Double?
    var image: String?
}

// MARK: - Algorithm
struct Algorithm: Codable{
    let speed: Double
    let power: Int
}

// MARK: - Specs
struct Specs: Codable {
//    let releaseDate: String?
//    let size, weight, noiseLevel: String?
//    let numberOfChips: Int?
//    let chipType: String?
//    let release: String?
//    let numberOfFans: NumberOfFans?
//    let memorySizeVRAM, shipping: String?
//    let chipBoards: Int?
//    let chipName: String?
//    let chipCount, numberOfChipBoards: Int?
//    let shippingDate: String?
//    let fans: Int?
//    let ratedPower, powerConnectors: String?
    let memorySize: String?
//    let numberOfBoards: Int?
//    let vram, dimensions, powerConsumption, supplyPowerRecommended: String?
//    let weigh, baseClock, boostClock, gpuPower: String?
//    let maxMemorySize, maxMemoryBandwidth: String?
    let maxMemorySize: String?
    let memoryType: String?
    let memorySizeVRAM: String?
//    let openGL: Double?
//    let chip, estimatedDelivery, memoryClock, forGeneralSale: String?
//    let baseFrequency, boostFrequency, peakFrequency, typicalBoardPowerDesktop: String?
//    let openCL: Int?
//    let coreClock: String?
//    let cudaCores: Int?
//    let maxTemp, memoryInterface: String?
//    let gpuCores: Int?
//    let gameFrequency, infinityCache: String?
//    let computeUnits: Int?
//    let memoryBandwidth, chipSize, hashboards, fansSpeed: String?
    
    enum CodingKeys: String, CodingKey {
        case memorySize = "Memory Size"
        case memoryType = "Memory Type"
        case maxMemorySize = "Max Memory Size"
        case memorySizeVRAM = "Memory size (VRAM)"
    }
    
//    enum CodingKeys: String, CodingKey {
//        case releaseDate = "Release date"
//        case size = "Size"
//        case weight = "Weight"
//        case noiseLevel = "Noise level"
//        case numberOfChips = "Number of chips"
//        case chipType = "Chip type"
//        case release = "Release"
//        case numberOfFans = "Number of fans"
//        case memorySizeVRAM = "Memory size (VRAM)"
//        case shipping = "Shipping"
//        case chipBoards = "Chip boards"
//        case chipName = "Chip name"
//        case chipCount = "Chip count"
//        case numberOfChipBoards = "Number of chip boards"
//        case shippingDate = "Shipping date"
//        case fans = "Fans"
//        case ratedPower = "Rated Power"
//        case powerConnectors = "Power connectors"
//        case memorySize = "Memory Size"
//        case numberOfBoards = "Number of boards"
//        case vram = "VRAM"
//        case dimensions = "Dimensions"
//        case powerConsumption = "Power consumption"
//        case supplyPowerRecommended = "Supply power recommended"
//        case weigh = "Weigh"
//        case baseClock = "Base Clock"
//        case boostClock = "Boost Clock"
//        case gpuPower = "GPU Power"
//        case maxMemorySize = "Max Memory Size"
//        case maxMemoryBandwidth = "Max Memory Bandwidth"
//        case memoryType = "Memory Type"
//        case openGL = "OpenGL"
//        case chip = "Chip"
//        case estimatedDelivery = "Estimated delivery"
//        case memoryClock = "Memory Clock"
//        case forGeneralSale = "For general sale"
//        case baseFrequency = "Base Frequency"
//        case boostFrequency = "Boost Frequency"
//        case peakFrequency = "Peak Frequency"
//        case typicalBoardPowerDesktop = "Typical Board Power (Desktop)"
//        case openCL = "OpenCL"
//        case coreClock = "Core Clock"
//        case cudaCores = "CUDA cores"
//        case maxTemp = "Max temp."
//        case memoryInterface = "Memory Interface"
//        case gpuCores = "GPU cores"
//        case gameFrequency = "Game Frequency"
//        case infinityCache = "Infinity cache"
//        case computeUnits = "Compute units"
//        case memoryBandwidth = "Memory Bandwidth"
//        case chipSize = "Chip size"
//        case hashboards = "Hashboards"
//        case fansSpeed = "Fans speed"
//    }
    var correctMemSize: String {
        if memorySize != nil {return memorySize!}
        if memorySizeVRAM != nil {return memorySizeVRAM!}
        if maxMemorySize != nil {return maxMemorySize!}
        return "Unknown"
    }
}

enum NumberOfFans: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(NumberOfFans.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for NumberOfFans"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

