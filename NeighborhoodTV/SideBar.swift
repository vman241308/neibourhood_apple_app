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
    @State var isDividerFocus1 = false
    @State var isDividerFocus2 = false
    @State var isDividerFocus3 = false
    @State var isSideFocusState = false
    @Binding var isCollapseSideBar:Bool
    @Binding var isPreviewVideoStatus:Bool
    @Binding var isLocationItemFocused:Int
    @Binding var currentVideoPlayURL:String
    @Binding var currentVideoTitle:String
    @Binding var sideBarDividerFlag:Bool
    @Binding var isLocationVisible:Bool
    @FocusState private var isLogoDefaultFocus:Bool
    @FocusState private var isLocationDefaultFocus:Bool
    @FocusState private var isInfoDefaultFocus:Bool
    let pub_isCollapseSideBar = NotificationCenter.default.publisher(for: NSNotification.Name.isCollapseSideBar)
    var body: some View {
        HStack(spacing: 1) {
            VStack {
               /*--------------------------------------*/
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
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke((isSideFocusState ? (isSideHomeFocus == true) ? Color.white : Color.infoMenuColor : isLocationItemFocused == 0 ? Color.white : Color.infoMenuColor), lineWidth: 3)
                )
                .focusable(true) {newState in isSideHomeFocus = newState ; if newState { isSideFocusState = true} else { isSideFocusState = false}; onCollapseStatus()}
                .focused($isLogoDefaultFocus)
                .onLongPressGesture(minimumDuration: 0.001, perform: {isLocationItemFocused = 0 ; onHomeButton()})
                
                /*--------------------------------------*/
                
                Label {
                    if isCollapseSideBar {
                        VStack(alignment: .leading){
                            Text("Choose Stream").font(.custom("Arial Round MT Bold", fixedSize: 25)).padding(.leading, -25).frame(width: 150, alignment: .leading)
                        }
                        
                    }
                } icon: {
                    Image("location").resizable().frame(width: 50, height: 50)
                }
                .padding(20)
                .background(isSideLocationFocus ? Color.gray : Color.infoMenuColor)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke((isSideFocusState ? (isSideLocationFocus == true) ? Color.white : Color.infoMenuColor : isLocationItemFocused == 1 ? Color.white : Color.infoMenuColor), lineWidth: 3)
                )
                .focusable(true) {newState in isSideLocationFocus = newState; if newState { isSideFocusState = true} else { isSideFocusState = false}; onCollapseStatus() }
                .focused($isLocationDefaultFocus)
                .onLongPressGesture(minimumDuration: 0.001, perform: {onLocationButton()})
                
                
                /*--------------------------------------*/
                Label {
                    if isCollapseSideBar {
                        Text("Information").font(.custom("Arial Round MT Bold", fixedSize: 25)).padding(.leading, -25).frame(width: 150, alignment: .leading)
                    }
                } icon: {
                    Image("info").resizable().frame(width: 50, height: 50)
                }
                .padding(20)
                .background(isSideInfoFocus ? Color.gray : Color.infoMenuColor)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke((isSideFocusState ? (isSideInfoFocus == true) ? Color.white : Color.infoMenuColor : isLocationItemFocused == 2 ? Color.white : Color.infoMenuColor), lineWidth: 3)
                )
                .focusable(true) {newState in isSideInfoFocus = newState; if newState { isSideFocusState = true} else { isSideFocusState = false}; onCollapseStatus()}
                .focused($isInfoDefaultFocus)
                .onLongPressGesture(minimumDuration: 0.001, perform: {onInfoButton()})
                
                Spacer()
            }
            .padding(.top, 50)
            .frame(width: (isCollapseSideBar ? 350 : 140 ))
//            .background(isCollapseSideBar ? Color.sideBarCollapseBack : Color.sideBarBack)
            .background(Color.sideBarBack)
            
            if sideBarDividerFlag {
                Divider().focusable(true) { newStat in isDividerFocus1 = newStat ; fromDividerToContent()}
            } else {
                Divider().focusable(isCollapseSideBar ? false : true) { newState in isDividerFocus2 = newState; fromContentToDivider()}
            }
            
            
            Spacer()
        }.padding(.leading, -80)
    }
    

    
    func onCollapseStatus() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .isCollapseSideBar, object: isCollapseSideBar)
        }
    }
    
    func fromDividerToContent() {
        self.isCollapseSideBar = false
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .locationDefaultFocus, object: true)
        }
        
        sideBarDividerFlag = false
    }
    
    func fromContentToDivider() {
        switch isLocationItemFocused {
        case 0:
            self.isLogoDefaultFocus = true
        case 1:
            self.isLocationDefaultFocus = true
        default:
            self.isInfoDefaultFocus = true
        }
        
        self.isCollapseSideBar = true
        sideBarDividerFlag = true
    }
    
    func onInfoButton() {
        isLocationItemFocused = 2
        isCollapseSideBar = false
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
        isCollapseSideBar = false
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .pub_player_stop, object: false)
        }
    }
    
    func onLocationButton() {
        isLocationItemFocused = 1
        isLocationVisible = true
        isCollapseSideBar = false
    }
}
