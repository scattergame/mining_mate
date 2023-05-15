//
//  HardwareCoinImageView.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/31/22.
//

import SwiftUI

struct HardwareCoinImageView: View {
    
    @StateObject var vm: HardwareCoinImageViewModel
    
    init(coin: SupportCoinDetail) {
        _vm = StateObject(wrappedValue: HardwareCoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.7))
                    )
            } else if vm.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}

struct HardwareCoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        HardwareCoinImageView(coin: dev.details)
    }
}
