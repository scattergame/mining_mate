//
//  CircleButtonView.swift
//  MiningMate
//
//  Created by Chenxi Wang on 8/6/22.
//

import SwiftUI
import SwiftUIX

struct CircleButtonView: View {
    
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(Color.theme.accent)
            .frame(width: 30, height: 30)
            .background(
                VisualEffectBlurView(blurStyle: .systemUltraThinMaterial)
            )
            .mask({
                Circle()
            })
            .overlay(Circle().stroke(lineWidth: 1).fill(Color.theme.accent).blur(radius: 0.5))
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
            .padding()
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonView(iconName: "info")
            .padding()
            .previewLayout(.sizeThatFits)
            .colorScheme(.dark)
    }
}
