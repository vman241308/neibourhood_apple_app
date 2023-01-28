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
    @Binding var allLocationItems:[LocationModel]
    
    @State var isFullScreenBtnClicked = false
    @State var isPreviewVideoStatus = false
    @State var isCornerScreenFocused = true

    @State var isLocationItemFocused:Int = 0

    @State var currentVideoTitle:String =  (UserDefaults.standard.object(forKey: "currentVideoTitle") as? String ?? "")
    @State var currentVideoDescription:String =  (UserDefaults.standard.object(forKey: "currentVideoDescription") as? String ?? "")
    
    var body: some View {
        
        switch self.isLocationItemFocused {
        case 1:
            Location(allLocationItems:$allLocationItems)
                .background(Image("bg_full_2"))
        default:
            HStack {
                /* ------------------ MainContent --------------------- */
                VStack(alignment: .leading) {
                    if !self.isPreviewVideoStatus {
                        VStack {
                            Home(currentVideoPlayURL:$currentVideoPlayURL, currentVideoTitle:$currentVideoTitle, isFullScreenBtnClicked: $isFullScreenBtnClicked)
                        }
                    } else if !self.isCornerScreenFocused {
                        VStack {
                            Description(currentVideoPlayURL:$currentVideoPlayURL,isFullScreenBtnClicked: $isFullScreenBtnClicked, isCornerScreenFocused: $isCornerScreenFocused, currentVideoTitle:$currentVideoTitle, currentVideoDescription: $currentVideoDescription)
                        }
                    }
                    
                    if !isFullScreenBtnClicked  {
                        VStack(alignment: .leading) {
                            Text("\( !self.isCornerScreenFocused ? "Related Videos" : "The Latest")")
                            MediaList(allMediaItems:$allMediaItems, isPreviewVideoStatus : $isPreviewVideoStatus, isCornerScreenFocused:$isCornerScreenFocused, currentVideoTitle:$currentVideoTitle, currentVideoDescription:$currentVideoDescription, currentVideoPlayURL:$currentVideoPlayURL)
                        }
                        .onExitCommand(perform: {
                            if !self.isCornerScreenFocused {
                                isCornerScreenFocused = true
                            } else {
                                isPreviewVideoStatus = false
                                guard let _originalVideoPlayURL = UserDefaults.standard.object(forKey: "original_uri") as? String else {
                                    print("Invalid URL")
                                    return
                                }
                                currentVideoPlayURL = _originalVideoPlayURL
                            }
                        })
                        .frame(width: 1500, height: (isPreviewVideoStatus ? isCornerScreenFocused ?  970 : 500 : 200))
                    }
                }
                
            }
            .background(Image("bg_full")
                .resizable()
                .frame(width: 1920, height: 1080, alignment: .center))
            .onExitCommand(perform: {isLocationItemFocused = 1})

        }
    }
}

