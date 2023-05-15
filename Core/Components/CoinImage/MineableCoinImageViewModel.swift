//
//  MineableCoinImageViewModel.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/30/22.
//

import Foundation
import SwiftUI
import Combine

class MineableCoinImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = true
    
    private let coin: MineableCoinModel
    private let dataService: MineableCoinImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: MineableCoinModel) {
        self.coin = coin
        self.dataService = MineableCoinImageService(coin: coin)
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
