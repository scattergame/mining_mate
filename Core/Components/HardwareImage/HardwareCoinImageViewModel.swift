//
//  HardwareCoinImageViewModel.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/31/22.
//

import Foundation
import SwiftUI
import Combine

class HardwareCoinImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = true
    
    private let coin: SupportCoinDetail
    private let dataService: HardwareCoinImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: SupportCoinDetail) {
        self.coin = coin
        self.dataService = HardwareCoinImageService(coin: coin)
        self.addSubscribers()
        self.isLoading = false
    }

    private func addSubscribers() {
        dataService.$image
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
            }
            .store(in: &cancellables)
    }
}
