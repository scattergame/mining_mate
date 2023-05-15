//
//  MarketDataService.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/30/22.
//

import Foundation
import Combine

class MarketDataService {
    
    @Published var marketData: MarketDataModel? = nil
    
    var marketDataSubscription: AnyCancellable?
    
    init() {
        getMarketData()
    }
    
    func getMarketData() {
        
        let JSONurl = "https://api.coingecko.com/api/v3/global"
        //let MarketDataJsonURL = "https://jsonkeeper.com/b/XNBL"
        guard let url = URL(string: JSONurl) else {return}
        
        marketDataSubscription = NetworkManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedGlobalData in
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
    }
}
