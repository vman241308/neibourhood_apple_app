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
    
    @FocusState private var nameInfocus: Bool
    
    var body: some View {
        VStack{
            HStack {
                if !self.isFullScreenBtnClicked {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Streaming Now - \(currentVideoTitle)")
                                    .font(.custom("Arial Round MT Bold", fixedSize: 35))
                                
                                Text("\(currentVideoDescription)")
                                    .font(.custom("Arial Round MT Bold", fixedSize: 25))
                                
                                
                                Button(action: {isFullScreenBtnClicked = true}){
                                    Text("Watch in FullScreen").font(.custom("Arial Round MT Bold", fixedSize: 25))
                                }
                                .focused($nameInfocus)
                                .onAppear() {
                                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                                        self.nameInfocus = true
                                    }
                                }
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
                        .onExitCommand(perform: {isFullScreenBtnClicked = false})
                        .focusable(false)
                    
                    Spacer()
                } .frame(width: 550, height: 505)
            }
            .frame(width: 1500, height: 505)
            .onExitCommand(perform: {isCornerScreenFocused = true})
            
        }
    }
}
