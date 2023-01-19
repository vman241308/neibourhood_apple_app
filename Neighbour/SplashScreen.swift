//
//  SideMenu.swift
//  SwiftUISideMenuDemo
//
//  Created by Rupesh Chaudhari on 24/04/22.
//

import SwiftUI
import AVKit

struct SplashScreen: View {
    @State private var startAnimation = false
    @State private var duration = 2.0
    var body: some View {
        ZStack{
            Image("splash_screen").resizable().frame(width: 1920, height: 1080, alignment: .center)
            VStack {
                Spacer()
                ZStack {
                    Circle()
                        .stroke(lineWidth: 4)
                        .foregroundColor(.white.opacity(0.5))
                        .frame(width: 150, height: 150, alignment: .center)
                    
                    Circle()
                        .fill(.white)
                        .frame(width: 18, height: 18, alignment: .center)
                        .offset(x: -63)
                        .rotationEffect(.degrees(startAnimation ? 360 : 0))
                        .animation(.easeInOut(duration: duration).repeatForever(autoreverses: false),
                                   value: startAnimation
                        )
                } .onAppear {
                    self.startAnimation.toggle()
                }.padding(.bottom, 100)
            }
        }
    }
}

