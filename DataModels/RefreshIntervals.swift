//
//  RefreshIntervals.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 9/9/22.
//

import Foundation

// MARK: Auto Refresh option (in minutes)
enum AutoRefreshOption: String, CaseIterable, Identifiable {
    case one = "1 minute"
    case two = "2 minutes"
    case three = "3 minutes"
    case five = "5 minutes"
    case ten = "10 minutes"
    case fifteen = "15 minutes"
    case thirty = "30 minutes"
    case sixty = "1 hour"
    var id: Self {self}
}
