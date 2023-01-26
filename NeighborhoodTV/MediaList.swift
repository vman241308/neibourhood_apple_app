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
    @State var currentVideoPlayURL:String = ""
    @Binding var isCornerScreenFocused:Bool
    var body: some View {
        HStack{
            ZStack(alignment: .bottom) {
//                AsyncImage(url: URL(string: "\(item.thumbnailUrl)")) { image in
                    AsyncImage(url: URL(string: "file:///Users/fulldev/Documents/temp/AppleTV-app/NeighborhoodTV/Assets.xcassets/splashscreen.jpg")) { image in
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
        .focusable(true) { newState in
            isFocused = newState;
            if newState {
                isPreviewVideoStatus = true
            }
            onCheckCurrentPositon()}
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
        if (item.itemIndex <= allMediaItems.count && item.itemIndex > (allMediaItems.count - 5)){
            currentPaginationNum = allMediaItems.count
            let optionalRetrieveUri = String(describing: UserDefaults.standard.object(forKey: "retrieve_uri"))
            let retrieveUri = optionalRetrieveUri.components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0].components(separatedBy: "[")[0].appending(String(describing: currentPaginationNum)).appending(optionalRetrieveUri.components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0].components(separatedBy: "]")[1])
            
            let accessToken = String(describing: UserDefaults.standard.object(forKey: "accessToken")).components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0]
            
            let apiBaseURL = String(describing: UserDefaults.standard.object(forKey: "api_base_url")).components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0]
            
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
                guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                    print("Error: HTTP request failed")
                    return
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
                    print("Error: Trying to convert JSON data to string")
                    return
                }
            }.resume()
        }
    }
    
    func onVideoDescription() {
        let accessToken = String(describing: UserDefaults.standard.object(forKey: "accessToken")).components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0]
        
        let apiBaseURL = String(describing: UserDefaults.standard.object(forKey: "api_base_url")).components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0]
        
        guard let previewVideoParseURL = URL(string: apiBaseURL.appending(item.play_uri)) else {
            print("Invalid URL")
            return
        }
        
        let accessKeyDataModel = AccessKeyData(version_name: "1.0", device_id: "1", device_model: "1", version_code: "1.0", device_type: "Fire TV", access_key: item.access_key)
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
                
                print("--------title",jsonPreviewVideoObject)
                
//                UserDefaults.standard.set(jsonMediaListLocation["title"], forKey: "currentVideoTitle")
                
                currentVideoPlayURL = String(describing: jsonPreviewVideoResults["uri"]).components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0]
                PreviewVideo(currentVideoPlayURL: $currentVideoPlayURL)
                isCornerScreenFocused = false
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
}


struct MediaList: View {
    @Binding var allMediaItems:[MediaListType]
    @Binding var isPreviewVideoStatus:Bool
    @Binding var currentPaginationNum:Int
    @Binding var isCornerScreenFocused:Bool
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
        ScrollView() {
            LazyVGrid(columns: columns) {
                ForEach(allMediaItems, id:\._id ) { item in
                    Grid(item: item, allMediaItems:$allMediaItems, isPreviewVideoStatus : $isPreviewVideoStatus, currentPaginationNum : $currentPaginationNum, isCornerScreenFocused:$isCornerScreenFocused)
                }
            }
        }
    }
}

