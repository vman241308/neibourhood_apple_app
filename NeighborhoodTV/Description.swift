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
    @State var isVideoSectionFocused = false
    
    @FocusState private var nameInfocused: Bool
    
    var body: some View {
        VStack{
            HStack {
                if !self.isFullScreenBtnClicked {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                VStack {
                                    Text("Streaming Now - \(currentVideoTitle)")
                                        .font(.custom("Arial Round MT Bold", fixedSize: 35))
                                    
                                    Text("\(currentVideoDescription)")
                                        .font(.custom("Arial Round MT Bold", fixedSize: 25))
                                }.focusable(true) {newState in isVideoSectionFocused = newState }
                                    .onLongPressGesture(minimumDuration: 0.001, perform: {isFullScreenBtnClicked = true})
                                    .onExitCommand(perform: {isFullScreenBtnClicked ? (isFullScreenBtnClicked = false ): (isCornerScreenFocused = true)})

                                
                              
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
                                    .onExitCommand(perform: {isFullScreenBtnClicked ? (isFullScreenBtnClicked = false ): (isCornerScreenFocused = true)})
                            }
                            Spacer()
                        }.padding(.top, 130)
                        Spacer()
                    }.frame(width: 950, height: 505)
                }
                
                VStack {
                    PreviewVideo(currentVideoPlayURL: $currentVideoPlayURL)
                        .shadow(color: .black, radius: 10)
                        .frame(width: (isFullScreenBtnClicked ? 1920 : 900), height: (isFullScreenBtnClicked ? 1080 : 505))
                        .focusable(true) {newState in isVideoSectionFocused = newState }
                        .onLongPressGesture(minimumDuration: 0.001, perform: {isFullScreenBtnClicked = true})
                        .onExitCommand(perform: {isFullScreenBtnClicked ? (isFullScreenBtnClicked = false ): (isCornerScreenFocused = true)})
                    Spacer()
                } .frame(width: 550, height: 505)
            }
            .frame(width: 1500, height: 505)
            .onExitCommand(perform: {isFullScreenBtnClicked ? (isFullScreenBtnClicked = false ): (isCornerScreenFocused = true)})
            
        }
    }
}
