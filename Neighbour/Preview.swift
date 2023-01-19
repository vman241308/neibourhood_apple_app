//
//  SideMenu.swift
//  SwiftUISideMenuDemo
//
//  Created by Rupesh Chaudhari on 24/04/22.
//

import SwiftUI
import AVKit

struct AccessKeyUploadData: Codable {
    let version_name: String
    let device_id: String
    let device_model: String
    let version_code: String
    let device_type: String
    let access_key: String
}

struct Preview: View {
    var videoPlayURL : String = "https://pubcmg.teleosmedia.com/linear/cmg/ga_statewide/playlist.m3u8"
//    var player = AVPlayer(url: URL(string: {videoPlayURL} )!)
    var body: some View {
        VideoPlayer(player: AVPlayer(url: URL(string: videoPlayURL )!))
            .onAppear(perform: {PreviewVideo()})
    }
    
    func PreviewVideo() {
        let optionalAccessToken = String(describing: UserDefaults.standard.object(forKey: "accessToken"))
        let stringAccessToken = optionalAccessToken.components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0]
        
        let optionalApiBaseURL = String(describing: UserDefaults.standard.object(forKey: "api_base_url"))
        let stringApiBaseURL = optionalApiBaseURL.components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0]
        
        let optionalPlayURI = String(describing: UserDefaults.standard.object(forKey: "play_uri"))
        let stringPlayURI = optionalPlayURI.components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0]
        
        let optionalAccessKey = String(describing: UserDefaults.standard.object(forKey: "access_key"))
        let stringAccesskey = optionalAccessKey.components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0]
        
        let previewVideoURL = stringApiBaseURL.appending(stringPlayURI)
        
        guard let previewVideoParseURL = URL(string: previewVideoURL) else {
            print("Invalid URL")
            return
        }
        
        let accessKeyDataModel = AccessKeyUploadData(version_name: "1.0", device_id: "1", device_model: "1", version_code: "1.0", device_type: "Fire TV", access_key: stringAccesskey)
        let jsonAccessKeyData = try? JSONEncoder().encode(accessKeyDataModel)
        
        /* previewVideo */
        var previewVideoRequest = URLRequest(url: previewVideoParseURL)
        previewVideoRequest.httpMethod = "POST"
        previewVideoRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        previewVideoRequest.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
        previewVideoRequest.httpBody = jsonAccessKeyData
        previewVideoRequest.setValue( "Bearer \(stringAccessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: previewVideoRequest) {data, response, error in
            guard error == nil else {
                print("Error: error calling POST")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            do {
                
                guard let previewVideoObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                
                guard let previewVideoObjectResults = previewVideoObject["results"] as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                
                let optionalVideoPlayURL = String(describing: previewVideoObjectResults["uri"])
//                videoPlayURL.append(optionalVideoPlayURL.components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0])
                vURL = optionalVideoPlayURL.components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0]
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
}
