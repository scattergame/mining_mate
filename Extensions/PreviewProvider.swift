//
//  PreviewProvider.swift
//  MiningMate
//
//  Created by Chenxi Wang on 8/6/22.
//

import Foundation
import SwiftUI

extension PreviewProvider{
    
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
    
}

class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    private init() {}
    
    let homeVM = HomeViewModel()
    
    let state1 = StatisticModel(title: "Market Cap", value: "$10.5Bn", percentageChange: 13.2)
    let state2 = StatisticModel(title: "Total Volumn", value: "$12.5Tr")
    let state3 = StatisticModel(title: "Portfolio", value: "$53.5k", percentageChange: -15.7)
    
    let miningstate1 = MiningStatisticModel(title: "Mining Coins", value: 2)
    let miningstate2 = MiningStatisticModel(title: "24h Profit", value: 18.76)
    let miningstate3 = MiningStatisticModel(title: "24h Reward", value: 27.16)
    let miningstate4 = MiningStatisticModel(title: "24h Cost", value: -8.39)
    let miningstate5 = MiningStatisticModel(title: "Electricity Rate", value: 0.13)
    let miningstate6 = MiningStatisticModel(title: "Power", value: 3759)
    
    let hardwarestate1 = HardwareStatisticModel(title: "ASIC", value: 2)
    let hardwarestate2 = HardwareStatisticModel(title: "AMD GPU", value: 2)
    let hardwarestate3 = HardwareStatisticModel(title: "Nvidia GPU", value: 4)
    let hardwarestate4 = HardwareStatisticModel(title: "Current Strategy", value: 33.55, note: 3549)
    let hardwarestate5 = HardwareStatisticModel(title: "Suggest Strategy", value: 42.13, note: 3684)
    let hardwarestate6 = HardwareStatisticModel(title: "Overall Efficiency", value: 75.2)
    
    let algorithmstate1 = AlgorithmStatisticModel(name: "Autolykos2", speed: "89.1 MH/s", power: "101 W")
    
    //let miningstate1 = MiningStatisticModel(coinnumber: 2, totalProfit: 35.5, totalPower: 6433, totalReward: 57.2, totalCost: 21.7)
    
    let coin: CoinModel = CoinModel(
        id: "bitcoin",
        symbol: "btc",
        name: "Bitcoin",
        image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
        current_price: 23189,
        market_cap: 443426438705,
        market_cap_rank: 1,
        fully_diluted_valuation: 487171237632,
        total_volume: 14898764918,
        high_24h: 23322,
        low_24h: 23073,
        price_change_24h: 10.51,
        price_change_percentage_24h: 0.04537,
        market_cap_change_24h: 302519003,
        market_cap_change_percentage_24h: 0.06827,
        circulating_supply: 19114337,
        total_supply: 21000000,
        ath: 69045,
        ath_change_percentage: -66.4006,
        ath_date: "2021-11-10T14:24:11.849Z",
        atl: 67.81,
        atl_change_percentage: 34111.72759,
        atl_date: "2013-07-06T00:00:00.000Z",
        last_updated: "2022-08-06T21:47:47.455Z",
        sparkline_in_7d: SparklineIn7D(price: [24484.720577271193,
                                               24528.69610330859,
                                               24218.643511311337,
                                               23969.065901890666,
                                               23941.571252496764,
                                               23729.448125110524,
                                               23653.459549430798,
                                               23732.902876081458,
                                               23749.514155692617,
                                               23807.022333832083,
                                               23743.381827548543,
                                               23819.336942614947,
                                               23763.196233244733,
                                               23796.764610026683,
                                               23739.605991695662,
                                               23669.404004016746,
                                               23747.085914792726,
                                               23797.22716472104,
                                               23794.181685419884,
                                               23831.37270244681,
                                               23744.219078820974,
                                               23751.42655533799,
                                               23779.20982405118,
                                               23788.7131462306,
                                               23733.417287005916,
                                               23668.67652653213,
                                               23858.138349751338,
                                               23822.836507103373,
                                               23603.763247155497,
                                               23288.61718933002,
                                               23344.85586704442,
                                               23441.0804160777,
                                               23421.057391253977,
                                               23445.52374480926,
                                               23366.128355758876,
                                               23398.65584430152,
                                               23358.10753009553,
                                               23239.690445517183,
                                               23338.997305915254,
                                               23339.97597455211,
                                               23362.7508245893,
                                               23029.078440021807,
                                               23270.295705683406,
                                               23176.73357658733,
                                               23105.494960500542,
                                               23467.475084576523,
                                               23334.1557335138,
                                               23200.553474645974,
                                               22944.24607430787,
                                               22916.219054614387,
                                               22965.342848277465,
                                               23000.87953630366,
                                               23024.727978517763,
                                               23188.23385659723,
                                               23304.1571928234,
                                               23202.19659145586,
                                               23030.548084427675,
                                               22910.21172636582,
                                               22872.24479855461,
                                               22865.664954491924,
                                               22901.21719287984,
                                               22941.69366831134,
                                               22929.004063541244,
                                               22863.418535111665,
                                               22754.248681980403,
                                               22846.03244034653,
                                               22961.911906856592,
                                               22773.1548001195,
                                               22772.754566320524,
                                               23034.40445232363,
                                               23010.00392655651,
                                               23412.928605120822,
                                               23188.72466579322,
                                               23106.894196639056,
                                               23058.788925401288,
                                               23001.32394626324,
                                               23073.917545949414,
                                               23115.382085589026,
                                               23052.946432738398,
                                               22778.669544609886,
                                               22810.598754003724,
                                               22818.006390093644,
                                               22851.29370993277,
                                               22872.394253258004,
                                               22970.347607715456,
                                               23071.255492072465,
                                               23041.911704666516,
                                               23247.835065103893,
                                               23406.847516862126,
                                               23420.539563171056,
                                               23385.63635414085,
                                               23347.694879236282,
                                               23371.344890013825,
                                               23293.66621786727,
                                               23365.62773939191,
                                               23448.830276568286,
                                               23478.45318170668,
                                               23561.825256339675,
                                               23514.886101809436,
                                               23353.15526502444,
                                               23329.23241864078,
                                               23026.02287402876,
                                               22860.42098438317,
                                               23021.363403137442,
                                               23165.07299862601,
                                               23154.057166073842,
                                               23103.059748132782,
                                               23131.857855052407,
                                               23146.821787804925,
                                               22941.33425740183,
                                               22966.697985477986,
                                               22840.295982877997,
                                               22872.47809481704,
                                               22891.689214319722,
                                               22925.591058156344,
                                               22939.92827909115,
                                               22998.007950207473,
                                               22918.987264249394,
                                               22889.943487417593,
                                               22759.624086553336,
                                               22666.122824147693,
                                               22626.14436355951,
                                               22526.435183639795,
                                               22569.498122092893,
                                               22555.159978032265,
                                               22639.315927631513,
                                               22670.805467242913,
                                               22670.754974103194,
                                               22792.56894034112,
                                               23101.629653708267,
                                               23189.72937256446,
                                               23162.64545857599,
                                               23244.716623299006,
                                               23270.178940177517,
                                               23213.183442976253,
                                               23136.194708847743,
                                               23145.397604891536,
                                               23236.66447917,
                                               23426.863032781774,
                                               23041.140476247227,
                                               23061.426167940153,
                                               23225.346907374642,
                                               23042.103136243677,
                                               23006.724847657093,
                                               22958.232947473756,
                                               22834.97170925916,
                                               22914.175494713192,
                                               22975.426717494902,
                                               23152.80401737373,
                                               23240.700574791303,
                                               23225.036201942938,
                                               23289.635614459137,
                                               23248.370622776587,
                                               23276.748783798543,
                                               23203.53378919455,
                                               23227.182484320372,
                                               23204.679549688728,
                                               23186.37353251177,
                                               23224.30083975727,
                                               23170.585831566834,
                                               23205.743133485837,
                                               23199.620151590272,
                                               23177.198029948682,
                                               23197.719672630807,
                                               23211.868632619335,
                                               23220.887956958457,
                                               23209.576812276,
                                               23212.477809256714]),
        price_change_percentage_24h_in_currency: 0.045366167353838076,
        currentHolding: 0.01, in_watchlist: false)
    
    
    let mineableCoin: MineableCoinModel = MineableCoinModel(
        id:"6e9fedf022a2f5575975725e3f92dfd426688cac",
        name:"Ergo",
        symbol:"ERG",
        type: TypeEnum.coin,
        algorithm: "Autolykos2",
        networkHashrate: 11341930263857,
        difficulty:Difficulty.double(1443113306423296.0),
        reward: 1.1974111750676e-10,
        rewardUnit: "ERG",
        //rewardBlock: 48,
        price: 2.9336325157072,
        volume: 1821882.506771,
        updated: 1660565178,
        image: "https://assets.coingecko.com/coins/images/2484/large/Ergo.png?1574682618",
        coinrank: 172,
        my_dailyprofit: 10.0,
        my_dailyyeild: 10.0)
    
    
    let details: SupportCoinDetail = SupportCoinDetail(id: "6e9fedf022a2f5575975725e3f92dfd426688cac",
                                                       name: "Ergo", symbol: "ERG", price: 2.135, yeild: 0.433, reward: 0.897, profit: 0.675,
                                                       image: "https://assets.coingecko.com/coins/images/2484/large/Ergo.png?1574682618")
    
    
    let amdprotype: Hardware = Hardware(
        id: "982fd8b711279888a3b54f5af24f185041d22ee6",
        name: "AMD RX 6700 XT",
        url: "amd-rx-6700-xt",
        type: "gpu",
        brand: "AMD",
        algorithms: ["Blake (2s)" : Algorithm(speed: 6413385481, power: 176),
                     "CNReverseWaltz": Algorithm(speed: 1478.9, power: 132),
                     "Chukwa2": Algorithm(speed: 29347.744, power: 197),
                     "Equihash(144,5)": Algorithm(speed: 57.79, power: 183),
                     "Equihash(192,7)": Algorithm(speed: 34.593, power: 190),
                     "Etchash": Algorithm(speed: 47024545, power: 121),
                     "Ethash": Algorithm(speed: 47024545, power: 121),
                     "Autolykos2": Algorithm(speed: 89089620, power: 101),
                     "Equihash(125,4)": Algorithm(speed: 32.851, power: 194),
                     "Argon2d-ninja": Algorithm(speed: 0.142, power: 185),
                     "Equihash(210,9)": Algorithm(speed: 178.02, power: 121),
                     "KAWPOW": Algorithm(speed: 25440000, power: 140),
                     "KangarooTwelve": Algorithm(speed: 1905527400.761, power: 177),
                     "Ubqhash": Algorithm(speed: 43783200, power: 108),
                     "VerusHash": Algorithm(speed: 12678149.048, power: 186),
                     "Zhash": Algorithm(speed: 58.82, power: 99),
                     "cuckAToo32": Algorithm(speed: 0.57, power: 207),
                     "BeamHashII": Algorithm(speed: 31.903, power: 173),
                     "BeamHashIII": Algorithm(speed: 21.52, power: 134),
                     "ProgPowSERO": Algorithm(speed: 20830387.716, power: 202),
                     "cuckARood29": Algorithm(speed: 5.01, power: 143),
                     "Chukwa": Algorithm(speed: 97504.306, power: 185),
                     "HeavyHash": Algorithm(speed: 303851128.085, power: 66),
                     "Phi5": Algorithm(speed: 7.225, power: 185),
                     "Eaglesong": Algorithm(speed: 868369066.335, power: 70),
                     "Verthash": Algorithm(speed: 635907.739, power: 135),
                     "Circcash": Algorithm(speed: 1784105.593, power: 59),
                     "BCD": Algorithm(speed: 17444549, power: 82),
                     "C11": Algorithm(speed: 20067557, power: 79),
                     "HMQ1725": Algorithm(speed: 9208594, power: 77),
                     "HoneyComb": Algorithm(speed: 40065802, power: 81),
                     "Lyra2REv2": Algorithm(speed: 53892503, power: 91),
                     "Lyra2REv3": Algorithm(speed: 39640654, power: 154),
                     "PHI1612": Algorithm(speed: 23953811, power: 79),
                     "Skein2": Algorithm(speed: 598389911, power: 67),
                     "Skunkhash": Algorithm(speed: 32368663, power: 79),
                     "SonoA": Algorithm(speed: 2441303, power: 162),
                     "Tribus": Algorithm(speed: 82236068, power: 162),
                     "X16R": Algorithm(speed: 15071271, power: 81),
                     "X16Rv2": Algorithm(speed: 14404304, power: 86),
                     "X16S": Algorithm(speed: 15056800, power: 81),
                     "X17": Algorithm(speed: 15036856, power: 84),
                     "X25X": Algorithm(speed: 2013770, power: 57),
                     "Xevan": Algorithm(speed: 5285894, power: 168),
                     "X22i": Algorithm(speed: 8398855, power: 76),
                     "X16RT": Algorithm(speed: 20386310, power: 134),
                     "ProgPowZ": Algorithm(speed: 20386310, power: 134),
                     "X21S": Algorithm(speed: 10122990, power: 79),
                     "Astralhash": Algorithm(speed: 25562142, power: 76),
                     "Dedal": Algorithm(speed: 15441049, power: 84),
                     "Argon2d-16000": Algorithm(speed: 9376.822, power: 119),
                     "Globalhash": Algorithm(speed: 52740605, power: 137),
                     "Hex": Algorithm(speed: 13401684, power: 81),
                     "Jeonghash": Algorithm(speed: 12098749, power: 86),
                     "Lyra2vc0ban": Algorithm(speed: 53971472, power: 88),
                     "Padihash": Algorithm(speed: 14609760, power: 93),
                     "Pawelhash": Algorithm(speed: 9832677, power: 74),
                     "TimeTravel10": Algorithm(speed: 33057660, power: 78),
                     "X11k": Algorithm(speed: 3088092, power: 78),
                     "X16RTVEIL": Algorithm(speed: 15069129, power: 80),
                     "X17R": Algorithm(speed: 15535030, power: 160),
                     "X18": Algorithm(speed: 11157591, power: 81),
                     "vProgPow": Algorithm(speed: 7597580, power: 119),
                     "SHA-256csm": Algorithm(speed: 1715646415, power: 62),
                     "0x10": Algorithm(speed: 24954288, power: 161)],
        specs: Specs(memorySize: "12GB", maxMemorySize: "12GB", memoryType: "GDDR6", memorySizeVRAM: "12GB"))
     
}
