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
    @State var currentGridTitle:String = ""
    @State var currentVideoTitle:String = ""
    @State var allLocationItems:[LocationModel] = []
    
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
                ContentView(currentVideoPlayURL: $currentVideoPlayURL, allMediaItems:$allMediaItems, currentGridTitle: $currentGridTitle, currentVideoTitle:$currentVideoTitle, allLocationItems: $allLocationItems)
            }
        }
    }
    
    /* -----------------------GetToken------------------------ */
    func getToken() {
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
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
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
                
                UserDefaults.standard.set(jsonTokenResults["accessToken"], forKey: "accessToken")
                UserDefaults.standard.set(jsonTokenResults["home_uri"], forKey: "home_sub_uri")
                
                guard let jsonTokenConfig = jsonTokenResults["config"] as? [String: Any] else {
                    print("Error: Cannot convert data to jsonTokenResults object")
                    return
                }
                
                UserDefaults.standard.set(jsonTokenConfig["api_base_url"], forKey: "api_base_url")
                loadMediaList()
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    
    /* -----------------------MediaList------------------------ */
    func loadMediaList() {
        accessToken = String(describing: UserDefaults.standard.object(forKey: "accessToken")).components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0]
        
        
        apiBaseURL = String(describing: UserDefaults.standard.object(forKey: "api_base_url")).components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0]
        
        homeSubURI = String(describing: UserDefaults.standard.object(forKey: "home_sub_uri")).components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0]
        
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
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
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
                
                UserDefaults.standard.set(jsonMediaListResults["title"], forKey: "currentGridTitle")
                currentGridTitle = String(describing: UserDefaults.standard.object(forKey: "currentGridTitle")).components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0]
                
                guard let jsonMediaListLocation = jsonMediaListResults["location"] as? [String: Any] else {
                    print("Error: Cannot convert data to jsonMediaListLocation object")
                    return
                }
                

                    let locationListItems: LocationModel = LocationModel(title: jsonMediaListLocation["title"] as! String,
                                                                         access_key: jsonMediaListLocation["access_key"] as! String, description: "I am strong.",
//                                                                         description: jsonMediaListLocation["description"] as! String,
                                                                         thumbnailUrl: jsonMediaListLocation["thumbnailUrl"] as! String,
                                                                         play_uri: jsonMediaListLocation["play_uri"] as! String,
                                                                         _id: jsonMediaListLocation["_id"] as! String,
                                                                         locationId: jsonMediaListLocation["locationId"] as! String
                    )
                    allLocationItems.append(locationListItems)

                
                
                UserDefaults.standard.set(jsonMediaListLocation["access_key"], forKey: "access_key")
                UserDefaults.standard.set(jsonMediaListResults["retrieve_uri"], forKey: "retrieve_uri")
                UserDefaults.standard.set(jsonMediaListLocation["title"], forKey: "currentVideoTitle")
                UserDefaults.standard.set(jsonMediaListLocation["play_uri"], forKey: "play_uri")
                
                currentVideoTitle = String(describing: UserDefaults.standard.object(forKey: "currentVideoTitle")).components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0]
                
                print("---------item>", type(of: jsonMediaListItems))
                
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
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    
    /* -----------------------PreviewMedia------------------------ */
    func previewVideo() {
        playURI = String(describing: UserDefaults.standard.object(forKey: "play_uri")).components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0]
        
        accessKey = String(describing: UserDefaults.standard.object(forKey: "access_key")).components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0]
        
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
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
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
                
                currentVideoPlayURL = String(describing: jsonPreviewVideoResults["uri"]).components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0]
                isSplashActive = false
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
}
