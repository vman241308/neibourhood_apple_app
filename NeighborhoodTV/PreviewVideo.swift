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
    
    var body: some View {
        VideoPlayer(player: player).onAppear {
            if player == nil {
                let templateItem = AVPlayerItem(url: URL(string: "file:///Users/fulldev/Documents/video.mp4")!)
//                let templateItem = AVPlayerItem(url: URL(string: currentVideoPlayURL )!)
                player = AVQueuePlayer(playerItem: templateItem)
                videoLooper = AVPlayerLooper(player: player!, templateItem: templateItem)
//                player!.play()
            }
        }
    }
}

