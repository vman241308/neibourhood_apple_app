//
//  DescriptionVideo.swift
//  NeighborhoodTV
//
//  Created by fulldev on 2/15/23.
//

import Foundation
import SwiftUI
import AVKit

struct DescriptionVideo: View {
    @Binding var currentVideoPlayURL:String
    @Binding var isCornerScreenFocused:Bool
    @State private var player : AVQueuePlayer?
    @State private var videoLooper: AVPlayerLooper?
    @State var isFullScreenModeFlag:Bool = false
    @State var currentthumbnailUrl:String = (UserDefaults.standard.object(forKey: "currentthumbnailUrl") as? String)!
    @State var isAppear:Bool = false
    
    let publisher = NotificationCenter.default.publisher(for: NSNotification.Name.dataDidFlow)
    let pub_des_player_stop = NotificationCenter.default.publisher(for: NSNotification.Name.pub_des_player_stop)
    
    var body: some View {
        VideoPlayer(player: player)
                            .overlay(AsyncImage(url: URL(string: currentthumbnailUrl), content: {image in
//            .overlay(AsyncImage(url: URL(string: "file:///Users/fulldev/Documents/temp/AppleTV-app/NeighborhoodTV/Assets.xcassets/splashscreen.jpg"), content: {image in
                image.resizable()
                    .scaledToFill()
            }, placeholder: {progressView()}).opacity(isFullScreenModeFlag ? 1: 0))
            .focusable(false)
            .onAppear() {
                if !isAppear {
                    isFullScreenModeFlag = false
                    let templateItem = AVPlayerItem(url: URL(string: currentVideoPlayURL )!)
                    player = AVQueuePlayer(playerItem: templateItem)
                    videoLooper = AVPlayerLooper(player: player!, templateItem: templateItem)
                    videoLooper?.disableLooping()
                    
                                        player!.play()
                    isAppear = true
                    print("-------->>>>>>Play1", currentVideoPlayURL)
                    
                    guard let _currentthumbnailUrl = UserDefaults.standard.object(forKey: "currentthumbnailUrl") as? String else {
                        print("Invalid access token")
                        return
                    }
                    currentthumbnailUrl = _currentthumbnailUrl
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil, using: self.didPlayToEnd)
                }
            }
            .onReceive(publisher) { (output) in
                if isAppear {
                    isFullScreenModeFlag = false
                    guard let _objURL = output.object as? String else {
                        print("Invalid URL")
                        return
                    }
                    let templateItem = AVPlayerItem(url: URL(string: currentVideoPlayURL )!)
                    player = AVQueuePlayer(playerItem: templateItem)
                    videoLooper = AVPlayerLooper(player: player!, templateItem: templateItem)
                    videoLooper?.disableLooping()
                                        player!.play()
                    print("-------->>>>>>Play2", currentVideoPlayURL)
                    
                    guard let _currentthumbnailUrl = UserDefaults.standard.object(forKey: "currentthumbnailUrl") as? String else {
                        print("Invalid access token")
                        return
                    }
                    currentthumbnailUrl = _currentthumbnailUrl
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil, using: self.didPlayToEnd)
                }
            }
            .onReceive(pub_des_player_stop) {(oPub_des_player_stop) in
                guard let _oPub_des_player_stop = oPub_des_player_stop.object as? Bool else {
                    print("Invalid URL")
                    return
                }
                if _oPub_des_player_stop {
                    print("-------->>>>>Pause2")
                    player!.pause()
                    player!.seek(to: .zero)
                }
            }
    }
    
    func progressView() -> some View {
        Image(systemName: "")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .foregroundColor(.gray)
    }
    
    func didPlayToEnd(_ notification: Notification) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .puh_fullScreen, object: false)
        }
        player!.pause()
        player!.seek(to: .zero)
    }
}



