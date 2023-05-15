//
//  WatchlistCoinDataService.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/30/22.
//

import Foundation
import CoreData

class WatchlistCoinDataService {
    
    private let container: NSPersistentContainer
    private let containerName: String = "UserSavingContainer"
    private let entityName: String = "WatchListEntity"
    @Published var savedEntities: [WatchListEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print ("Error loading Core Data! \(error)")
            }
            self.getWatchlistCoins()
        }
    }
    
    // MARK: PUBLIC
    
    func updateWatchList_noamount(coin: CoinModel) {
        // check if coin is already in watchlist
        if savedEntities.first(where: { $0.coinID == coin.id } ) != nil {
        } else {
            add(coin: coin, amount: 0)
        }
    }
    
    func updateWatchList(coin: CoinModel, amount: Double) {
        // check if coin is already in watchlist
        if let entity = savedEntities.first(where: { $0.coinID == coin.id } ) {
            update(entity: entity, amount: amount)
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    func removeCoinFromWatchList(coin: CoinModel) {
        if let entity = savedEntities.first(where: { $0.coinID == coin.id } ) {
            delete(entity: entity)
        }
    }
    
    // MARK: PRIVATE Section
    
    private func getWatchlistCoins() {
        let request = NSFetchRequest<WatchListEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Watchlist Entities. \(error)")
        }
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = WatchListEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.coinAmount = amount
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print ("Error saving to Core Data. \(error)")
        }
    }
    
    private func update(entity: WatchListEntity, amount: Double) {
        entity.coinAmount = amount
        applyChanges()
    }
    
    private func delete(entity: WatchListEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func applyChanges() {
        save()
        getWatchlistCoins()
    }
    
}
