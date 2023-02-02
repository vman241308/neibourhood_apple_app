//
//  NeighborhoodTVApp.swift
//  NeighborhoodTV
//
//  Created by fulldev on 1/20/23.
//

import SwiftUI

@main
struct NeighborhoodTVApp: App {
    @State var isSplashActive:Bool = true
    @State var allMediaItems:[MediaListType] = []
    @State var accessToken:String = ""
    @State var apiBaseURL:String = ""
    @State var homeSubURI:String = ""
    @State var playURI:String = ""
    @State var accessKey:String = ""
    @State var currentVideoPlayURL:String = ""
    @State var allLocationItems:[LocationModel] = []
    @State var currentVideoTitle:String = ""
    
    var body: some Scene {
        WindowGroup {
            if isSplashActive {
                /* -----------------------SplashScreen------------------------ */
                SplashScreen()
                    .onAppear(perform: {
                        getToken()
                    })
                    .frame(width: 300, height: 100,alignment: .center)
            } else {
                /* -----------------------MainContent------------------------ */
                ContentView(currentVideoPlayURL: $currentVideoPlayURL, allMediaItems:$allMediaItems, allLocationItems: $allLocationItems, currentVideoTitle: $currentVideoTitle)
            }
        }
    }
    
    /* -----------------------GetToken------------------------ */
    func getToken() {
        do {
            guard let tokenParseURL = URL(string: tokenURL) else {
                print("Invalid URL")
                return
            }
            var tokenRequest = URLRequest(url: tokenParseURL)
            tokenRequest.httpMethod = "POST"
            tokenRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            tokenRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            tokenRequest.httpBody = jsonDefaultData
            
            URLSession.shared.dataTask(with: tokenRequest) { data, response, error in
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
                    guard let jsonTokenObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        print("Error: Cannot convert data to jsonTokenObject object")
                        return
                    }
                    
                    guard let jsonTokenResults = jsonTokenObject["results"] as? [String: Any] else {
                        print("Error: Cannot convert data to jsonTokenResults object")
                        return
                    }
                    
                    guard let jsonTokenLocations = jsonTokenResults["locations"] as? [[String: Any]] else {
                        print("Error: Cannot convert data to jsonMediaListItems object")
                        return
                    }
                    
                    for locationItem in jsonTokenLocations {
                        let locationItems: LocationModel = LocationModel (_id: locationItem["_id"] as! String,
                                                                          thumbnailUrl: locationItem["thumbnailUrl"] as! String,
                                                                          title: locationItem["title"] as! String,
                                                                          uri: locationItem["uri"] as! String)
                        allLocationItems.append(locationItems)
                    }
                    
                    UserDefaults.standard.set(jsonTokenResults["accessToken"], forKey: "accessToken")
                    
                    UserDefaults.standard.set(jsonTokenResults["refreshToken"], forKey: "refreshToken")
                    UserDefaults.standard.set(jsonTokenResults["home_uri"], forKey: "home_sub_uri")
                    
                    guard let jsonTokenConfig = jsonTokenResults["config"] as? [String: Any] else {
                        print("Error: Cannot convert data to jsonTokenResults object")
                        return
                    }
                    
                    UserDefaults.standard.set(jsonTokenConfig["api_base_url"], forKey: "api_base_url")
                    UserDefaults.standard.set(jsonTokenConfig["api_refresh_token"], forKey: "api_refresh_token")
                    loadMediaList()
                } catch {
                    print("Error: Trying to convert JSON data to string", error)
                    return
                }
            }.resume()
        } catch  {
            print("Error: Trying to convert JSON data to string", error)
            return
        }
        
    }
    
    /* -----------------------MediaList------------------------ */
    func loadMediaList() {
        do {
            guard let _accessToken = UserDefaults.standard.object(forKey: "accessToken") as? String else {
                print("Invalid access token")
                return
            }
            
            accessToken = _accessToken
            
            guard let _apiBaseURL = UserDefaults.standard.object(forKey: "api_base_url") as? String else {
                print("Invalid apiBaseURL")
                return
            }
            
            apiBaseURL = _apiBaseURL
            
            guard let _homeSubURI = UserDefaults.standard.object(forKey: "home_sub_uri") as? String else {
                print("Invalid apiBaseURL")
                return
            }
            
            homeSubURI = _homeSubURI
            
            guard let mediaListParseURL = URL(string: apiBaseURL.appending(homeSubURI)) else {
                print("Invalid URL...")
                return
            }
            
            var mediaListRequest = URLRequest(url: mediaListParseURL)
            mediaListRequest.httpMethod = "POST"
            mediaListRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            mediaListRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            mediaListRequest.setValue( "Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            mediaListRequest.httpBody = jsonDefaultData
            
            URLSession.shared.dataTask(with: mediaListRequest) { data, response, error in
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
                    guard let jsonMediaListObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        print("Error: Cannot convert data to jsonMediaListObject object")
                        return
                    }
                    
                    guard let jsonMediaListResults = jsonMediaListObject["results"] as? [String: Any] else {
                        print("Error: Cannot convert data to jsonMediaListResults object")
                        return
                    }
                    
                    UserDefaults.standard.set(jsonMediaListResults["retrieve_uri"], forKey: "retrieve_uri")
                    
                    guard let jsonMediaListItems = jsonMediaListResults["items"] as? [[String: Any]] else {
                        print("Error: Cannot convert data to jsonMediaListItems object")
                        return
                    }
                    
                    guard let jsonMediaListLocation = jsonMediaListResults["location"] as? [String: Any] else {
                        print("Error: Cannot convert data to jsonMediaListLocation object")
                        return
                    }
                    
                    guard let _currentVideoTitle = jsonMediaListLocation["title"] as? String else {
                        print("Invalid Title")
                        return
                    }
                    
                    currentVideoTitle = _currentVideoTitle
                    
                    
                    UserDefaults.standard.set(jsonMediaListLocation["access_key"], forKey: "access_key")
                    UserDefaults.standard.set(jsonMediaListResults["retrieve_uri"], forKey: "retrieve_uri")
                    UserDefaults.standard.set(jsonMediaListLocation["title"], forKey: "original_title")
                    UserDefaults.standard.set(jsonMediaListLocation["play_uri"], forKey: "play_uri")
                    
                    
                    for item in jsonMediaListItems {
                        let mediaListItems: MediaListType = MediaListType(itemIndex: allMediaItems.count + 1,
                                                                          _id: item["_id"] as! String,
                                                                          title: item["title"] as! String,
                                                                          description: item["description"] as! String,
                                                                          thumbnailUrl: item["thumbnailUrl"] as! String,
                                                                          duration: item["duration"] as! Int,
                                                                          play_uri: item["play_uri"] as! String,
                                                                          access_key: item["access_key"] as! String
                        )
                        allMediaItems.append(mediaListItems)
                        previewVideo()
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
    
    /* -----------------------PreviewMedia------------------------ */
    func previewVideo() {
        do {
            guard let _playURI = UserDefaults.standard.object(forKey: "play_uri") as? String else {
                print("Invalid playURI")
                return
            }
            
            guard let _accessKey = UserDefaults.standard.object(forKey: "access_key") as? String else {
                print("Invalid accessKey")
                return
            }
            
            playURI = _playURI
            accessKey = _accessKey
            
            guard let previewVideoParseURL = URL(string: apiBaseURL.appending(playURI)) else {
                print("Invalid URL")
                return
            }
            
            let accessKeyDataModel = AccessKeyData(version_name: "1.0", device_id: "1", device_model: "1", version_code: "1.0", device_type: "Fire TV", access_key: accessKey)
            let jsonAccessKeyData = try? JSONEncoder().encode(accessKeyDataModel)
            
            var previewVideoRequest = URLRequest(url: previewVideoParseURL)
            previewVideoRequest.httpMethod = "POST"
            previewVideoRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            previewVideoRequest.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
            previewVideoRequest.httpBody = jsonAccessKeyData
            previewVideoRequest.setValue( "Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
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
                
                let _response = response as? HTTPURLResponse
                if (200 ..< 299) ~= _response!.statusCode {
                    print("Success: HTTP request ")
                } else {
                    print("Error: HTTP request failed")
                    getRefreshToken()
                }
                
                do {
                    guard let jsonPreviewVideoObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        print("Error: Cannot convert jsonPreviewVideoObject to JSON object")
                        return
                    }
                    
                    guard let jsonPreviewVideoResults = jsonPreviewVideoObject["results"] as? [String: Any] else {
                        print("Error: Cannot convert data to jsonPreviewVideoResults object")
                        return
                    }
                    
                    guard let _currentVideoPlayURL = jsonPreviewVideoResults["uri"] as? String else {
                        print("Invalid uri")
                        return
                    }
                    
//                                        currentVideoPlayURL = _currentVideoPlayURL
                    currentVideoPlayURL = "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8"
                    UserDefaults.standard.set(currentVideoPlayURL, forKey: "original_uri")
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: .dataDidFlow, object: currentVideoPlayURL)
                    }
                    isSplashActive = false
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
