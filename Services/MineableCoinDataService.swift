//
//  MineableCoinDataService.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/30/22.
//

import Foundation
import Combine 

class MineableCoinDataService {
    
    @Published var allMineableCoins: [MineableCoinModel] = []
    
    var mineableCoinSubscription: AnyCancellable?
    
    init() {
        getMineableCoins()
    }
    
    func getMineableCoins() {
        
        let JSONurl = "https://api.minerstat.com/v2/coins"
        
        //print (MiningStatusDataJSONurl)
        
        guard let url = URL(string: JSONurl) else {
            return
        }
        
        mineableCoinSubscription = NetworkManager.download(url: url)
            .decode(type: [MineableCoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnCoins in
                self?.allMineableCoins = returnCoins
                self?.mineableCoinSubscription?.cancel()
                //print (returnCoins)
            })
    }
    
}
