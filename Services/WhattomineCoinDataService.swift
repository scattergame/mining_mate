//
//  WhattomineCoinDataService.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/30/22.
//

import Foundation
import Combine

class WhattomineCoinDataService {
    
    @Published var whattomineCoinList: WhattomineCoinListModel = WhattomineCoinListModel(coins: [:])
    @Published var whattomineCoins: [String : WhattominCoinModel] = [:]
    var whattomineCoinDataSubscription: AnyCancellable?
    
    init() {
        getWhattomineCoins()
    }
    
    func getWhattomineCoins() {
        let JSONurl = "https://whattomine.com/coins.json"
        //let coinListJSONurl = "https://jsonkeeper.com/b/5BGS"
        
        guard let url = URL(string: JSONurl) else {
            return
        }
        
        whattomineCoinDataSubscription = NetworkManager.download(url: url)
            .decode(type: WhattomineCoinListModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnlist in
                self?.whattomineCoinList = returnlist
                self?.whattomineCoins = returnlist.coins
                self?.whattomineCoinDataSubscription?.cancel()
            })
    }
    
}
