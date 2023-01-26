//
//  Home.swift
//  NeighborhoodTV
//
//  Created by fulldev on 1/20/23.
//

import SwiftUI
import AVKit
import UIKit

struct Description: View {
    
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
            HStack {
                if !self.isFullScreenBtnClicked {
                    VStack {
                        HStack {
                            VStack {
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
                            Spacer()
                        }.padding(.top, 130)
                        Spacer()
                    }.frame(width: 1050, height: 840)
                }
                
                
                
                VStack {
                    PreviewVideo(currentVideoPlayURL: $currentVideoPlayURL)
                        .shadow(color: .black, radius: 10)
                        .frame(width: (isFullScreenBtnClicked ? 1920 : 800), height: (isFullScreenBtnClicked ? 1080 : 450))
                        .onExitCommand(perform: {isFullScreenBtnClicked = false})
                        .focusable(false)
                    
                    Spacer()
                } .frame(width: 450, height: 840)
                
                
            }
            .frame(width: 1500, height: 840)
            //            .onExitCommand(perform: {isCornerScreenFocused})
            
        }
    }
}
