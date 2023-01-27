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


extension Color {
    static let titleBack =  Color(red: 61/255, green: 57/255, blue: 58/255)
}

struct GridLocationItem: View {
    var locationItem: LocationModel
    @State var isLocationItemFocused = false
    
    var body: some View {
        HStack {
            ZStack(alignment: .bottom) {
                AsyncImage(url: URL(string: "\(locationItem.thumbnailUrl)")) { imageItem in
                    imageItem
                        .resizable()
                        .scaledToFit()
                        .frame(width: 360, height: 200)
                        .clipped()
                        .cornerRadius(25)
                } placeholder: {
                placeholderLocationItemImage()
                    .frame(width: 360, height: 200)
            }
                
                Text("\(locationItem.title)")
                    .foregroundColor(.white)
                    .font(.custom("Arial Round MT Bold", fixedSize: 20))
                    .frame(width: 360, height: 30)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .background(Color.titleBack)
            }
            .cornerRadius(25)
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(.white, lineWidth: (isLocationItemFocused ? 8 : 2)))
        }
        .scaleEffect(isLocationItemFocused ? 1.1 : 1)
        .focusable(true) {newState in isLocationItemFocused = newState}
        .animation(.easeInOut, value: isLocationItemFocused)
        .onLongPressGesture(minimumDuration: 0.001, perform: {onLocationItem()})
    }
    
    func placeholderLocationItemImage() ->  some View {
        Image(systemName: "image")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 360, height: 200)
            .foregroundColor(.gray)
            .cornerRadius(25)
    }
    
    func onLocationItem() {
        do {
            print("--------------------location?")
        } catch {
            print("Error: Trying to convert JSON data to string", error)
            return
        }
    }
    
}

struct Location: View {
    @Binding var allLocationItems:[LocationModel]
    let locationColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            Text("Choose Location below")
                .foregroundColor(.white)
                .font(.custom("Arial Round MT Bold", fixedSize: 30))
                .frame(width: 360, height: 30)
                .padding(.bottom, 10)
            
            LazyVGrid(columns: locationColumns) {
                ForEach(allLocationItems, id:\._id) { locationItem in
                    GridLocationItem(locationItem:locationItem)
                }
            }.frame(width: 1500)
        }
    }
}
