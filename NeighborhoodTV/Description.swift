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
    @Binding var isFullScreenBtnClicked:Bool
    @Binding var isCornerScreenFocused:Bool
    @Binding var currentVideoTitle:String
    @Binding var currentVideoDescription:String
    @Binding var isVideoSectionFocused:Bool
    @Binding var isPreviewVideoStatus:Bool
    
    @FocusState private var nameInfocused: Bool
    
    var body: some View {
        VStack{
            HStack {
                if !self.isFullScreenBtnClicked {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading) {
                                    Text("Streaming Now - \(currentVideoTitle)")
                                        .font(.custom("Arial Round MT Bold", fixedSize: 35))
                                    
                                    Text("\(currentVideoDescription)")
                                        .font(.custom("Arial Round MT Bold", fixedSize: 25))
                                }.focusable(false)
                              
                                    Text("Watch in FullScreen").font(.custom("Arial Round MT Bold", fixedSize: 25))
                                    .padding(20)
                                    .padding(.horizontal, 20)
                                    .background(isVideoSectionFocused ? .white : .gray)
                                    .border(isVideoSectionFocused ? .white : .gray)
                                    .foregroundColor(isVideoSectionFocused ? .black : .white)
                                    .cornerRadius(10)
                                    .focusable(true) {newState in isVideoSectionFocused = newState }
                                    .scaleEffect(isVideoSectionFocused ? 1.1 : 1)
                                    .onLongPressGesture(minimumDuration: 0.001, perform: {isFullScreenBtnClicked = true})
                                    .focused($nameInfocused)
                                    .onAppear() {
                                        DispatchQueue.main.asyncAfter(deadline: .now() ) {
                                                self.nameInfocused = true
                                        }
                                    }
                            }
                            Spacer()
                        }.padding(.top, 130)
                        Spacer()
                    }.frame(width: 950, height: 505)
                        .onExitCommand(perform: {isFullScreenBtnClicked ? (isFullScreenBtnClicked = false ): (isCornerScreenFocused = true)})
                }
                
                VStack {
                    PreviewVideo(currentVideoPlayURL: $currentVideoPlayURL)
                        .shadow(color: .black, radius: 10)
                        .frame(width: (isFullScreenBtnClicked ? 1920 : 900), height: (isFullScreenBtnClicked ? 1080 : 505))
                        .focusable(false)
                    Spacer()
                } .frame(width: 550, height: 505)
                    .onExitCommand(perform: {isFullScreenBtnClicked ? (isFullScreenBtnClicked = false ): (isCornerScreenFocused = true)})
                    
            }
            .frame(width: 1500, height: 505)
            .onExitCommand(perform: {isFullScreenBtnClicked ? (isFullScreenBtnClicked = false ): (isCornerScreenFocused = true)})
            
        }
    }
}
