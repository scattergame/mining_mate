//
//  CoinDetailDataService.swift
//  MiningMate
//
//  Created by Chenxi Wang on 8/28/22.
//

import Foundation
import Combine

class CoinDetailDataService {
    
    @Published var coinDetail: CoinDetailModel? = nil

    var coinDetailSubscription: AnyCancellable?
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinDetail()
    }
    
    func getCoinDetail() {
        let JSONurl = "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
        //print ("load coingecko")
        guard let url = URL(string: JSONurl) else {return}
        
        coinDetailSubscription = NetworkManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returndetails in
                self?.coinDetail = returndetails
                self?.coinDetailSubscription?.cancel()
            })
    }
    
}
