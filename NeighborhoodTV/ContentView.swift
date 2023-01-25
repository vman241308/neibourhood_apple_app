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
    @State var isFullScreenBtnClicked = false
    @State var isPreviewVideoStatus = false
    @State var isCornerScreenFocused = true
    @State var currentPaginationNum:Int = 1
    @State var isLocationItemFocused:Bool = false
    
    var body: some View {
        HStack {
            
            /* ------------------ MainContent --------------------- */
            VStack(alignment: .leading) {
               
                
                if !self.isPreviewVideoStatus {
                    VStack {
                        Home(currentVideoPlayURL:$currentVideoPlayURL, allMediaItems:$allMediaItems, currentGridTitle:$currentGridTitle, currentVideoTitle:$currentVideoTitle,isFullScreenBtnFocused:$isFullScreenBtnFocused, isFullScreenBtnClicked: $isFullScreenBtnClicked, isPreviewVideoStatus : $isPreviewVideoStatus)
                    }
                }
                
                if !isFullScreenBtnClicked {
                    VStack(alignment: .leading) {
                        Text("\(currentGridTitle)")
                        MediaList(allMediaItems:$allMediaItems, isPreviewVideoStatus : $isPreviewVideoStatus, currentPaginationNum :$currentPaginationNum, isCornerScreenFocused:$isCornerScreenFocused)
                        
                    }
                    .frame(width: 1700, height: (isPreviewVideoStatus ? 900 : 200))
                }
            }
            
        }
        .background(Image("bg_full")
            .resizable()
            .frame(width: 1920, height: 1080, alignment: .center))
    }
}
