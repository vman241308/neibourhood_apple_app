//
//  ContentView.swift
//  SwiftUISideMenuDemo
//
//  Created by Rupesh Chaudhari on 24/04/22.
//

import SwiftUI

struct ContentView: View {
    @State private var isSideBarOpened = false
    
    var body: some View {
        ZStack {
            SideMenu(isSidebarVisible: $isSideBarOpened)
            Button(role: ButtonRole.destructive) {
                isSideBarOpened.toggle()
            } label: {
                Label("Toggle SideBar", systemImage: "line.3.horizontal.circle.fill")
            }
            
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
