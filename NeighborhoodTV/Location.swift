//
//  Location.swift
//  NeighborhoodTV
//
//  Created by fulldev on 1/21/23.
//

import SwiftUI
import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct GridLocationItem: View {
    var locationItem: LocationModel
    @Binding var isLocationItemFocused:Bool
    
    var body: some View {
        HStack {
            ZStack(alignment: .bottom) {
                AsyncImage(url: URL(string: "\(locationItem.thumbnailUrl)")) { imageItem in
                    imageItem
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 200)
                        .clipped()
                } placeholder: {
                    placeholderLocationItemImage()
                        .frame(width: 400, height: 200)
                }
                
                Text("\(locationItem.title)")
                    .foregroundColor(.white)
                    .font(.custom("Arial Round MT Bold", fixedSize: 30))
                    .frame(width: 400, height: 30)
            }
            .border(.white, width:(isLocationItemFocused ? 10 : 0))
        }
        .scaleEffect(isLocationItemFocused ? 1.2 : 1)
        .focusable(true) {newState in isLocationItemFocused = newState}
        .animation(.easeInOut, value: isLocationItemFocused)
        .onLongPressGesture(minimumDuration: 0.001, perform: {onLocationItem()})
    }
    
    func placeholderLocationItemImage() ->  some View {
        Image(systemName: "image")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 400, height: 200)
            .foregroundColor(.gray)
    }
    
    func onLocationItem() {
        print("--------------------location?")
    }
    
}

struct Location: View {
    @Binding var allLocationItems:[LocationModel]
    @Binding var isLocationItemFocused:Bool
    let locationColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            LazyVGrid(columns: locationColumns) {
                ForEach(allLocationItems, id:\._id) { locationItem in
                    GridLocationItem(locationItem:locationItem, isLocationItemFocused:$isLocationItemFocused)
                }
            }
        }
    }
}
