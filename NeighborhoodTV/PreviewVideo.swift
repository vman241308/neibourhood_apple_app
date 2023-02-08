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
    //    @var currentVideoPlayURL:String = "file:///Users/fulldev/Documents/video.mp4"
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
                player!.play()
                
                var timeStateSubscriber: Any? = player!.addPeriodicTimeObserver(
                    forInterval: CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)),
                    queue: nil) { [self] time in
                        $lastPositionMap.wrappedValue[URL(string: currentVideoPlayURL )!] = time.seconds
                    }
                playOnReadyAsynchronously()
                
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
                player!.play()
                
                var timeStateSubscriber: Any? = player!.addPeriodicTimeObserver(
                    forInterval: CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)),
                    queue: nil) { [self] time in
                        $lastPositionMap.wrappedValue[URL(string: currentVideoPlayURL )!] = time.seconds
                    }
                
                playOnReadyAsynchronously()
            }
    }
    
    func playOnReadyAsynchronously() {
        let keys = [#keyPath(AVAsset.isPlayable)]
        print("------------>>>>>>>>finished1")
        
        let asset = AVURLAsset(url: URL(string: currentVideoPlayURL )!)
        asset.loadValuesAsynchronously(forKeys: keys) { [weak player] in
            var error: NSError?
            let status = asset.statusOfValue(forKey: #keyPath(AVAsset.isPlayable), error: &error)
            
            print("------------>>>>>>>>finished2")
            switch status {
            case .unknown:
                print(">>>>>>>>>>1")
            case .loading:
                print(">>>>>>>>>>2")
            case .loaded:
                print(">>>>>>>>>>3")
            case .failed:
                print(">>>>>>>>>>4")
            case .cancelled:
                print(">>>>>>>>>>5")
            }
        }
    }
    
}


