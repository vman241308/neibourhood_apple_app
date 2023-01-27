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
    @State private var player : AVPlayer?
    
    var body: some View {
        VideoPlayer(player: player).onAppear(){
            guard let URL = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8") else {
                return
            }
            let player = AVPlayer(url: URL)
            self.player = player
//            player.play()
        }
        .onDisappear() {
            player?.pause()
        }
    }
}

