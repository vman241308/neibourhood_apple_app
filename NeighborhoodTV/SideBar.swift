//
//  SideBar.swift
//  NeighborhoodTV
//
//  Created by fulldev on 2/2/23.
//

import Foundation
import SwiftUI
import AVKit

struct SideBar: View {
    var body: some View {
        HStack {
            NavigationView {
                VStack {
                    NavigationLink(destination: Text("1 is selected"), label: {Image("logo").resizable().frame(width: 250, height: 50)})
                        .frame(width: 300)
//                    NavigationLink(destination: Text("2 is selected"), label: {Label {
//                        Text("Choose Stream").font(.custom("Arial Round MT Bold", fixedSize: 25))
//                    } icon: {
//                        Image("location").resizable().frame(width: 50, height: 50)
//                    }
//                        .frame(width: 250, height: 50)})
                    HStack {
                        Image("logo").resizable().frame(width: 250, height: 50)
                        Spacer()
                    }.frame(width: 300, height: 50)
                    
                    HStack {
                        Image("location").resizable().frame(width: 50, height: 50)
                        Text("Choose Stream").font(.custom("Arial Round MT Bold", fixedSize: 25))
                            .frame(width: 250, height: 50)
             
                    }.frame(width: 300, height: 50)
                    
                    NavigationLink(destination: Text("3 is selected"), label: {HStack {
                        Image("info").resizable().frame(width: 50, height: 50)
                        Text("Info").font(.custom("Arial Round MT Bold", fixedSize: 25))
                        Spacer()
                    }.frame(width: 250, height: 50)})
                    
                    NavigationLink(destination: Text("4 is selected"), label: {HStack {
                        Image("lock").resizable().frame(width: 50, height: 50)
                        Text("Lock").font(.custom("Arial Round MT Bold", fixedSize: 25))
                        Spacer()
                    }.frame(width: 250, height: 50)})
                }
            }
            //            .frame(width: 450)
            //            .padding(.leading, -120)
            //            .padding(.trailing, 100)
            //            .background(.red)
            Spacer()
        }
    }
}
