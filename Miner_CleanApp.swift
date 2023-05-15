//
//  Miner_CleanApp.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/27/22.
//

import SwiftUI

@main
struct Miner_CleanApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            //testView()
            //NavigationView {
                HomeView()
                    .environmentObject(vm)
                    //.navigationBarHidden(true)
            //}
        }
    }
}
