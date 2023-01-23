//
//  ContentView.swift
//  NeighborhoodTV
//
//  Created by fulldev on 1/20/23.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @Binding var currentVideoPlayURL:String
    @Binding var allMediaItems:[MediaListType]
    @Binding var currentGridTitle:String
    @Binding var currentVideoTitle:String
    @Binding var allLocationItems:[LocationModel]
    
    @State var isFullScreenBtnFocused = false
    @State var isFullScreenFocused = false
    @State var isCornerScreenFocused = true
    @State var currentPaginationNum:Int = 1
    @State var isLocationItemFocused:Bool = false
    
    var body: some View {
        HStack {
            /* ------------------ Sidebar --------------------- */
//            if !isFullScreenBtnFocused {
//                VStack {
//                    NavigationView {
//                        Image("location")
//                            .resizable()
//                            .frame(width: 70, height: 70)
//                            .position(x: -40, y: 80)
//
//                        Image(systemName: "icon")
//                            .resizable()
//                            .frame(width: 70, height: -70)
//                            .position(x: -40, y: 100)
//                    }
//
//                }.frame(width: 10)
//                .background(.black)
//                .opacity(0.3)
//            }
            
            
            /* ------------------ MainContent --------------------- */
            VStack(alignment: .leading) {
//                if !self.isLocationItemFocused {
//                    Location(allLocationItems: $allLocationItems, isLocationItemFocused:$isLocationItemFocused)
//                } else {
                    if !self.isCornerScreenFocused && self.isFullScreenFocused {
                        Description(currentVideoPlayURL: $currentVideoPlayURL, allMediaItems: $allMediaItems, currentGridTitle: $currentGridTitle, currentVideoTitle: $currentVideoTitle, isFullScreenBtnFocused: $isFullScreenBtnFocused, isCornerScreenFocused: $isCornerScreenFocused)
                    } else {
                        VStack {
                            Image("logo")
                                .resizable()
                                .position(x : 200, y: 15)
                        }.frame(width: 300, height: 60, alignment: .leading)
                        Home(currentVideoPlayURL:$currentVideoPlayURL, allMediaItems:$allMediaItems, currentGridTitle:$currentGridTitle, currentVideoTitle:$currentVideoTitle,isFullScreenBtnFocused:$isFullScreenBtnFocused, isFullScreenFocused : $isFullScreenFocused)
                    }

                    if !isFullScreenBtnFocused {
                            VStack(alignment: .leading) {
                                Text("\(currentGridTitle)")
                                    .padding(5)
                                MediaList(allMediaItems:$allMediaItems, isFullScreenFocused : $isFullScreenFocused, currentPaginationNum :$currentPaginationNum, isCornerScreenFocused:$isCornerScreenFocused)
                                
                            }
                            .frame(width: 1700, height: (isFullScreenFocused ? 870 : 50))
                            .onExitCommand(perform: {isFullScreenFocused = false})
                        
                    }
                }
                
//            }
           
        }.background(Image("bg_full")
            .resizable()
            .frame(width: 1920, height: 1080, alignment: .center))
    }
}
