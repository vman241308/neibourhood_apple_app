//
//  Information.swift
//  NeighborhoodTV
//
//  Created by fulldev on 1/27/23.
//

import Foundation
import SwiftUI

//extension Color {
//    static let titleBack =  Color(red: 61/255, green: 57/255, blue: 58/255)
//}

struct Information: View {
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
//                    GridLocationItem(locationItem:locationItem)
                }
            }.frame(width: 1500)
        }
    }
}
