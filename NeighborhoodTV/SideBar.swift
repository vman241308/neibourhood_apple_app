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
    @State var isDividerFocus1 = false
    @State var isDividerFocus2 = false
    @State var isSideFocusState = false
    @Binding var isCollapseSideBar:Bool
    @Binding var isPreviewVideoStatus:Bool
    @Binding var isLocationItemFocused:Int
    @Binding var currentVideoPlayURL:String
    @Binding var currentVideoTitle:String
    @Binding var sideBarDividerFlag:Bool
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
                .focusable(true) {newState in isSideHomeFocus = newState ; if newState { isSideFocusState = true} else { isSideFocusState = false}}
                .onLongPressGesture(minimumDuration: 0.001, perform: {isLocationItemFocused = 0 ; onHomeButton()})
                
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
                .focusable(true) {newState in isSideLocationFocus = newState; if newState { isSideFocusState = true} else { isSideFocusState = false} }
                .onLongPressGesture(minimumDuration: 0.001, perform: {isLocationItemFocused = 1})
                
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
                .focusable(true) {newState in isSideInfoFocus = newState; if newState { isSideFocusState = true} else { isSideFocusState = false}}
                .onLongPressGesture(minimumDuration: 0.001, perform: {isLocationItemFocused = 2})
                
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
                .focusable(true) {newState in isSideLockFocus = newState; if newState { isSideFocusState = true} else { isSideFocusState = false}}
                .focused($isSideDefaultFocus)
                .onLongPressGesture(minimumDuration: 0.001, perform: {isCollapseSideBar.toggle(); })
                
                Spacer()
            }
            .frame(width: (isCollapseSideBar ? 350 : 140 ))
            .background(Color.sideBarBack)
            
            if sideBarDividerFlag {
               
                Divider().focusable(true) { newStat in isDividerFocus1 = newStat ; fromDividerToContent()}
            } else {
                
                Divider().focusable(true) { newState in isDividerFocus2 = newState; fromContentToDivider()}
            }
            
            
            Spacer()
        }.padding(.leading, -80)
    }
    
    func fromDividerToContent() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .locationDefaultFocus, object: true)
        }
        sideBarDividerFlag = false
    }
    
    func fromContentToDivider() {
        self.isSideDefaultFocus = true
        sideBarDividerFlag = true
    }
    
    func onHomeButton() {
        guard let _originalVideoPlayURL = UserDefaults.standard.object(forKey: "original_uri") as? String else {
            print("Invalid URL")
            return
        }
        
        guard let _currentVideoTitle = UserDefaults.standard.object(forKey: "original_title") as? String else {
            print("Invalid Title")
            return
        }
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .dataDidFlow, object: _originalVideoPlayURL)
        }
        
        currentVideoPlayURL = _originalVideoPlayURL
        currentVideoTitle = _currentVideoTitle
        isPreviewVideoStatus = false
    }
}
