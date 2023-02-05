//
//  Information.swift
//  NeighborhoodTV
//
//  Created by fulldev on 1/27/23.
//

import Foundation
import SwiftUI

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Color {
    static let menuColor =  Color(red: 61/255, green: 57/255, blue: 58/255)
}

struct Information: View {
    @State var infoCurrentTitle:String = ""
    @State var infoCurrentBody:String = ""
    @FocusState private var InfoDefaultFocus: Bool
    @State var isInfoAboutUSFocus = false
    @State var isInfoPrivacyPolicyFocus = false
    @State var isInfoVisitorAgreementFocus = false
    @State var isCurrentInfoClick: Int = 1
    let locationColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 30) {
                Label {
                    Text("About Us")
                } icon: {
                    Image(systemName: "person.3").resizable().frame(width: 40, height: 30)
                }
                .frame(width: 350)
                .padding(10)
                .background(isInfoAboutUSFocus ? Color.infoFocusColor : Color.infoMenuColor)
                .cornerRadius(10)
                .focusable(true) {newState in isInfoAboutUSFocus = newState }
                .onLongPressGesture(minimumDuration: 0.001, perform: {getCurrentInfo(isCurrentInfoClick: 1)})
                
                Label {
                    Text("Privacy Policy")
                } icon: {
                    Image(systemName: "exclamationmark.shield").resizable().frame(width: 40, height: 40)
                }
                .frame(width: 350)
                .padding(10)
                .background(isInfoPrivacyPolicyFocus ? Color.infoFocusColor : Color.infoMenuColor)
                .cornerRadius(10)
                .focusable(true) {newState in isInfoPrivacyPolicyFocus = newState }
                .onLongPressGesture(minimumDuration: 0.001, perform: {getCurrentInfo(isCurrentInfoClick: 2)})
                
                Label {
                    Text("Visitor Agreement")
                } icon: {
                    Image(systemName: "printer").resizable().frame(width: 40, height: 40)
                }
                .frame(width: 350)
                .padding(10)
                .background(isInfoVisitorAgreementFocus ? Color.infoFocusColor : Color.infoMenuColor)
                .cornerRadius(10)
                .focusable(true) {newState in isInfoVisitorAgreementFocus = newState }
                .onLongPressGesture(minimumDuration: 0.001, perform: {getCurrentInfo(isCurrentInfoClick: 3)})
                
                Spacer()
            }
            .frame(width: 450)
            .background(Color.infoMenuColor)
            
            
            VStack(alignment: .center, spacing: 30) {
                ScrollView {
                        Text("\(infoCurrentTitle)").font(.custom("Arial Round MT Bold", fixedSize: 40))
                        Text("\(infoCurrentBody)")
                        Spacer()
                }
            }.onAppear() {
                getCurrentInfo(isCurrentInfoClick: 1)
            }.focusable(true)
                .background(.red)
                .frame(height: 900)
            
            Spacer()
            
        }
        
    }
    
    func getCurrentInfo(isCurrentInfoClick: Int) -> Int {
        switch isCurrentInfoClick {
        case 2:
            guard let _title_privacy_policy = UserDefaults.standard.object(forKey: "privacy_policy_seo_title") as? String else {
                print("Invalid _title_about_us")
                return isCurrentInfoClick
            }
            
            guard let _body_privacy_policy = UserDefaults.standard.object(forKey: "privacy_policy_page_body") as? String else {
                print("Invalid _title_about_us")
                return isCurrentInfoClick
            }
            
            infoCurrentTitle = _title_privacy_policy
            infoCurrentBody = _body_privacy_policy
            
        case 3:
            guard let _title_visitor_agreement = UserDefaults.standard.object(forKey: "visitor_agreement_seo_title") as? String else {
                print("Invalid _title_about_us")
                return isCurrentInfoClick
            }
            
            guard let _body_visitor_agreement = UserDefaults.standard.object(forKey: "visitor_agreement_page_body") as? String else {
                print("Invalid _title_about_us")
                return isCurrentInfoClick
            }
            
            infoCurrentTitle = _title_visitor_agreement
            infoCurrentBody = _body_visitor_agreement
        default:
            guard let _title_about_us = UserDefaults.standard.object(forKey: "about_us_seo_title") as? String else {
                print("Invalid _title_about_us")
                return isCurrentInfoClick
            }
            
            guard let _body_about_us = UserDefaults.standard.object(forKey: "about_us_page_body") as? String else {
                print("Invalid _title_about_us")
                return isCurrentInfoClick
            }
            
            infoCurrentTitle = _title_about_us
            infoCurrentBody = _body_about_us
        }
        
        return isCurrentInfoClick
        
    }
    
    
}
