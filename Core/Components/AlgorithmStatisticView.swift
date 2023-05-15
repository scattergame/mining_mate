//
//  AlgorithmStatisticView.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 9/10/22.
//

import SwiftUI

struct AlgorithmStatisticView: View {
    
    let stat: AlgorithmStatisticModel
    
    var body: some View {
        VStack (alignment: .center) {
            Text(stat.name)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Text(stat.speed)
                .font(.headline)
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(stat.power)
                .font(.caption)
                .bold()
                .foregroundColor(Color.theme.accent)
        }
    }
}

struct AlgorithmStatisticView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AlgorithmStatisticView(stat: dev.algorithmstate1)
                .previewLayout(.sizeThatFits)
        }
    }
}
