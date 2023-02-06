//
//  SplashScreen.swift
//  NeighborhoodTV
//
//  Created by fulldev on 1/20/23.
//

import SwiftUI
import AVKit

struct SplashScreen: View {
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            /*--------------------- splashscreen image----------------------- */
            Image("splashscreen").resizable().frame(width: 1920, height: 1080, alignment: .center)
            /*--------------------- Loading... ----------------------- */
            VStack {
                Spacer()
                Loading()
                .padding(.bottom, 200)
            }
                  
        }
    }
}
