//
//  PreviewVideo.swift
//  NeighborhoodTV
//
//  Created by fulldev on 1/20/23.
//

import SwiftUI
import AVKit

struct PreviewVideo: View {
    @Binding var currentVideoPlayURL:String
    @State private var player : AVQueuePlayer?
    @State private var videoLooper: AVPlayerLooper?
//    @State private var player = AVPlayer(url: URL(string: currentVideoPlayURL )!)
    
    var body: some View {
//        VideoPlayer(player: AVPlayer(url: URL(string: currentVideoPlayURL )!))
//            .onAppear {
//                play()
//            }.onDisappear {
//                pause()
//            }
        VideoPlayer(player: player ).onAppear {
            if player == nil {
                let templateItem = AVPlayerItem(url: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8")!)
                player = AVQueuePlayer(playerItem: templateItem)
                videoLooper = AVPlayerLooper(player: player!, templateItem: templateItem)
                player!.play()
            }
        }
    }
}

