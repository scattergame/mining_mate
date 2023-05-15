//
//  StatisticView.swift
//  MiningMate
//
//  Created by Chenxi Wang on 8/12/22.
//

import SwiftUI

struct StatisticView: View {
    
    let stat: StatisticModel
    
    var body: some View {
        VStack (alignment: .center) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            HStack {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees:
                                            (stat.percentageChange ?? 0 >= 0 ?
                                             0 : 180)))
                Text(stat.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundColor(stat.percentageChange ?? 0 >= 0 ?
                             Color.theme.green : Color.theme.red)
            .opacity(stat.percentageChange == nil ?
                     0.0 : 1.0)
        }
        .lineLimit(1)
        .minimumScaleFactor(0.5)
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticView(stat: dev.state1)
                .previewLayout(.sizeThatFits)
        }
    }
}
