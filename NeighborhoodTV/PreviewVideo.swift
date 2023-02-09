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
    @State private var isViewDisplayed = false
    
    @State private var lastPositionMap: [AnyHashable: TimeInterval] = [:]
    
    let publisher = NotificationCenter.default.publisher(for: NSNotification.Name.dataDidFlow)
    
    
    var body: some View {
        VideoPlayer(player: player)
            .focusable(false)
            .onAppear() {
                isViewDisplayed = true
                let templateItem = AVPlayerItem(url: URL(string: currentVideoPlayURL )!)
                player = AVQueuePlayer(playerItem: templateItem)
                videoLooper = AVPlayerLooper(player: player!, templateItem: templateItem)
                videoLooper?.disableLooping()
//                player!.play()
                
                
            }
            .onReceive(publisher) { (output) in
                isViewDisplayed = true
                guard let _objURL = output.object as? String else {
                    print("Invalid URL")
                    return
                }
                let templateItem = AVPlayerItem(url: URL(string: _objURL )!)
                player = AVQueuePlayer(playerItem: templateItem)
                videoLooper = AVPlayerLooper(player: player!, templateItem: templateItem)
                videoLooper?.disableLooping()
//                player!.play()
            }
    }
    
    
}


