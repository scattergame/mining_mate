//
//  DarkBackgroundView.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 9/7/22.
//

import SwiftUI

struct DarkBackgroundView: View {
    var body: some View {
        
        /*
        ZStack {
            AngularGradient(colors: [
                Color(#colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.5738074183, green: 0.5655357838, blue: 0, alpha: 1)),
                Color(#colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)),
                Color(#colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)),Color(#colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)),Color(#colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)),
                Color(#colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)),Color(#colorLiteral(red: 0.5810584426, green: 0.1285524964, blue: 0.5745313764, alpha: 1)),Color(#colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1)),
                Color(#colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1))],
                            center: UnitPoint(x: 1.1, y: 0.64),
                            angle: .degrees(20))
            
            LinearGradient(colors: [.black.opacity(0.3), .black.opacity(0.5)],
                            startPoint: UnitPoint(x: 0.5, y: 0.5),
                            endPoint: UnitPoint(x: 0.5, y: 1))
            
            Ellipse().fill(Color.green).frame(width: 250, height: 150).offset(x: -100, y: -200).blur(radius: 44).blendMode(.softLight)
            Ellipse().fill(Color(#colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1))).frame(width: 400, height: 220).offset(x:190, y: -100)
                .blur(radius: 44).blendMode(.screen)
            Ellipse().fill(Color.yellow).frame(width: 400, height: 220).offset(x:-190, y: -180)
                .blur(radius: 44).blendMode(.overlay)
            Ellipse().fill(Color.yellow).frame(width: 260, height: 110).offset(x: 150, y: 220)
                .blur(radius: 44).blendMode(.hardLight)
            Ellipse().fill(Color.purple).frame(width: 50, height: 25).offset(x: -50, y: 200)
                .blur(radius: 44).blendMode(.hardLight)
            //Ellipse().fill(Color.pink).frame(width: 300, height: 125).offset(x: -50, y: 400)
            //   .blur(radius: 44).blendMode(.plusLighter)
            Ellipse().fill(Color.white).frame(width: 240, height: 225).offset(x: 125, y: -330)
                .blur(radius: 44).blendMode(.softLight)
            
        }
         */
        ZStack {
            LinearGradient(colors: [
                Color(#colorLiteral(red: 0.3921568627, green: 0.2549019608, blue: 0.6470588235, alpha: 1)),Color(#colorLiteral(red: 0.3921568627, green: 0.2549019608, blue: 0.6470588235, alpha: 1)),
            ], startPoint: .top, endPoint: .bottom)
        }
    }
}

struct DarkBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        DarkBackgroundView()
    }
}
