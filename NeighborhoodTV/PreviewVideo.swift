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
    let publisher = NotificationCenter.default.publisher(for: NSNotification.Name.dataDidFlow)
    var body: some View {
        VideoPlayer(player: player)
            .onAppear() {
                let templateItem = AVPlayerItem(url: URL(string: currentVideoPlayURL )!)
                player = AVQueuePlayer(playerItem: templateItem)
                videoLooper = AVPlayerLooper(player: player!, templateItem: templateItem)
                player!.play()
            }
            .onReceive(publisher) { (output) in
                guard let _objURL = output.object as? String else {
                    print("Invalid URL")
                    return
                }
                let templateItem = AVPlayerItem(url: URL(string: _objURL )!)
                player = AVQueuePlayer(playerItem: templateItem)
                videoLooper = AVPlayerLooper(player: player!, templateItem: templateItem)
                player!.play()
                
            }
    }
    
}

