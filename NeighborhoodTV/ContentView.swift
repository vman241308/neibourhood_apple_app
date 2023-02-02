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
    @Binding var currentVideoTitle:String
    
    @State var isFullScreenBtnClicked = false
    @State var isPreviewVideoStatus = false
    @State var isCornerScreenFocused = true
    @State var isTitleFocused = false
    @State var isVideoSectionFocused = false
    //    @State var descriptionPreviewVideo: PreviewVideo = PreviewVideo(currentVideoPlayURL: )
    
    @State var isLocationItemFocused:Int = 0
    @State var currentVideoDescription:String =  (UserDefaults.standard.object(forKey: "currentVideoDescription") as? String ?? "")
    @State private var isPresentingAlert: Bool = false
    
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
                            Home(currentVideoPlayURL:$currentVideoPlayURL, currentVideoTitle:$currentVideoTitle, isFullScreenBtnClicked: $isFullScreenBtnClicked, isPreviewVideoStatus:$isPreviewVideoStatus)
                        }
                    } else
                    if !self.isCornerScreenFocused {
                        VStack {
                            Description(currentVideoPlayURL:$currentVideoPlayURL, isFullScreenBtnClicked: $isFullScreenBtnClicked, isCornerScreenFocused: $isCornerScreenFocused, currentVideoTitle:$currentVideoTitle, currentVideoDescription: $currentVideoDescription, isVideoSectionFocused:$isVideoSectionFocused, isPreviewVideoStatus:$isPreviewVideoStatus)
                        }
                    }
                    
                    if !isFullScreenBtnClicked  {
                        VStack(alignment: .leading) {
                            Text("\( !self.isCornerScreenFocused ? "Related Videos" : "The Latest")")
                            
                            if isCornerScreenFocused {
                                Divider()
                                    .focusable(isPreviewVideoStatus ? isVideoSectionFocused ? false : true : false) {newState in isTitleFocused = newState; onUpButtonToHome() }
                            }
                            else {
                                Divider()
                                    .focusable( !isVideoSectionFocused ? true : false ) { newState in isTitleFocused = newState ; isVideoSectionFocused = true  }
                            }
                            MediaList(allMediaItems:$allMediaItems, isPreviewVideoStatus : $isPreviewVideoStatus, isCornerScreenFocused:$isCornerScreenFocused, currentVideoTitle:$currentVideoTitle, currentVideoDescription:$currentVideoDescription, currentVideoPlayURL:$currentVideoPlayURL, isVideoSectionFocused:$isVideoSectionFocused, isPresentingAlert:$isPresentingAlert)
                        }
                        .onExitCommand(perform: {
                            if !self.isCornerScreenFocused {
                                isVideoSectionFocused = true
                                DispatchQueue.main.async {
                                    NotificationCenter.default.post(name: .videoSection, object: isVideoSectionFocused)
                                }
                            } else { onUpButtonToHome() }
                        })
                        .frame(width: 1500, height: (isPreviewVideoStatus ? isCornerScreenFocused ?  960 : 500 : 200))
                    }
                }
            }
            .alert("Try again later", isPresented: $isPresentingAlert){}
            .background(Image("bg_full")
                .resizable()
                .frame(width: 1920, height: 1080, alignment: .center))
        }
    }
    
    func onUpButtonToHome () {
        guard let _originalVideoPlayURL = UserDefaults.standard.object(forKey: "original_uri") as? String else {
            print("Invalid URL")
            return
        }
        
        guard let _currentVideoTitle = UserDefaults.standard.object(forKey: "original_title") as? String else {
            print("Invalid Title")
            return
        }
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .dataDidFlow, object: _originalVideoPlayURL)
        }
        
        currentVideoPlayURL = _originalVideoPlayURL
        currentVideoTitle = _currentVideoTitle
        isPreviewVideoStatus = false
    }
}

