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
    @State var isDividerFocus = false
    @State var isSideFocusState = false
    @Binding var isCollapseSideBar:Bool
    @Binding var isPreviewVideoStatus:Bool
    @Binding var isLocationItemFocused:Int
    @FocusState private var isSideDefaultFocus:Bool
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
                .onLongPressGesture(minimumDuration: 0.001, perform: {isLocationItemFocused = 0 ; isPreviewVideoStatus = false; sideInFocusState()})
                
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
                .onLongPressGesture(minimumDuration: 0.001, perform: {isLocationItemFocused = 1; sideInFocusState()})
                
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
                .onLongPressGesture(minimumDuration: 0.001, perform: {isLocationItemFocused = 2 ; sideInFocusState()})
                
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
                .focused($isSideDefaultFocus)
                .onLongPressGesture(minimumDuration: 0.001, perform: {isCollapseSideBar.toggle(); sideInFocusState()})
                
                Spacer()
            }
            .frame(width: (isCollapseSideBar ? 350 : 140 ))
            .background(Color.sideBarBack)
            
            Divider().focusable(isSideFocusState ? false : true) { newState in isDividerFocus = newState ; self.isSideDefaultFocus = true}
            
          
//            Divider().focusable(true) { newState in isDividerFocus = newState; isSideLockFocus = true}
            Spacer()
        }.padding(.leading, -80)
    }
    
    func sideInFocusState() {
        if isSideHomeFocus == true || isSideLocationFocus == true || isSideInfoFocus == true || isSideLockFocus == true {
            isSideFocusState = true
        }
        
        print("----->>>>isSideHomeFocus", isSideHomeFocus)
        print("----->>>>isSideLocationFocus", isSideLocationFocus)
        print("----->>>>isSideInfoFocus", isSideInfoFocus)
    }
}

