//
//  LightBackgroundView.swift
//  Miner_Clean
//
//  Created by Chenxi Wang on 9/7/22.
//

import SwiftUI

struct LightBackgroundView: View {
    
    var body: some View {
        
        /*
        ZStack {
            AngularGradient(colors: [
                Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),Color(#colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)),
                Color(#colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1)),
                Color(#colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)),Color(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)),Color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)),
                Color(#colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)),Color(#colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1)),Color(#colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)),
                Color(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1))],
                            center: UnitPoint(x: 1.1, y: 0.64),
                            angle: .degrees(20))
                LinearGradient(colors: [.white.opacity(0.7), .white.opacity(0)],
                               startPoint: UnitPoint(x: 0.5, y: 0),
                               endPoint: UnitPoint(x: 0.5, y: 1))
                
                Ellipse().fill(Color.green).frame(width: 250, height: 150).offset(x: -100, y: -200).blur(radius: 44).blendMode(.softLight)
                Ellipse().fill(Color.red).frame(width: 400, height: 220).offset(x:190, y: -100)
                    .blur(radius: 44).blendMode(.screen)
                Ellipse().fill(Color.yellow).frame(width: 400, height: 220).offset(x:-190, y: -180)
                    .blur(radius: 44).blendMode(.overlay)
                Ellipse().fill(Color.yellow).frame(width: 260, height: 110).offset(x: 150, y: 220)
                    .blur(radius: 44).blendMode(.hardLight)
                Ellipse().fill(Color.purple).frame(width: 50, height: 25).offset(x: -50, y: 200)
                    .blur(radius: 44).blendMode(.hardLight)
                //Ellipse().fill(Color.pink).frame(width: 300, height: 125).offset(x: -50, y: 400)
                //    .blur(radius: 44).blendMode(.plusLighter)
                Ellipse().fill(Color.white).frame(width: 240, height: 225).offset(x: 125, y: -330)
                    .blur(radius: 44).blendMode(.softLight)
        }
         */
        
        ZStack {
            LinearGradient(colors: [
                Color(#colorLiteral(red: 0.1137254902, green: 0.6078431373, blue: 0.9411764706, alpha: 1)),Color(#colorLiteral(red: 0, green: 0.7882352941, blue: 1, alpha: 1)),
            ], startPoint: .top, endPoint: .bottom)
        }
        
    }
}

struct LightBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        LightBackgroundView()
    }
}
