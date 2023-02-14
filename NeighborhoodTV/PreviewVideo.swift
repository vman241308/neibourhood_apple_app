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
    @State var timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    @State var isLive:Int = 0
    @State var manageTRP:Int = 0
    @State var trpURI:String = ""
    @State var intervelSec:Int = 0
    @State var trpAccessKey:String = ""
    
    @State var currentPosition:Int = 0
    @State var duration:Int = 0
    @State var playerStatus = 1
    
    @State var currentTRPURL:String = ""
    
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
                playerStatus = 1
                isFirstVideo = true
                
                guard let _currentthumbnailUrl = UserDefaults.standard.object(forKey: "currentthumbnailUrl") as? String else {
                    print("Invalid access token")
                    return
                }
                currentthumbnailUrl = _currentthumbnailUrl
                getTRPInfo()
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
                    playerStatus = 1
                }
                
                guard let _currentthumbnailUrl = UserDefaults.standard.object(forKey: "currentthumbnailUrl") as? String else {
                    print("Invalid access token")
                    return
                }
                currentthumbnailUrl = _currentthumbnailUrl
                getTRPInfo()
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
                        playerStatus = 2
                    }
                    
                    currentPlayerStatus()
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
            .onReceive(timer) { time in
                if manageTRP == 1 {
//                    currentPlayerStatus()
                } else  {
                    print("---No need to send TRP hits.")
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
        player!.pause()
        player!.seek(to: .zero)
        
        currentPlayerStatus()
    }
    
    func getTRPInfo() {
        if !isCornerScreenFocused {
            guard let _current_is_live = UserDefaults.standard.object(forKey: "current_is_live") as? Int else {
                print("Invalid URL")
                return
            }
            
            guard let _current_manage_trp = UserDefaults.standard.object(forKey: "current_manage_trp") as? Int else {
                print("Invalid URL")
                return
            }
            
            guard let _current_trp_uri = UserDefaults.standard.object(forKey: "current_trp_uri") as? String else {
                print("Invalid URL")
                return
            }
            
            guard let _current_intervel_sec = UserDefaults.standard.object(forKey: "current_intervel_sec") as? Int else {
                print("Invalid URL")
                return
            }
            
            guard let _current_trp_access_key = UserDefaults.standard.object(forKey: "current_trp_access_key") as? String else {
                print("Invalid URL")
                return
            }
            
            isLive = _current_is_live
            manageTRP = _current_manage_trp
            trpURI = _current_trp_uri
            intervelSec = 1
            trpAccessKey = _current_trp_access_key
            
        } else {
            guard let _origin_is_live = UserDefaults.standard.object(forKey: "origin_is_live") as? Int else {
                print("Invalid URL")
                return
            }
            
            guard let _origin_manage_trp = UserDefaults.standard.object(forKey: "origin_manage_trp") as? Int else {
                print("Invalid URL")
                return
            }
            
            guard let _origin_trp_uri = UserDefaults.standard.object(forKey: "origin_trp_uri") as? String else {
                print("Invalid URL")
                return
            }
            
            guard let _origin_intervel_sec = UserDefaults.standard.object(forKey: "origin_intervel_sec") as? Int else {
                print("Invalid URL")
                return
            }
            
            guard let _origin_trp_access_key = UserDefaults.standard.object(forKey: "origin_trp_access_key") as? String else {
                print("Invalid URL")
                return
            }
            
            isLive = _origin_is_live
            manageTRP = _origin_manage_trp
            trpURI = _origin_trp_uri
            intervelSec = 1
            trpAccessKey = _origin_trp_access_key
        }
        
        timer = Timer.publish(every: TimeInterval(intervelSec), on: .main, in: .common).autoconnect()
        
    }
    
    func currentPlayerStatus() {
        let playerStatus = Int(player!.rate)
        do {
            let currentItem = player?.currentItem
            if isLive == 0 {
                currentPosition = Int(CMTimeGetSeconds((currentItem?.currentTime())!))
                
                duration = Int((currentItem?.duration.seconds)!)
                
            }
        } catch {
            print("Error: Trying to convert JSON data to string", error)
            return
        }
        
        do {
            guard let _accessToken = UserDefaults.standard.object(forKey: "accessToken") as? String else {
                print("Invalid access token")
                return
            }
            
            guard let _apiBaseURL = UserDefaults.standard.object(forKey: "api_base_url") as? String else {
                print("Invalid apiBaseURL")
                return
            }
            
            if isLive == 1 {
                let _currentTRPURL = _apiBaseURL.appending(trpURI.replacingOccurrences(of: "[PLAYING_STATUS]", with: String(describing: playerStatus)))
                currentTRPURL = _currentTRPURL
            } else {
                let _currentTRPURL = _apiBaseURL.appending(
                    trpURI.replacingOccurrences(of: "[TOTAL_DURATION]", with: String(describing: duration)).replacingOccurrences(of: "[PLAYING_STATUS]", with: String(describing: playerStatus)).replacingOccurrences(of: "[CURRENT_PLAYING_POSITION]", with: String(describing: currentPosition))
                )
                
                currentTRPURL = _currentTRPURL
            }
            
            let accessKeyTRPModel = AccessKeyData(version_name: "1.0", device_id: "1", device_model: "1", version_code: "1.0", device_type: "Fire TV", access_key: trpAccessKey)
            let jsonAccessKeyTRP = try? JSONEncoder().encode(accessKeyTRPModel)
            
            guard let currentTRPParseURL = URL(string: currentTRPURL) else {
                print("Invalid URL")
                return
            }
            
            var trpRequest = URLRequest(url: currentTRPParseURL)
            trpRequest.httpMethod = "POST"
            trpRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            trpRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            trpRequest.httpBody = jsonAccessKeyTRP
            trpRequest.setValue( "Bearer \(_accessToken)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: trpRequest) {data, response, error in
                guard error == nil else {
                    print("Error: error calling POST")
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("Error: Did not receive data")
                    return
                }
                
                let _response = response as? HTTPURLResponse
                if (200 ..< 299) ~= _response!.statusCode {
                    print("Success: HTTP request ")
                } else {
                    print("Error: HTTP request failed")
                    getRefreshToken()
                }
                
                do {
                    guard let jsonTRPObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        print("Error: Cannot convert jsonPreviewVideoObject to JSON object")
                        return
                    }
                    
                    guard let jsonTRPStatus = jsonTRPObject["status"] as? String else {
                        print("Error: Cannot convert jsonPreviewVideoObject to String")
                        return
                    }
                } catch {
                    print("Error: Trying to convert JSON data to string", error)
                    return
                }
            }.resume()
        } catch {
            print("Error: Trying to convert JSON data to string", error)
            return
        }
        
    }
}


