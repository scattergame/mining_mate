//
//  SwithBarView.swift
//  MiningMate
//
//  Created by Chenxi Wang on 8/9/22.
//

import SwiftUI

struct SwithBarView: View {
    
    //@State private var preselectedIndex = 0
    @Binding var preselectedIndex: Int
    @Binding var selectionText: [String] // = ["All Coins", "Watch List"]
        
    init(preselectedIndex: Binding<Int>, selectionText: Binding<[String]>) {
        self._preselectedIndex = preselectedIndex
        self._selectionText = selectionText
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.theme.accent)
        UISegmentedControl.appearance().backgroundColor =
            UIColor(Color.theme.secondaryText.opacity(0.3))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.theme.background)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color.theme.secondaryText)], for: .normal)
    }
    
    var body: some View {
        VStack {
            Picker("You Selection", selection: self.$preselectedIndex.animation()) {
                ForEach(selectionText.indices, id: \.self) { index in
                    Text(selectionText[index])
                        .tag(index)
                        .foregroundColor(Color.theme.accent)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding()
    }
}


struct SwithBarView_Previews: PreviewProvider {
        
    static var previews: some View {
        Group {
            SwithBarView(preselectedIndex: .constant(0),
                         selectionText: .constant(["All Coins", "Watch List"]))
                .previewLayout(.sizeThatFits)
            SwithBarView(preselectedIndex: .constant(1),
                         selectionText: .constant(["Mineable Coins", "Watch List"]))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            
            SwithBarView(preselectedIndex: .constant(1),
                         selectionText: .constant(["AMD", "NVidia", "ASIC"]))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
