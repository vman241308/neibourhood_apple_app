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
    @State var OMute:Bool = false
    @State private var player : AVQueuePlayer?
    @State private var videoLooper: AVPlayerLooper?
    @State private var lastPositionMap: [AnyHashable: TimeInterval] = [:]
    @State var imageView: UIImageView!
    @State var isFullScreenModeFlag:Bool = false
    @State var currentthumbnailUrl:String = (UserDefaults.standard.object(forKey: "currentthumbnailUrl") as? String)!
    
    let publisher = NotificationCenter.default.publisher(for: NSNotification.Name.dataDidFlow)
    let pub_player_mute = NotificationCenter.default.publisher(for: NSNotification.Name.pub_player_mute)
    let pub_player_pause = NotificationCenter.default.publisher(for: NSNotification.Name.player_pause)
    
    var body: some View {
        VideoPlayer(player: player)
//            .overlay(AsyncImage(url: URL(string: currentthumbnailUrl), content: {image in
                    .overlay(AsyncImage(url: URL(string: "file:///Users/fulldev/Documents/temp/AppleTV-app/NeighborhoodTV/Assets.xcassets/splashscreen.jpg"), content: {image in

                image.resizable()
                    .scaledToFill()
            }, placeholder: {progressView()}).opacity(isFullScreenModeFlag ? 1: 0))
            .focusable(false)
            .onReceive(pub_player_pause) {(oPause) in
                guard let _oPause = oPause.object as? Bool else {
                    print("Invalid URL")
                    return
                }
                if isCornerScreenFocused {
                    print("----------------------------------1")
                    if _oPause {
                        player!.pause()
                    } else {
                        isFullScreenModeFlag = false
                        player!.play()
                    }
                }
            }
            .onReceive(pub_player_mute) { (oMute) in
                guard let _oMute = oMute.object as? Bool else {
                    print("Invalid URL")
                    return
                }
                OMute = _oMute
            }
            .onAppear() {
                isFullScreenModeFlag = false
                let templateItem = AVPlayerItem(url: URL(string: currentVideoPlayURL )!)
                player = AVQueuePlayer(playerItem: templateItem)
                videoLooper = AVPlayerLooper(player: player!, templateItem: templateItem)
                videoLooper?.disableLooping()
                player!.play()
                player!.isMuted = OMute
                
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
                player!.play()
                player!.isMuted = OMute
                
                guard let _currentthumbnailUrl = UserDefaults.standard.object(forKey: "currentthumbnailUrl") as? String else {
                    print("Invalid access token")
                    return
                }
                currentthumbnailUrl = _currentthumbnailUrl
                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil, using: self.didPlayToEnd)
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
        
        isFullScreenModeFlag = true
    }
}


