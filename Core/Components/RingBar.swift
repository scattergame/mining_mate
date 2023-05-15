//
//  RingBar.swift
//  MiningMate
//
//  Created by Chenxi Wang on 8/25/22.
//

import SwiftUI

struct RingBar: View {
    
    var progress: Double
    
    var ringColor: Color {
        if (progress>=0.8) {
            return Color.green
        } else if (progress>=0.6) {
            return Color.yellow
        } else if (progress>=0.4) {
            return Color.orange
        } else if (progress>=0.2) {
            return Color.pink
        }
        return Color.red
    }
        
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 3)
                .opacity(0.3)
                .foregroundColor(Color.gray)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .foregroundColor(ringColor)
                .rotationEffect(Angle(degrees: 270.0))
            Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                .font(.caption)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .frame(width: 35, height: 35)
        .padding(.trailing, 5)
    }
}

struct RingBar_Previews: PreviewProvider {
    static var previews: some View {
        RingBar(progress: 0.3)
    }
}
