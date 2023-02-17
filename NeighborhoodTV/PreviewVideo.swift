//
//  PreviewVideo.swift
//  NeighborhoodTV
//
//  Created by fulldev on 1/20/23.
//

import SwiftUI
import AVKit

struct PreviewVideo: View {
    @State var originVideoPlayURL:String = ""
    @State private var player : AVQueuePlayer?
    @State private var videoLooper: AVPlayerLooper?
    @State var isFullScreenModeFlag:Bool = false
    @State var currentthumbnailUrl:String = (UserDefaults.standard.object(forKey: "currentthumbnailUrl") as? String)!
    
    let pub_player_stop = NotificationCenter.default.publisher(for: NSNotification.Name.pub_player_stop)
    
    var body: some View {
        VideoPlayer(player: player)
                    .overlay(AsyncImage(url: URL(string: currentthumbnailUrl), content: {image in
//            .overlay(AsyncImage(url: URL(string: "file:///Users/fulldev/Documents/temp/AppleTV-app/NeighborhoodTV/Assets.xcassets/splashscreen.jpg"), content: {image in
                image.resizable()
                    .scaledToFill()
            }, placeholder: {progressView()}).opacity(isFullScreenModeFlag ? 1: 0))
            .focusable(false)
            .onAppear() {
                isFullScreenModeFlag = false
                
                guard let _originVideoPlayURL = UserDefaults.standard.object(forKey: "original_uri") as? String else {
                    print("Error: Invalid Original_URL")
                    return
                }
                
                originVideoPlayURL = _originVideoPlayURL
                
                let templateItem = AVPlayerItem(url: URL(string: originVideoPlayURL )!)
                player = AVQueuePlayer(playerItem: templateItem)
                videoLooper = AVPlayerLooper(player: player!, templateItem: templateItem)
                videoLooper?.disableLooping()
                player!.play()
                print("-------->>>>>>>>play3", _originVideoPlayURL)
                
                guard let _currentthumbnailUrl = UserDefaults.standard.object(forKey: "currentthumbnailUrl") as? String else {
                    print("Invalid access token")
                    return
                }
                currentthumbnailUrl = _currentthumbnailUrl
                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil, using: self.didPlayToEnd)
            }
            .onReceive(pub_player_stop) {(oPub_player_stop) in
                guard let _oPub_player_stop = oPub_player_stop.object as? Bool else {
                    print("Invalid URL")
                    return
                }
                if _oPub_player_stop {
                    print("------->>>>>>>>>Pause1")
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


