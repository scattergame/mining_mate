//
//  HardwareDataService.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/31/22.
//

import Foundation

import Combine


class HardwareDataService {
    
    @Published var allHardwareData: [Hardware] = []
    //var cancellables = Set<AnyCancellable>()
    var hardwareSubscription: AnyCancellable?
    
    init() {
        getHardwareData()
    }
    
    func getHardwareData() {
        //let hardwareDataJSONurl = "https://scattergame.github.io/json_host/hardware_list.json"
        let hardwareDataJSONurl = "https://api.minerstat.com/v2/hardware"
        guard let url = URL(string: hardwareDataJSONurl) else {
            return
        }
        hardwareSubscription = NetworkManager.download(url: url)
            .decode(type: [Hardware].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnHardware in
                self?.allHardwareData = returnHardware
                self?.hardwareSubscription?.cancel()
                //print (Array(returnHardware[0...0]))
            })
    }
}
