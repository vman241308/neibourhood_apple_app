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
    @Binding var currentVideoTitle:String
    @Binding var allLocationItems:[LocationModel]
    
    @State var isFullScreenBtnFocused = false
    @State var isFullScreenBtnClicked = false
    @State var isPreviewVideoStatus = false
    @State var isCornerScreenFocused = true
    @State var currentPaginationNum:Int = 0
    @State var isLocationItemFocused:Bool = false
    @State var currentVideoDescription:String = String(describing: UserDefaults.standard.object(forKey: "currentVideoDescription")).components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0]
    
    var body: some View {
        if !self.isLocationItemFocused {
            Location(allLocationItems:$allLocationItems)
                .background(Image("bg_full_2"))
        } else {
            HStack {
                /* ------------------ MainContent --------------------- */
                VStack(alignment: .leading) {
                    if !self.isPreviewVideoStatus {
                        VStack {
                            Home(currentVideoPlayURL:$currentVideoPlayURL, allMediaItems:$allMediaItems, currentVideoTitle:$currentVideoTitle,isFullScreenBtnFocused:$isFullScreenBtnFocused, isFullScreenBtnClicked: $isFullScreenBtnClicked, isPreviewVideoStatus : $isPreviewVideoStatus)
                        }
                    } else if !self.isCornerScreenFocused {
                        VStack {
                            Description(currentVideoPlayURL:$currentVideoPlayURL, allMediaItems:$allMediaItems, isFullScreenBtnFocused:$isFullScreenBtnFocused, isFullScreenBtnClicked: $isFullScreenBtnClicked, isPreviewVideoStatus : $isPreviewVideoStatus, isCornerScreenFocused: $isCornerScreenFocused, currentVideoTitle:$currentVideoTitle, currentVideoDescription: $currentVideoDescription)
                        }
                    }
                    
                    if !isFullScreenBtnClicked  {
                        VStack(alignment: .leading) {
                            Text("\( !self.isCornerScreenFocused ? "Related Videos" : "The Latest")")
                            MediaList(allMediaItems:$allMediaItems, isPreviewVideoStatus : $isPreviewVideoStatus, currentPaginationNum :$currentPaginationNum, isCornerScreenFocused:$isCornerScreenFocused)
                        }
                        .onExitCommand(perform: {!self.isCornerScreenFocused ? (isCornerScreenFocused = true) : (isPreviewVideoStatus = false) })
                        .frame(width: 1500, height: (isPreviewVideoStatus ? isCornerScreenFocused ?  970 : 500 : 200))
                    }
                }
                
            }
            .background(Image("bg_full")
                .resizable()
                .frame(width: 1920, height: 1080, alignment: .center))
        }
    }
}

