//
//  testView.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 9/8/22.
//

import SwiftUI
import SwiftUICharts

struct testView: View {
    
    var demoData: [Double] = [8, 2, 4, 6, 12, 9, 2]
    
    var body: some View {
        VStack{
            MultiLineChartView(data: [([8,32,11,23,40,28], GradientColors.green), ([90,99,78,111,70,60,77], GradientColors.purple), ([34,56,72,38,43,100,50], GradientColors.orngPink)], title: "Title")
        }
        .frame(height: 150)
    }
}

struct testView_Previews: PreviewProvider {
    static var previews: some View {
        testView()
    }
}
