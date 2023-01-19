//
//  ContentView.swift
//  SwiftUISideMenuDemo
//
//  Created by Rupesh Chaudhari on 24/04/22.
//

import SwiftUI
import AVKit
import TVUIKit

struct ContentView: View {
    @Namespace private var animationPreviewVideo
    @State private var isSideBarOpened = false
    @State private var isFocusedFullButton = false
    @State private var isFullScreenFocused = false
    @State var videoPreviewActive =  false
    @State var currentPagination : Int = 1
    
    var body: some View {
        HStack {
            //            Image("bg_full")
            //            SideMenu(isSidebarVisible: $isSideBarOpened)
            Text("sidebar").foregroundColor(.white)
            Divider().background(.white)
            /* ------------------sidebar----------------- */
            
            VStack {
                if !self.videoPreviewActive {
                    HStack {
                        ZStack {
                            Preview()
                                .padding(.top, 15)
                                .position(x: (isFullScreenFocused ? 850: 800), y: (isFullScreenFocused ? 620 : 380))
                                .frame(width: (isFullScreenFocused ? 1920 : 1600), height: (isFullScreenFocused ? 1195 : 800))
                                .focusable(false)
                            
                            
                            VStack {
                                Spacer()
                                HStack {
                                    VStack (alignment: .leading) {
                                        Text("Streaming Now - Georgia Statewide")
                                            .padding(.leading, 30)
                                            .padding(.bottom, 15)
                                            .font(.custom("Arial Round MT Bold", fixedSize: 30))
                                            .focusable(false)
                                        Text("Watch in FullScreen")
                                            .padding(20)
                                            .font(.custom("Arial Round MT Bold", fixedSize: 25))
                                            .foregroundColor(.black)
                                            .border(.white)
                                            .background(.white)
                                            .clipShape(Capsule())
                                            .padding(.leading, 30)
                                            .padding(.bottom, 40)
                                            .scaleEffect(isFocusedFullButton ? 1.2 : 1)
                                            .focusable(true) { newState in isFocusedFullButton = newState }
                                            .animation(.easeInOut, value: isFocusedFullButton)
                                            .onLongPressGesture(minimumDuration: 0.01, perform: {onFullScreen()})
                                    }
                                    Spacer()
                                }
                                .frame(width: 1600)
                                .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom))
                                .opacity((isFullScreenFocused ? 0 : 1))
                            }
                            
                        }
                    }
                }
                
                VStack {
                    HStack {
                        Text("The Latest")
                            .foregroundColor(.white)
                            .font(.custom("Arial Round MT Bold", fixedSize: 30))
                        Spacer()
                    }
                    
                    HStack(alignment: .center) {
                        MediaList(medialListFocused: $videoPreviewActive, currentPagination: $currentPagination)
                           
                    }
                } .position(x:800, y:480)
                
            }
        }
        .background(Image("bg_full")
            .resizable()
            .frame(width: 1920, height: 1080, alignment: .center))
    }
    
    func onFullScreen() {
        isFullScreenFocused.toggle()
    }
}
