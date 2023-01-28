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
    var player : AVPlayer?  {
        guard let URL = URL(string: currentVideoPlayURL) else {
            //                        guard let URL = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8") else {
            return nil
        }
        let player = AVPlayer(url: URL)
        return player
    }
    
    var body: some View {
        VideoPlayer(player: player).onAppear(){
            player?.play()
        }
    }
}

