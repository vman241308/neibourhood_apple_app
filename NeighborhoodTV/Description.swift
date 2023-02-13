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
    @Binding var isCollapseSideBar:Bool
    @Binding var isFirstVideo:Bool
    
    @FocusState private var nameInfocused: Bool
    let pub_default_focus = NotificationCenter.default.publisher(for: NSNotification.Name.locationDefaultFocus)
    let puh_fullScreen = NotificationCenter.default.publisher(for: Notification.Name.puh_fullScreen)
    
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
                                    .focusable(isCollapseSideBar ? false : true) {newState in isVideoSectionFocused = newState }
                                    .scaleEffect(isVideoSectionFocused ? 1.1 : 1)
                                    .onLongPressGesture(minimumDuration: 0.001, perform: {onFullScreenBtn()})
                                    .focused($nameInfocused)
                                    .onAppear() {
                                        DispatchQueue.main.asyncAfter(deadline: .now() ) {
                                                self.nameInfocused = true
                                        }
                                    }
                                    .onReceive(pub_default_focus) { (out_location_default) in
                                        guard let _out_location_default = out_location_default.object as? Bool else {
                                            print("Invalid URL")
                                            return
                                        }
                                        if _out_location_default {
                                                self.nameInfocused = true
                                        }
                                    }
                            }
                            Spacer()
                        }.padding(.top, 130)
                        Spacer()
                    }.frame(width: 950, height: 505)
                        .onExitCommand(perform: {isFullScreenBtnClicked ? onVideoBackButton() : onExitButton()})
                }
                
                VStack {
                    PreviewVideo(currentVideoPlayURL: $currentVideoPlayURL, isCornerScreenFocused:$isCornerScreenFocused, isFirstVideo:$isFirstVideo)
                        .shadow(color: .black, radius: 10)
                        .frame(width: (isFullScreenBtnClicked ? 1920 : 900), height: (isFullScreenBtnClicked ? 1080 : 505))
                        .focusable(false)
                        .onReceive(puh_fullScreen) { (outFull) in
                            guard let _outFull = outFull.object as? Bool else {
                                print("Invalid URL")
                                return
                            }
                            isFullScreenBtnClicked = _outFull
                        }
                    
                    
                    Spacer()
                } .frame(width: 550, height: 505)
                    .padding(.top , (!isFullScreenBtnClicked ? 0 : 550) )
                    .onExitCommand(perform: {isFullScreenBtnClicked ? onVideoBackButton() : onExitButton()})
            }
            .frame(width: 1500, height: 505)
            .onExitCommand(perform: {isFullScreenBtnClicked ? onVideoBackButton() : onExitButton()})
            
        }
    }
    
    func onFullScreenBtn() {
        isFullScreenBtnClicked = true
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .onFullBtnAction, object: true)
        }
    }
    
    func onExitButton() {
        
        guard let _previousItemIndex = UserDefaults.standard.object(forKey: "previousItemIndex") as? Int else {
            print("Invalid URL")
            return
        }
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .previousItemIndex, object: _previousItemIndex)
        }
        
        isCornerScreenFocused = true
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .pub_player_stop, object: true)
        }
    }
    
    func onVideoBackButton() {
        isFullScreenBtnClicked = false
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .onFullBtnAction, object: isFullScreenBtnClicked)
        }
    }
}
