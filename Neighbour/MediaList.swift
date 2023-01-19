//
//  ContentView.swift
//  TVApp
//
//  Created by fulldev on 1/16/23.
//

import SwiftUI
import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct mediaList: Codable {
    var _id: String
    var title: String
    var description: String
    var thumbnailUrl: String
    var duration: Int
    var play_uri: String
    var access_key: String
}

struct Grid: View {
    var item : mediaList
    @State var isFocused = false
    @Binding var totalFocused : Bool
    
    var body: some View {
        HStack{
            ZStack(alignment: .bottom) {
                AsyncImage(url: URL(string: "\(item.thumbnailUrl)")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 120)
                        .clipped()
                        .shadow(radius: 18, x: 0, y: isFocused ? 50 : 0)
                } placeholder: {
                    placeholderImage()
                }
                Text("\(item.title)")
                    .foregroundColor(.white)
                    .font(.custom("Arial Round MT Bold", fixedSize: 20))
                    .frame(width: 250, height: 40)
                    .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom))
            }
            .border(.white, width: (isFocused ? 8 : 2))
            .frame(width: 250, height: 120)
        }
        .scaleEffect(isFocused ? 1.2 : 1)
        .focusable(true) { newState in isFocused = newState; totalFocused.toggle()}
        .animation(.easeInOut, value: isFocused)
    }
    
    @ViewBuilder
    func placeholderImage() -> some View {
        Image(systemName: "photo")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 250, height: 120)
            .foregroundColor(.gray)
    }
}

struct MediaList: View {
    @Binding var medialListFocused : Bool
    @State var backPaginationFocused : Bool = false
    @State var nextPaginationFocused : Bool = false
    @State var Allitems : [mediaList] = []
    @Binding var currentPagination : Int
    @State var buttonType : String = "Back"
    @State var isProgressViewActive:Bool = true
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let stringAccessToken = String(describing: UserDefaults.standard.object(forKey: "accessToken")).components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0]
    let stringApiBaseURL = String(describing: UserDefaults.standard.object(forKey: "api_base_url")).components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0]
    
    var body: some View {
        VStack {
            ZStack {
                if self.isProgressViewActive {
                    ProgressView("Loading...")
                } else {
                    LazyVGrid(columns: columns) {
                        ForEach(Allitems, id:\._id ) { item in
                            Grid(item: item, totalFocused: $medialListFocused)
                        }
                    }
                    .padding(.horizontal)
//                    .padding(.bottom, 20)
                }
            }
            
            HStack {
                Spacer()
                Text("\(currentPagination) page")
                Text("Next >")
                    .font(.custom("Arial Round MT Bold", fixedSize: 20))
                    .padding(15)
                    .foregroundColor(.black)
                    .border(.white)
                    .background(.white)
                    .clipShape(Capsule())
                    .scaleEffect(nextPaginationFocused ? 1.2 : 1)
                    .focusable(true) { nextState in nextPaginationFocused = nextState; medialListFocused = nextState ; buttonType = "Next"}
                    .animation(.easeInOut, value: nextPaginationFocused)
                    .onLongPressGesture(minimumDuration: 0.01, perform: {onPaginationButton(bType: buttonType)})
            }
        }
        .onAppear(perform: {loadMediaList()})
    }
    /* --------------------------------------PaginationButton------------------------------------------------- */
    func onPaginationButton(bType: String) -> String {
            if Allitems.count < 10 {
                currentPagination += 0
            } else {
                currentPagination += 1 }
        print("---------------->", currentPagination)
        let optionalRetrieveUri = String(describing: UserDefaults.standard.object(forKey: "retrieve_uri"))
        let stringRetrieveUri = optionalRetrieveUri.components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0].components(separatedBy: "[")[0].appending(String(describing: currentPagination)).appending(optionalRetrieveUri.components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0].components(separatedBy: "]")[1])
        
        let offsetMenuListURL = stringApiBaseURL.appending(stringRetrieveUri)
        
        guard let offsetMenuListParseURL = URL(string: offsetMenuListURL) else {
            print("Invalid URL")
            return bType
        }
        
        var offsetMediaListRequest = URLRequest(url: offsetMenuListParseURL)
        offsetMediaListRequest.httpMethod = "POST"
        offsetMediaListRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        offsetMediaListRequest.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
        offsetMediaListRequest.httpBody = jsonData
        offsetMediaListRequest.setValue( "Bearer \(stringAccessToken)", forHTTPHeaderField: "Authorization")
        
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
                guard let offsetMediaListObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                
                guard let offsetMediaListObjectResults = offsetMediaListObject["results"] as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                
                
                guard let offsetMediaListitems = offsetMediaListObjectResults["items"] as? [[String: Any]] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                self.isProgressViewActive = true
                
                for item in offsetMediaListitems {
                    let newMediaItem: mediaList = mediaList(_id: item["_id"] as! String,
                                                            title: item["title"] as! String,
                                                            description: item["description"] as! String,
                                                            thumbnailUrl: item["thumbnailUrl"] as! String,
                                                            duration: item["duration"] as! Int,
                                                            play_uri: item["play_uri"] as! String,
                                                            access_key: item["access_key"] as! String
                    )
                    Allitems.append(newMediaItem)
                    self.isProgressViewActive = false
                }
                
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
        
        
        return bType
    }
    
    /* --------------------------------------MediaList------------------------------------------------- */
    func loadMediaList() {
        currentPagination = 1
        let optionalApiBaseURL = String(describing: UserDefaults.standard.object(forKey: "api_base_url"))
        let stringApiBaseURL = optionalApiBaseURL.components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0]
        
        let optionalHomeSubURI = String(describing: UserDefaults.standard.object(forKey: "home_sub_uri"))
        let stringHomeSubURI = optionalHomeSubURI.components(separatedBy: "Optional(")[1].components(separatedBy: ")")[0]
        
        let menuListURL = stringApiBaseURL.appending(stringHomeSubURI)
        
        guard let menuListParseURL = URL(string: menuListURL) else {
            print("Invalid URL")
            return
        }
        
        /* MenuList */
        var mediaListRequest = URLRequest(url: menuListParseURL)
        mediaListRequest.httpMethod = "POST"
        mediaListRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mediaListRequest.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
        mediaListRequest.httpBody = jsonData
        mediaListRequest.setValue( "Bearer \(stringAccessToken)", forHTTPHeaderField: "Authorization")
        
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
                guard let mediaListObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                
                guard let mediaListObjectResults = mediaListObject["results"] as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                
                guard let items = mediaListObjectResults["items"] as? [[String: Any]] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                
                guard let locations = mediaListObjectResults["location"] as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                
                UserDefaults.standard.set(mediaListObjectResults["retrieve_uri"], forKey: "retrieve_uri")
                UserDefaults.standard.set(locations["access_key"], forKey: "access_key")
                UserDefaults.standard.set(locations["play_uri"], forKey: "play_uri")
                
                for item in items {
                    let mediaItem: mediaList = mediaList(_id: item["_id"] as! String,
                                                         title: item["title"] as! String,
                                                         description: item["description"] as! String,
                                                         thumbnailUrl: item["thumbnailUrl"] as! String,
                                                         duration: item["duration"] as! Int,
                                                         play_uri: item["play_uri"] as! String,
                                                         access_key: item["access_key"] as! String
                    )
                    Allitems.append(mediaItem)
                    self.isProgressViewActive = false
                }
                
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
}
