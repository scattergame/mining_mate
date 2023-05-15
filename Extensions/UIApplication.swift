//
//  UIApplication.swift
//  MiningMate
//
//  Created by Chenxi Wang on 8/8/22.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
