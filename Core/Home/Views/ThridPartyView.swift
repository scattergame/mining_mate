//
//  ThridPartyView.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 9/9/22.
//

import SwiftUI

struct ThridPartyView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        ZStack {
            if (colorScheme == .light) {
                LightBackgroundView()
                    .ignoresSafeArea(.all, edges: [.top, .trailing])
            } else {
                DarkBackgroundView()
                    .ignoresSafeArea(.all, edges: [.top, .trailing])
            }
            
            //VStack (alignment: .leading, spacing: 5) {
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Data APIs")
                        .font(.title)
                        .fontWeight(.heavy)
                        //.padding()
                    
                    Capsule(style: .circular)
                        .frame(height: 3)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.theme.background.opacity(0.5))
                        .padding(.bottom)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    Text("1. Crypto Market Data are provided by CoinGecko API")
                        .font(.body)
                        .bold()
                    if let website = "https://www.coingecko.com",
                       let url = URL(string: website) {
                        Link("\(website)", destination: url)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color.blue)
                            .font(.footnote,weight: .bold)
                    }
                    Divider()
                        .padding()
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("2. Mining Data (network hashrate, difficulty, block time, and block rewards) are provided by Whattomine API")
                        .font(.body)
                        .bold()
                    if let website = "https://www.whattomine.com/",
                       let url = URL(string: website) {
                        Link("\(website)", destination: url)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color.blue)
                            .font(.footnote,weight: .bold)
                    }
                    Divider()
                        .padding()
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("3. Mining and Hardware (GPU/ASIC) Data are provided by minerstat")
                        .font(.body)
                        .bold()
                    if let website = "https://www.minerstat.com/",
                       let url = URL(string: website) {
                        Link("\(website)", destination: url)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color.blue)
                            .font(.footnote,weight: .bold)
                    }
                    
                    Divider()
                        .padding()
                }
                
                
                VStack (alignment: .leading, spacing: 5) {
                    Text("Third Party Libraries")
                        .font(.title)
                        .fontWeight(.heavy)
                        //.padding()
                    
                    Capsule(style: .circular)
                        .frame(height: 3)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.theme.background.opacity(0.5))
                        .padding(.bottom)
                }
                
                VStack (alignment: .leading, spacing: 5) {
                    
                    Text("1. SwiftUIX")
                        .font(.body)
                        .bold()
                    if let website = "https://github.com/SwiftUIX/SwiftUIX",
                       let url = URL(string: website) {
                        Link("\(website)", destination: url)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color.blue)
                            .font(.footnote,weight: .bold)
                    }
                    VStack (alignment: .leading, spacing: 5) {
                        Text("SwiftUIX/SwiftUIX is licensed under the MIT License")
                        Text("Copyright © 2020 Vatsal Manot" )
                        Text("Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:")
                        Text("The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.")
                        Text("THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.")
                    }
                    .font(.footnote)
                    
                    Divider()
                        .padding()
                }
                
                VStack (alignment: .leading, spacing: 5) {
                    
                    Text("2. LineChartView")
                        .font(.body)
                        .bold()
                    if let website = "https://github.com/Jonathan-Gander/LineChartView",
                       let url = URL(string: website) {
                        Link("\(website)", destination: url)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color.blue)
                            .font(.footnote,weight: .bold)
                    }
                    VStack (alignment: .leading, spacing: 5) {
                        Text("LineChartView is licensed under the MIT License")
                        Text("Copyright © 2020 Vatsal Manot" )
                        Text("Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:")
                        Text("The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.")
                        Text("THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.")
                    }
                    .font(.footnote)
                }
            }
            .padding()
            .navigationTitle("Third Party Information")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ThridPartyView_Previews: PreviewProvider {
    static var previews: some View {
        ThridPartyView()
    }
}
