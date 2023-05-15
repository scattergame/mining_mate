//
//  LineGraphView.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 9/8/22.
//

import SwiftUI
import LineChartView

struct LineGraphView: View {
    
    let data: [Double]
    let updatedDate: Date
    let lineColor: Color
    var chartData: [LineChartData] = []
    
    init(coin: CoinModel) {
        data = coin.sparkline_in_7d?.price ?? []
        updatedDate = Date(coinGeckoString: coin.last_updated ?? "")
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        
        self.lineColor = priceChange >= 0 ? Color.theme.green : Color.theme.red
        self.chartData = generate7dChartData(endDateTime: updatedDate,
                                             data: data,
                                             timeinterval: 3600)
        
    }
    
    var body: some View {
        VStack {
            let chartParameters = LineChartParameters(data: chartData,
                                                      labelsAlignment: .right,
                                                      dataPrefix : "$",
                                                      indicatorPointSize: 10,
                                                      lineColor: lineColor)
            LineChartView(lineChartParameters: chartParameters)
        }
    }
    
    
    private func generate7dChartData(endDateTime: Date, data: [Double], timeinterval: Int) -> [LineChartData] {
        var returnChartData: [LineChartData] = []
        let nPoint = data.count
        for index in stride(from: nPoint-1, through: 0, by: -1) {
            let datetime = endDateTime.addingTimeInterval(TimeInterval(-timeinterval*index))
            //returnDateTimes.append(datetime)
            let chartdata: LineChartData = LineChartData(data[nPoint-index-1], timestamp: datetime, label: datetime.asShortDateTimeString())
            returnChartData.append(chartdata)
        }
        return returnChartData
    }    
}

struct LineGraphView_Previews: PreviewProvider {
    static var previews: some View {
        LineGraphView(coin: dev.coin)
    }
}
