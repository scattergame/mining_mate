//
//  ExtraCoinDataService.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/30/22.
//

import Foundation
import Combine

class ExtraCoinDataService {
    
    @Published var extraCoins: [ExtraCoinModel] = []
    var extraCoinsSubscription: AnyCancellable?
    
    init() {
        getExtraCoins()
    }
    
    func getExtraCoins() {
        
        let JSONurl = "https://scattergame.github.io/json_host/coins_10000.json"
        
        guard let url = URL(string: JSONurl) else {
            return
        }
        
        extraCoinsSubscription = NetworkManager.download(url: url)
            .decode(type: [ExtraCoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnCoins in
                self?.extraCoins = returnCoins
                self?.extraCoinsSubscription?.cancel()
            })
    }
}
