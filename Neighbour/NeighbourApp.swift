//
//  NeighbourApp.swift
//  Neighbour
//
//  Created by fulldev on 1/14/23.
//

import SwiftUI

@main
struct NeighbourApp: App {
    @State var isActive:Bool = false
    @State private var animateAngle = 0.0
    var body: some Scene {
        WindowGroup {
            VStack {
                if self.isActive {
                    ContentView()
                } else {
                    ZStack {
                        SplashScreen()
                            .rotation3DEffect(Angle(degrees: animateAngle), axis: (x: 0.0, y:1.0, z:0.0))
                        .animation(Animation.linear(duration: 1), value: animateAngle)
                            .onAppear(perform: {
                                getToken()
                            })
                    }
                    
                }
            }
            .onAppear {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation {
                        onFlip()
                    }
                }
            }
        }
    }
    
    func onFlip() {
        animateAngle -= 180.0
        self.isActive = true
    }
}
