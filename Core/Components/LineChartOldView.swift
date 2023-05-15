//
//  LineChartOldView.swift
//  MiningMate
//
//  Created by Chenxi Wang on 8/29/22.
//

import SwiftUI
import SwiftUIX

struct LineChartOldView: View {
    
    let data: [Double]
    let minY: Double
    let maxY: Double
    let midY: Double
    let updated_date: Date
    let start_date, mid_date: Date
    let lineColor: Color
    
    init(coin: CoinModel) {
        data = coin.sparkline_in_7d?.price ?? []
        minY = data.min() ?? 0
        maxY = data.max() ?? 0
        midY = (minY + maxY) / 2.0
        //self.coin = coin
        updated_date = Date(coinGeckoString: coin.last_updated ?? "")
        start_date = updated_date.addingTimeInterval(-7*24*3600)
        mid_date = updated_date.addingTimeInterval(-7*12*3600)
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        self.lineColor = priceChange >= 0 ? Color.theme.green : Color.theme.red
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Path { path in
                    for index in data.indices {
                        
                        let chartwidth = geometry.size.width
                        let chartheight = geometry.size.height
                        
                        let n_data = CGFloat(data.count)
                        let eachpixelwidth = chartwidth / n_data
                        let xPosition = eachpixelwidth * CGFloat(index+1)
                        
                        let yAxis = CGFloat(maxY - minY)
                        let yPosition = chartheight - (data[index] - minY) * chartheight / yAxis
                                        
                        if (index==0) {
                            path.move(to: CGPoint(x: xPosition, y: yPosition))
                        }
                        path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    }
                }
                .stroke(lineColor, style: StrokeStyle(lineWidth: 2))
                .shadow(color: lineColor.opacity(0.5), radius: 5, x: 0, y: 10)
                .shadow(color: lineColor.opacity(0.3), radius: 5, x: 0, y: 15)
                .shadow(color: lineColor.opacity(0.1), radius: 5, x: 0, y: 20)
            }
            .background(
                VisualEffectBlurView(blurStyle: .systemUltraThinMaterial) {
                    Divider()
                    Spacer()
                    Divider()
                    Spacer()
                    Divider()
                }
            )
            .overlay(
                VStack{
                    Text(maxY.formattedWithAbbreviations())
                    Spacer()
                    Text(midY.formattedWithAbbreviations())
                    Spacer()
                    Text(minY.formattedWithAbbreviations())
                }, alignment: .leading
            )
            
            HStack {
                Text(start_date.asShortDateString())
                    //.rotationEffect(Angle(degrees: 0))
                Spacer()
                Text(mid_date.asShortDateString())
                    //.rotationEffect(Angle(degrees: 0))
                Spacer()
                Text(updated_date.asShortDateString())
                    //.rotationEffect(Angle(degrees: 0))
            }
        }
        .foregroundColor(Color.theme.secondaryText)
    }
}

struct LineChartOldView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartOldView(coin: dev.coin)
            .frame(width: 300, height: 200)
    }
}
