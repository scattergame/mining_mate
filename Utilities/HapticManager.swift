//
//  HapticManager.swift
//  MiningMate
//
//  Created by Chenxi Wang on 8/12/22.
//

import Foundation
import SwiftUI

class HapticManager {
    
    static private let generater = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generater.notificationOccurred(type)
    }
    
}
