//
//  Home.swift
//  NeighborhoodTV
//
//  Created by fulldev on 1/20/23.
//

import SwiftUI
import AVKit

struct Home: View {
    @Binding var currentVideoPlayURL:String
    @Binding var allMediaItems:[MediaListType]
    @Binding var currentGridTitle:String
    @Binding var currentVideoTitle:String
    
    @Binding var isFullScreenBtnFocused:Bool
    @Binding var isFullScreenFocused:Bool
    var body: some View {
        VStack{
            /* ------------------Player & FullScreen btn --------------------- */
            if !self.isFullScreenFocused {
                ZStack {
                    PreviewVideo(currentVideoPlayURL: $currentVideoPlayURL)
                        .shadow(color: .black, radius: 10)
                        .focusable(false)
                        .frame(width: (isFullScreenBtnFocused ? 1920 : 1700), height: (isFullScreenBtnFocused ? 1080 : 850))
                    
                    
                    HStack {
                        VStack(alignment: .leading){
                            Spacer()
                            Text("Streaming Now - \(currentVideoTitle)")
                                .font(.custom("Arial Round MT Bold", fixedSize: 35))
                                .focusable(false)
                            
                            Text("Watch in FullScreen")
                                .padding(20)
                                .border(.white, width: 5)
                                .scaleEffect(isFullScreenBtnFocused ? 1.1 : 1)
                                .animation(.easeInOut, value: isFullScreenBtnFocused)
                                
                        }
                        .opacity((isFullScreenBtnFocused ? 0 : 1))
                        .padding(35)
                        Spacer()
                    }
                }.position(x: (isFullScreenBtnFocused ? 850 : 860), y: (isFullScreenBtnFocused ? 385 :410))
                    .frame(width: 1700, height: 850)
                    .focusable(false) {newState in isFullScreenBtnFocused = newState}
                    .onLongPressGesture(minimumDuration: 0.001, perform: {isFullScreenBtnFocused = true})
                    .onExitCommand(perform: {
                        isFullScreenBtnFocused = false
                    })
            }
        }
        
    }
}
