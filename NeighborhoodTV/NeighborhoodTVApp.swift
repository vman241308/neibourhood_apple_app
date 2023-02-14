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
                        let locationItems: LocationModel = LocationModel (locationItemIndex: allLocationItems.count + 1,
                                                                          _id: locationItem["_id"] as! String,
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
                    UserDefaults.standard.set(jsonTokenConfig["api_about_us"], forKey: "api_about_us")
                    UserDefaults.standard.set(jsonTokenConfig["api_privacy_policy"], forKey: "api_privacy_policy")
                    UserDefaults.standard.set(jsonTokenConfig["api_visitor_agreement"], forKey: "api_visitor_agreement")
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
                    UserDefaults.standard.set(jsonMediaListLocation["thumbnailUrl"], forKey: "currentthumbnailUrl")
                    
                    
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
            previewVideoRequest.setValue("application/json", forHTTPHeaderField: "Accept")
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
                    
                    UserDefaults.standard.set(jsonPreviewVideoResults["is_live"], forKey: "origin_is_live")
                    UserDefaults.standard.set(jsonPreviewVideoResults["manage_trp"], forKey: "origin_manage_trp")
                    
                    
                    guard let jsonPreviewVideoTRP = jsonPreviewVideoResults["trp"] as? [String: Any] else {
                        print("Error: Cannot convert data to jsonPreviewVideoResults object")
                        return
                    }

                    UserDefaults.standard.set(jsonPreviewVideoTRP["uri"], forKey: "origin_trp_uri")
                    UserDefaults.standard.set(jsonPreviewVideoTRP["intervel_sec"], forKey: "origin_intervel_sec")
                    UserDefaults.standard.set(jsonPreviewVideoTRP["access_key"], forKey: "origin_trp_access_key")
                    
                    
                                        currentVideoPlayURL = _currentVideoPlayURL
//                    currentVideoPlayURL = "file:///Users/fulldev/Documents/temp/AppleTV-app/video.mp4"
                    UserDefaults.standard.set(currentVideoPlayURL, forKey: "original_uri")
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: .dataDidFlow, object: currentVideoPlayURL)
                    }
                    infoAboutUs()
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
    
    /* -----------------------About Us------------------------ */
    func infoAboutUs() {
        do {
            guard let _infoAboutUsURL = UserDefaults.standard.object(forKey: "api_about_us") as? String else {
                print("Invalid playURI")
                return
            }
            
            guard let infoAboutUsParseURL = URL(string: _infoAboutUsURL) else {
                print("Invalid URL...")
                return
            }
            
            var infoAboutUsRequest = URLRequest(url: infoAboutUsParseURL)
            infoAboutUsRequest.httpMethod = "POST"
            infoAboutUsRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            infoAboutUsRequest.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
            infoAboutUsRequest.httpBody = jsonDefaultData
            infoAboutUsRequest.setValue( "Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: infoAboutUsRequest) {data, response, error in
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
                    guard let jsonInfoAboutUsObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        print("Error: Cannot convert jsonPreviewVideoObject to JSON object")
                        return
                    }
                    
                    guard let jsonInfoAboutUsResults = jsonInfoAboutUsObject["results"] as? [String: Any] else {
                        print("Error: Cannot convert data to jsonPreviewVideoResults object")
                        return
                    }
                    
                    UserDefaults.standard.set(jsonInfoAboutUsResults["page_body"], forKey: "about_us_page_body")
                    UserDefaults.standard.set(jsonInfoAboutUsResults["seo_title"], forKey: "about_us_seo_title")
                    
                    infoPrivacyPolicy()
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
    
    /* -----------------------PrivacyPolicy------------------------ */
    func infoPrivacyPolicy() {
        do {
            guard let _infoPrivacyPolicyURL = UserDefaults.standard.object(forKey: "api_privacy_policy") as? String else {
                print("Invalid playURI")
                return
            }
            
            guard let infoPrivacyPolicyParseURL = URL(string: _infoPrivacyPolicyURL) else {
                print("Invalid URL...")
                return
            }
            
            var infoPrivacyPolicyRequest = URLRequest(url: infoPrivacyPolicyParseURL)
            infoPrivacyPolicyRequest.httpMethod = "POST"
            infoPrivacyPolicyRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            infoPrivacyPolicyRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            infoPrivacyPolicyRequest.httpBody = jsonDefaultData
            infoPrivacyPolicyRequest.setValue( "Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: infoPrivacyPolicyRequest) {data, response, error in
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
                    guard let jsonInfoPrivacyPolicyObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        print("Error: Cannot convert jsonPreviewVideoObject to JSON object")
                        return
                    }
                    
                    guard let jsonInfoPrivacyPolicyResults = jsonInfoPrivacyPolicyObject["results"] as? [String: Any] else {
                        print("Error: Cannot convert data to jsonPreviewVideoResults object")
                        return
                    }
                    
                    UserDefaults.standard.set(jsonInfoPrivacyPolicyResults["seo_title"], forKey: "privacy_policy_seo_title")
                    UserDefaults.standard.set(jsonInfoPrivacyPolicyResults["page_body"], forKey: "privacy_policy_page_body")
                   
                    infoVisitorAgreement()
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
    
    /* -----------------------VisitorAgreement------------------------ */
    func infoVisitorAgreement() {
        do {
            guard let _infoVisitorAgreementURL = UserDefaults.standard.object(forKey: "api_visitor_agreement") as? String else {
                print("Invalid playURI")
                return
            }
            
            guard let infoVisitorAgreementParseURL = URL(string: _infoVisitorAgreementURL) else {
                print("Invalid URL...")
                return
            }
            
            var infoVisitorAgreementRequest = URLRequest(url: infoVisitorAgreementParseURL)
            infoVisitorAgreementRequest.httpMethod = "POST"
            infoVisitorAgreementRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            infoVisitorAgreementRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            infoVisitorAgreementRequest.httpBody = jsonDefaultData
            infoVisitorAgreementRequest.setValue( "Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: infoVisitorAgreementRequest) {data, response, error in
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
                    guard let jsonInfoVisitorAgreementObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        print("Error: Cannot convert jsonPreviewVideoObject to JSON object")
                        return
                    }
                    
                    guard let jsonInfoVisitorAgreementResults = jsonInfoVisitorAgreementObject["results"] as? [String: Any] else {
                        print("Error: Cannot convert data to jsonPreviewVideoResults object")
                        return
                    }
                    
                    UserDefaults.standard.set(jsonInfoVisitorAgreementResults["page_body"], forKey: "visitor_agreement_page_body")
                    UserDefaults.standard.set(jsonInfoVisitorAgreementResults["seo_title"], forKey: "visitor_agreement_seo_title")
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
