//
//  MediaList.swift
//  NeighborhoodTV
//
//  Created by fulldev on 1/20/23.
//
import SwiftUI
import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct Index :Codable {
    var itemIndex:Int
}



struct Grid: View {
    
    var item : MediaListType
    @Binding var allMediaItems:[MediaListType]
    @State var isFocused = false
    
    @Binding var isPreviewVideoStatus:Bool
    @Binding var currentPaginationNum:Int
    @Binding var isCornerScreenFocused:Bool
    @Binding var currentVideoTitle:String
    @Binding var currentVideoDescription:String
    @Binding var currentVideoPlayURL:String
    @Binding var isVideoSectionFocused:Bool
    @Binding var isPresentingAlert:Bool
    @State var isItemFocusable = true
//    @FocusState private var isPreviousFocused: FocusedField?
    @FocusState private var isPreviousFocused: Bool
    
    @State private var itemIndex = 2
    
    
    let publish = NotificationCenter.default.publisher(for: NSNotification.Name.previousItemIndex)
    var body: some View {
        HStack{
            ZStack(alignment: .bottom) {
                AsyncImage(url: URL(string: "\(item.thumbnailUrl)")) { image in
//                                    AsyncImage(url: URL(string: "file:///Users/fulldev/Documents/temp/AppleTV-app/NeighborhoodTV/Assets.xcassets/splashscreen.jpg")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 150)
                        .clipped()
                        .shadow(radius: 18, x: 0, y: isFocused ? 50 : 0)
                } placeholder: {
                    placeholderImage()
                        .frame(width: 250, height: 150)
                }
                Text("\(item.title)")
                    .foregroundColor(.white)
                    .font(.custom("Arial Round MT Bold", fixedSize: 20))
                    .frame(width: 250, height: 40)
            }
            .border(.white, width: (isFocused ? 8 : 2))
        }
        .scaleEffect(isFocused ? 1.1 : 1)
        .focusable(isItemFocusable) { newState in
            isFocused = newState;
            if newState {
                isPreviewVideoStatus = true
            }
            onCheckCurrentPositon()}
        .focused($isPreviousFocused)
        .onReceive(publish) {iIndex in
            guard let _iIndex = iIndex.object as? Int else {
                print("Invalid URL")
                return
            }
            if _iIndex == item.itemIndex {
                self.isPreviousFocused = true
            } else {
                self.isPreviousFocused = false
            }
        }
        .animation(.easeInOut, value: isFocused)
        .onLongPressGesture(minimumDuration: 0.001, perform: {onVideoDescription()})
    }
    
    @ViewBuilder
    func placeholderImage() -> some View {
        Image(systemName: "video")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200, height: 100)
            .foregroundColor(.gray)
    }
    
    func onCheckCurrentPositon() {
        do {
            if (item.itemIndex <= allMediaItems.count && item.itemIndex > (allMediaItems.count - 5)){
                currentPaginationNum = allMediaItems.count
                
                guard let optionalRetrieveUri = UserDefaults.standard.object(forKey: "retrieve_uri") as? String else {
                    print("Invalid api_base_url")
                    return
                }
                
                let retrieveUri = optionalRetrieveUri.components(separatedBy: "[")[0].appending(String(describing: currentPaginationNum)).appending(optionalRetrieveUri.components(separatedBy: "]")[1])
                
                guard let accessToken = UserDefaults.standard.object(forKey: "accessToken") as? String else {
                    print("Invalid accessToken")
                    return
                }
                
                guard let apiBaseURL = UserDefaults.standard.object(forKey: "api_base_url") as? String else {
                    print("Invalid api_base_url")
                    return
                }
                
                let offsetMenuListURL = apiBaseURL.appending(retrieveUri)
                
                guard let offsetMenuListParseURL = URL(string: offsetMenuListURL) else {
                    print("Invalid URL")
                    return
                }
                
                var offsetMediaListRequest = URLRequest(url: offsetMenuListParseURL)
                offsetMediaListRequest.httpMethod = "POST"
                offsetMediaListRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                offsetMediaListRequest.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
                offsetMediaListRequest.httpBody = jsonDefaultData
                offsetMediaListRequest.setValue( "Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                URLSession.shared.dataTask(with: offsetMediaListRequest ) { data, response, error in
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
                        isPresentingAlert = true
                    }
                    do {
                        guard let jsonOffsetMediaListObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                            print("Error: Cannot convert data to JSON object")
                            return
                        }
                        
                        guard let jsonOffsetMediaListResults = jsonOffsetMediaListObject["results"] as? [String: Any] else {
                            print("Error: Cannot convert data to JSON object")
                            return
                        }
                        
                        guard let jsonOffsetMediaListitems = jsonOffsetMediaListResults["items"] as? [[String: Any]] else {
                            print("Error: Cannot convert data to JSON object")
                            return
                        }
                        
                        for item in jsonOffsetMediaListitems {
                            let newMediaItem: MediaListType = MediaListType(itemIndex: allMediaItems.count + 1,
                                                                            _id: item["_id"] as! String,
                                                                            title: item["title"] as! String,
                                                                            description: item["description"] as! String,
                                                                            thumbnailUrl: item["thumbnailUrl"] as! String,
                                                                            duration: item["duration"] as! Int,
                                                                            play_uri: item["play_uri"] as! String,
                                                                            access_key: item["access_key"] as! String
                            )
                            allMediaItems.append(newMediaItem)
                            
                        }
                    } catch {
                        print("Error: Trying to convert JSON data to string", error)
                        return
                    }
                }.resume()
            }
        } catch {
            print("Error: Trying to convert JSON data to string", error)
            return
        }
        
    }
    
    func onVideoDescription() {
        do {
            guard var accessToken = UserDefaults.standard.object(forKey: "accessToken") as? String else {
                print("Invalid accessToken")
                return
            }
            
            guard let apiBaseURL = UserDefaults.standard.object(forKey: "api_base_url") as? String else {
                print("Invalid api_base_url")
                return
            }
            
            guard let descriptionVideoParseURL = URL(string: apiBaseURL.appending(item.play_uri)) else {
                print("Invalid URL")
                return
            }
            
            
            currentVideoTitle = item.title
            currentVideoDescription = item.description
            
            UserDefaults.standard.set(item.access_key, forKey: "access_key")
            
            guard let _locationAccessKey = UserDefaults.standard.object(forKey: "access_key") as? String else {
                print("Invalid accessKey")
                return
            }
            
            let itemAccessKeyDataModel = AccessKeyData(version_name: "1.0", device_id: "1", device_model: "1", version_code: "1.0", device_type: "Fire TV", access_key: _locationAccessKey)
            let jsonItemAccessKeyData = try? JSONEncoder().encode(itemAccessKeyDataModel)
            
            var descriptionVideoRequest = URLRequest(url: descriptionVideoParseURL)
            descriptionVideoRequest.httpMethod = "POST"
            descriptionVideoRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            descriptionVideoRequest.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
            descriptionVideoRequest.httpBody = jsonItemAccessKeyData
            descriptionVideoRequest.setValue( "Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: descriptionVideoRequest) {data, response, error in
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
                    if _response?.statusCode == 401 {
                        getRefreshToken()
                        isPresentingAlert = true
                    }
                }
                
                do {
                    guard let jsonDescriptionVideoObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        print("Error: Cannot convert jsonPreviewVideoObject to JSON object")
                        return
                    }
                    
                    guard let jsonDescriptionVideoResults = jsonDescriptionVideoObject["results"] as? [String: Any] else {
                        print("Error: Cannot convert data to jsonPreviewVideoResults object")
                        return
                    }
                    
                    guard let _currentLocationVideoPlayURL = jsonDescriptionVideoResults["uri"] as? String else {
                        print("Invalid playURI")
                        return
                    }
                    
                    currentVideoPlayURL = _currentLocationVideoPlayURL

//                                        if currentVideoPlayURL == "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8" {
//                                            currentVideoPlayURL = "file:///Users/fulldev/Documents/video.mp4"
//                                        } else {
//                                            currentVideoPlayURL = "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8"
//                                        }
                    
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: .dataDidFlow, object: currentVideoPlayURL)
                    }
                    
                    
                    if !isCornerScreenFocused {
                        isVideoSectionFocused = true
                        isFocused = false
                        
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .videoSection, object: isVideoSectionFocused)
                        }
                    }
                    
                    isCornerScreenFocused = false
                    UserDefaults.standard.set(item.itemIndex, forKey: "previousItemIndex")
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
}


struct MediaList: View {
    @State var currentPaginationNum:Int = 0
    @Binding var allMediaItems:[MediaListType]
    @Binding var isPreviewVideoStatus:Bool
    @Binding var isCornerScreenFocused:Bool
    @Binding var currentVideoTitle:String
    @Binding var currentVideoDescription:String
    @Binding var currentVideoPlayURL:String
    @Binding var isVideoSectionFocused:Bool
    @Binding var isPresentingAlert:Bool
    let columns = [
        GridItem(.flexible(), spacing: 10,
                 alignment: .top),
        GridItem(.flexible(), spacing: 10,
                 alignment: .top),
        GridItem(.flexible(), spacing: 10,
                 alignment: .top),
        GridItem(.flexible(), spacing: 10,
                 alignment: .top),
        GridItem(.flexible(), spacing: 10,
                 alignment: .top)
    ]
    
    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                LazyVGrid(columns: columns) {
                    ForEach(allMediaItems, id:\._id ) { item in
                        Grid(item: item, allMediaItems:$allMediaItems, isPreviewVideoStatus : $isPreviewVideoStatus, currentPaginationNum : $currentPaginationNum, isCornerScreenFocused:$isCornerScreenFocused, currentVideoTitle:$currentVideoTitle, currentVideoDescription:$currentVideoDescription, currentVideoPlayURL:$currentVideoPlayURL, isVideoSectionFocused:$isVideoSectionFocused, isPresentingAlert:$isPresentingAlert)
                    }
                }
            }
        }
    }
}


