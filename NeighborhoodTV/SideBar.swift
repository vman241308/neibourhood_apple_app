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
                    
                    
                    NavigationLink(destination: Text("location"), label: {HStack {
                        Image("location").resizable().frame(width: 50, height: 50)
                        Text("Choose Stream").font(.custom("Arial Round MT Bold", fixedSize: 25)).padding(.leading, -25).frame(width: 150)
                        
                    }.frame(width: 250, height: 50)})
                    
                    NavigationLink(destination: Text("3 is selected"), label: {HStack {
                        Image("info").resizable().frame(width: 50, height: 50)
                        Text("Information").font(.custom("Arial Round MT Bold", fixedSize: 25)).padding(.leading, -25).frame(width: 150)
                        
                    }.frame(width: 250, height: 50)})
                    
                    NavigationLink(destination: Text("4 is selected"), label: {HStack {
                        Image("lock").resizable().frame(width: 50, height: 50)
                        Text("Lock").font(.custom("Arial Round MT Bold", fixedSize: 25)).padding(.leading, -25).frame(width: 150)
                        
                    }.frame(width: 250, height: 50)})
                    
                    Spacer()
                }
            }
            .frame(width: 400)
            .background(.black)
            .padding(.leading, 50)
            
            Spacer()
        }
    }
    
    func collapseSideBar() {
        
    }
}
