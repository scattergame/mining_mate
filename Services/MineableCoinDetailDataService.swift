//
//  MineableCoinDetailDataService.swift
//  MiningMate
//
//  Created by Chenxi Wang on 8/29/22.
//

import Foundation
import Combine

class MineableCoinDetailDataService {
    
    @Published var mineableCoinDetail: MineableCoinDetailModel? = nil
    var mineableCoinDetailSubscription: AnyCancellable?
    
    let mineableCoin: MineableCoinModel
    
    init(mineableCoin: MineableCoinModel) {
        self.mineableCoin = mineableCoin
        getMineableCoinDetail()
    }
    
    func getMineableCoinDetail() {
        let JSONurl = "https://api.coingecko.com/api/v3/coins/\(mineableCoin.coinid ?? "ethereum")?localization=false&tickers=false&market_data=true&community_data=true&developer_data=false&sparkline=true"
        guard let url = URL(string: JSONurl) else {return}
        
        mineableCoinDetailSubscription = NetworkManager.download(url: url)
            .decode(type: MineableCoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returndetails in
                self?.mineableCoinDetail = returndetails
                self?.mineableCoinDetailSubscription?.cancel()
            })
    }
}
