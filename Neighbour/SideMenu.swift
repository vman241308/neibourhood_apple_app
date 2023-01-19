//
//  SideMenu.swift
//  SwiftUISideMenuDemo
//
//  Created by Rupesh Chaudhari on 24/04/22.
//

import SwiftUI

var secondaryColor: Color = Color(.init(red: 100 / 255, green: 174 / 255, blue: 255 / 255, alpha: 1))

struct MenuItem: Identifiable {
    var id: Int
    var icon: String
    var text: String
}

var userActions: [MenuItem] = [
    MenuItem(id: 4001, icon: "house", text: "Home"),
    MenuItem(id: 4002, icon: "map", text: "Location"),
    MenuItem(id: 4003, icon: "doc", text: "Info"),
]

var profileActions: [MenuItem] = [
    MenuItem(id: 4004, icon: "wrench.and.screwdriver.fill", text: "Settings"),
    MenuItem(id: 4005, icon: "iphone.and.arrow.forward", text: "Logout"),
]

struct SideMenu: View {
    @Binding var isSidebarVisible: Bool
//    var sideBarWidth = UIScreen.main.bounds.size.width * 0.4
    var sideBarWidth: CGFloat = 450.0
    var menuColor: Color = Color(.init(red: 52 / 255, green: 70 / 255, blue: 182 / 255, alpha: 1))
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
//            .background(.black.opacity(0.6))
//            .opacity(isSidebarVisible ? 1 : 0)
            .animation(.easeInOut.delay(0.2), value: isSidebarVisible)
//            .onTapGesture {
//                isSidebarVisible.toggle()
//            }
            
            content
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    var content: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .top) {
                menuColor
                
                VStack(alignment: .leading, spacing: 20) {
                    Divider()
                    MenuLinks(items: userActions, isExpanded: $isSidebarVisible)
//                    Divider()
//                    MenuLinks(items: profileActions)
                }
                .padding(.top, 50)
                .padding(.horizontal, 30)
            }
            .frame(width: (isSidebarVisible ? sideBarWidth : 100))
            .animation(.default, value: isSidebarVisible)
            
            Spacer()
        }
    }
}

struct MenuLinks: View {
    var items: [MenuItem]
    @Binding var isExpanded: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            ForEach(items) { item in
                menuLink(icon: item.icon, text: item.text, isExpanded: $isExpanded)
            }
        }
        .padding(.vertical, 14)
        .padding(.leading, 8)
    }
}

struct menuLink: View {
    var icon: String
    var text: String
    @Binding var isExpanded: Bool
    var body: some View {
        HStack {
            Button(role: ButtonRole.destructive) {
                isExpanded.toggle()
            } label: {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(secondaryColor)
                if isExpanded {
                    Text(text)
                        .foregroundColor(.white)
                        .font(.body)
                }
            }
//            .frame(width: isExpanded ? 50 : 300)
            
            
        }
    }
}

