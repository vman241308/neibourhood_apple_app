//
//  PreviewVideo.swift
//  NeighborhoodTV
//
//  Created by fulldev on 1/20/23.
//

import SwiftUI
import AVKit

extension AVQueuePlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

struct PreviewVideo: View {
    @Binding var currentVideoPlayURL:String
    @Binding var isCornerScreenFocused:Bool
    @Binding var isFirstVideo:Bool
    @State private var player : AVQueuePlayer?
    @State private var videoLooper: AVPlayerLooper?
    @State private var lastPositionMap: [AnyHashable: TimeInterval] = [:]
    @State var imageView: UIImageView!
    @State var isFullScreenModeFlag:Bool = false
    @State var currentthumbnailUrl:String = (UserDefaults.standard.object(forKey: "currentthumbnailUrl") as? String)!
    
    let publisher = NotificationCenter.default.publisher(for: NSNotification.Name.dataDidFlow)
    let pub_player_stop = NotificationCenter.default.publisher(for: NSNotification.Name.pub_player_stop)
    let pub_player_mute = NotificationCenter.default.publisher(for: NSNotification.Name.pub_player_mute)
    
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
                let templateItem = AVPlayerItem(url: URL(string: currentVideoPlayURL )!)
                player = AVQueuePlayer(playerItem: templateItem)
                videoLooper = AVPlayerLooper(player: player!, templateItem: templateItem)
                videoLooper?.disableLooping()
                player!.play()
                isFirstVideo = true                
                
                guard let _currentthumbnailUrl = UserDefaults.standard.object(forKey: "currentthumbnailUrl") as? String else {
                    print("Invalid access token")
                    return
                }
                currentthumbnailUrl = _currentthumbnailUrl
                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil, using: self.didPlayToEnd)
            }
            .onReceive(publisher) { (output) in
                isFullScreenModeFlag = false
                guard let _objURL = output.object as? String else {
                    print("Invalid URL")
                    return
                }
                
                let templateItem = AVPlayerItem(url: URL(string: _objURL )!)
                player = AVQueuePlayer(playerItem: templateItem)
                videoLooper = AVPlayerLooper(player: player!, templateItem: templateItem)
                videoLooper?.disableLooping()
                if !isCornerScreenFocused {
                    player!.play()
                }
                
                
                
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
                if isCornerScreenFocused {
                    if _oPub_player_stop {
                        player!.pause()
                        player!.seek(to: .zero)
                    }
                }
                
            }
            .onReceive(pub_player_mute) { (oPub_player_mute) in
                guard let _oPub_player_mute = oPub_player_mute.object as? Bool else {
                    print("Invalid URL")
                    return
                }
                
                if _oPub_player_mute {
                    player!.isMuted = true
                } else {
                    player!.isMuted = false
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
    }
}


