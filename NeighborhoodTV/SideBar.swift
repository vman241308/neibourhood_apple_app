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
    
    @State var isSideHomeFocus = false
    @State var isSideLocationFocus = false
    @State var isSideInfoFocus = false
    @State var isSideLockFocus = false
    @Binding var isCollapseSideBar:Bool
    @State var isDividerFocus = false
    
    @Binding var isLocationItemFocused:Int
    var body: some View {
        HStack(spacing: 10) {
            VStack {
                Label {
                } icon: {
                    if isCollapseSideBar {
                        Image("logo").resizable().frame(width: 250, height: 50)
                    } else {
                        Image("icon").resizable().frame(width: 50, height: 50)
                    }
                }
                .padding(20)
                .background(isSideHomeFocus ? Color.gray : Color.infoMenuColor)
                .cornerRadius(10)
                .focusable(true) {newState in isSideHomeFocus = newState }
                .onLongPressGesture(minimumDuration: 0.001, perform: {isLocationItemFocused = 0})
                
                Label {
                    if isCollapseSideBar {
                        Text("Choose Stream").font(.custom("Arial Round MT Bold", fixedSize: 25)).padding(.leading, -25).frame(width: 150)
                    }
                } icon: {
                    Image("location").resizable().frame(width: 50, height: 50)
                }
                .padding(20)
                .background(isSideLocationFocus ? Color.gray : Color.infoMenuColor)
                .cornerRadius(10)
                .focusable(true) {newState in isSideLocationFocus = newState }
                .onLongPressGesture(minimumDuration: 0.001, perform: {isLocationItemFocused = 1 })
                
                Label {
                    if isCollapseSideBar {
                        Text("Information").font(.custom("Arial Round MT Bold", fixedSize: 25)).padding(.leading, -25).frame(width: 150)
                    }
                } icon: {
                    Image("info").resizable().frame(width: 50, height: 50)
                }
                .padding(20)
                .background(isSideInfoFocus ? Color.gray : Color.infoMenuColor)
                .cornerRadius(10)
                .focusable(true) {newState in isSideInfoFocus = newState }
                .onLongPressGesture(minimumDuration: 0.001, perform: {isLocationItemFocused = 2 })
                
                Label {
                    if isCollapseSideBar {
                        Text("Lock").font(.custom("Arial Round MT Bold", fixedSize: 25)).padding(.leading, -25).frame(width: 150)
                    }
                } icon: {
                    Image("lock").resizable().frame(width: 50, height: 50)
                }
                .padding(20)
                .background(isSideLockFocus ? Color.gray : Color.infoMenuColor)
                .cornerRadius(10)
                .focusable(true) {newState in isSideLockFocus = newState }
                .onLongPressGesture(minimumDuration: 0.001, perform: {isCollapseSideBar.toggle()})
                
                Spacer()
            }
            .frame(width: (isCollapseSideBar ? 350 : 140 ))
            .background(Color.sideBarBack)
            
          
//            Divider().focusable(true) { newState in isDividerFocus = newState; isSideLockFocus = true}
            Spacer()
        }.padding(.leading, -80)
    }
}

