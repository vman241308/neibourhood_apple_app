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
    var player : AVPlayer!  {
        guard let URL = URL(string: currentVideoPlayURL)
        else {
            return nil
        }
        let player = AVPlayer(url: URL)
        return player
    }
    
    var body: some View {
        VideoPlayer(player: player)
    }
    
    
    struct VideoPlayer: UIViewControllerRepresentable {
        
        let player: AVPlayer
        
        func makeUIViewController(context: Context) -> AVPlayerViewController {
            let controller = AVPlayerViewController()
            controller.player = player
            
            return controller
        }
        
        func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
            
            uiViewController.player?.play() // autoplay the video when view appears
            
        }
    }
}

