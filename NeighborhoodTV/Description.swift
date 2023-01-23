//
//  Description.swift
//  NeighborhoodTV
//
//  Created by fulldev on 1/20/23.
//


import SwiftUI
import AVKit

struct Description: View {
    @Binding var currentVideoPlayURL:String
    @Binding var allMediaItems:[MediaListType]
    @Binding var currentGridTitle:String
    @Binding var currentVideoTitle:String
    
    @Binding var isFullScreenBtnFocused:Bool
    @Binding var isCornerScreenFocused:Bool
    var body: some View {
        VStack{
            /* ------------------Player & FullScreen btn --------------------- */
            HStack {
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
                
                PreviewVideo(currentVideoPlayURL: $currentVideoPlayURL)
                    .shadow(color: .black, radius: 10)
                    .focusable(false)
                    .frame(width: (isFullScreenBtnFocused ? 1920 : 1100), height: (isFullScreenBtnFocused ? 1080 : 650))
            }
            .position(x: (isFullScreenBtnFocused ? 850 : 925), y: (isFullScreenBtnFocused ? 385 :265))
            .frame(width: 1700, height: 650)
            .focusable(false) {newState in isFullScreenBtnFocused = newState}
            .onLongPressGesture(minimumDuration: 0.001, perform: {isFullScreenBtnFocused = true})
            .onExitCommand(perform: {
                isCornerScreenFocused = true
            })
            
        }
        
    }
}
