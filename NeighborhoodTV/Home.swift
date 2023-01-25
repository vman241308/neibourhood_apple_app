//
//  Home.swift
//  NeighborhoodTV
//
//  Created by fulldev on 1/20/23.
//

import SwiftUI
import AVKit
import UIKit

struct Home: View {
    
    @Binding var currentVideoPlayURL:String
    @Binding var allMediaItems:[MediaListType]
    @Binding var currentGridTitle:String
    @Binding var currentVideoTitle:String
    
    @Binding var isFullScreenBtnFocused:Bool
    @Binding var isFullScreenBtnClicked:Bool
    @Binding var isPreviewVideoStatus:Bool
    
    @FocusState private var nameInfocus: Bool
    
    var body: some View {
        VStack{
            ZStack {
                PreviewVideo(currentVideoPlayURL: $currentVideoPlayURL)
                    .shadow(color: .black, radius: 10)
                    .frame(width: (isFullScreenBtnClicked ? 1920 : 1500), height: (isFullScreenBtnClicked ? 1080 : 850))
                    .onExitCommand(perform: {isFullScreenBtnClicked = false})
                    .focusable(false)
                
                if !self.isFullScreenBtnClicked {
                    HStack {
                        VStack(alignment: .leading){
                            Spacer()
                            Text("Streaming Now - \(currentVideoTitle)")
                                .font(.custom("Arial Round MT Bold", fixedSize: 35))
                            
                            
                            Button(action: {isFullScreenBtnClicked = true}){
                                Text("Watch in FullScreen").font(.custom("Arial Round MT Bold", fixedSize: 25))
                            }
                            .focused($nameInfocus)
                            .onAppear() {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1 ) {
                                    self.nameInfocus = true
                                }
                            }
                        }
                        .opacity((isFullScreenBtnClicked ? 0 : 1))
                        .padding(35)
                        Spacer()
                    }
                }
            }
            .frame(width: 1500, height: 850)
        }
    }
}
