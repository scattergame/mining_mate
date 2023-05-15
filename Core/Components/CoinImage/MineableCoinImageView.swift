//
//  MineableCoinImageView.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 8/30/22.
//

import SwiftUI

struct MineableCoinImageView: View {
    
    @StateObject var vm: MineableCoinImageViewModel
    
    init(coin: MineableCoinModel) {
        _vm = StateObject(wrappedValue: MineableCoinImageViewModel(coin: coin))
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

struct MineableCoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        MineableCoinImageView(coin: dev.mineableCoin)
    }
}
