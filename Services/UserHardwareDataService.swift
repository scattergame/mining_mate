//
//  UserHardwareDataService.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/31/22.
//

import Foundation
import CoreData

class UserHardwareDataService {
    private let container: NSPersistentContainer
    private let containerName: String = "UserSavingContainer"
    private let entityName: String = "UserHardwareListEntity"
    
    @Published var savedEntities: [UserHardwareListEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print ("Error loading Core Data! \(error)")
            }
            self.getUserHardwares()
        }
    }
    
    // MARK: PUBLIC
    
    func updateUserHardwareWatchList(hardware: Hardware, coin: SupportCoinDetail, amount: Int16) {
        // only update amount and coin

        if let entity = savedEntities.first(where: { ($0.hardware_name == hardware.name) &&
            ($0.coin_name?.lowercased() == coin.name?.lowercased())} ) {
            //update amount
            let old_amount = entity.amount
            let new_amount = old_amount + amount
            update(entity: entity, coin: coin, amount: new_amount)
        } else {
            var add_hardware = hardware
            add_hardware.myCoin = coin
            add_hardware.myQuantity = amount
            add(hardware: add_hardware)
        }
    }
    
    func removeUserHardware(hardware: Hardware) {
        if let entity = savedEntities.first(where: { ($0.hardware_name == hardware.name) &&
            ($0.coin_name?.lowercased() == hardware.myCoin?.name?.lowercased()) &&
            ($0.amount == hardware.myQuantity)} ) {
            delete(entity: entity)
        }
    }
    
    // MARK: Private functions
    func getUserHardwares() {
        let request = NSFetchRequest<UserHardwareListEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Watchlist Entities. \(error)")
        }
    }
    
    private func add(hardware: Hardware) {
        let entity = UserHardwareListEntity(context: container.viewContext)
        entity.coin_name = hardware.myCoin?.name
        entity.amount = hardware.myQuantity ?? 0
        entity.hardware_name = hardware.name
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print ("Error saving to Core Data. \(error)")
        }
        //applyChanges()
    }
    
    private func update(entity: UserHardwareListEntity, coin: SupportCoinDetail, amount: Int16) {
        entity.amount = amount
        entity.coin_name = coin.name
        applyChanges()
    }
    
    private func delete(entity: UserHardwareListEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func applyChanges() {
        save()
        getUserHardwares()
    }
    
}
