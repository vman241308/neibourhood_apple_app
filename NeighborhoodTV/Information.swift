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

struct Information: View {
    @State var infoCurrentTitle:String = ""
    @State var infoCurrentBody = NSAttributedString()
    @State var isInfoAboutUSFocus = false
    @State var isInfoPrivacyPolicyFocus = false
    @State var isInfoVisitorAgreementFocus = false
    @State var isCurrentInfoClick: Int = 1
    
    @Binding var sideBarDividerFlag:Bool
    @Binding var isCollapseSideBar:Bool
    
    @FocusState private var InfoDefaultFocus: Bool
    @FocusState private var isInfoDefaultFocus:Bool
    
    let textView = UITextView()
    
    let pub_default_focus = NotificationCenter.default.publisher(for: NSNotification.Name.locationDefaultFocus)
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 30) {
                Label {
                    Text("About Us").font(.custom("Arial Round MT Bold", fixedSize: 30)).padding(.leading, -25).frame(width: 250)
                } icon: {
                    Image(systemName: "person.3").resizable().frame(width: 40, height: 25)
                }
                .padding(20)
                .background(isInfoAboutUSFocus ? Color.infoFocusColor : Color.infoMenuColor)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke((isCurrentInfoClick == 1 ? Color.white : Color.infoMenuColor), lineWidth: 1)
                )
                .focusable(isCollapseSideBar ? false : true) {newState in isInfoAboutUSFocus = newState }
                .focused($isInfoDefaultFocus)
                .onLongPressGesture(minimumDuration: 0.001, perform: {isCurrentInfoClick = 1; getCurrentInfo()})
                .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        self.isInfoDefaultFocus = true
                        sideBarDividerFlag = false
                    }
                }
                .onReceive(pub_default_focus) { (out_location_default) in
                    guard let _out_location_default = out_location_default.object as? Bool else {
                        print("Invalid URL")
                        return
                    }
                    if _out_location_default {
                        self.isInfoDefaultFocus = true
                    }
                }
                
                Label {
                    Text("Privacy Policy").font(.custom("Arial Round MT Bold", fixedSize: 30)).padding(.leading, -25).frame(width: 250)
                } icon: {
                    Image(systemName: "exclamationmark.shield").resizable().frame(width: 40, height: 40)
                }
                .padding(20)
                .background(isInfoPrivacyPolicyFocus ? Color.infoFocusColor : Color.infoMenuColor)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke((isCurrentInfoClick == 2 ? Color.white : Color.infoMenuColor), lineWidth: 1)
                )
                .focusable(isCollapseSideBar ? false : true) {newState in isInfoPrivacyPolicyFocus = newState }
                .onLongPressGesture(minimumDuration: 0.001, perform: {isCurrentInfoClick = 2; getCurrentInfo()})
                
                Label {
                    Text("Visitor Agreement").font(.custom("Arial Round MT Bold", fixedSize: 30)).padding(.leading, -25).frame(width: 250)
                } icon: {
                    Image(systemName: "printer").resizable().frame(width: 40, height: 40)
                }
                .padding(20)
                .background(isInfoVisitorAgreementFocus ? Color.infoFocusColor : Color.infoMenuColor)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke((isCurrentInfoClick == 3 ? Color.white : Color.infoMenuColor), lineWidth: 1)
                )
                .focusable(isCollapseSideBar ? false : true) {newState in isInfoVisitorAgreementFocus = newState }
                .onLongPressGesture(minimumDuration: 0.001, perform: {isCurrentInfoClick = 3; getCurrentInfo()})
                
                Spacer()
            }
            .frame(width: 450)
            .padding(.leading, 50)
            .padding(.top, 50)
            .background(Color.infoMenuColor)
            
            ScrollView {
                ScrollViewReader { proxy in
                    VStack(alignment: .center, spacing: 30) {
                        Text("\(infoCurrentTitle)").font(.custom("Arial Round MT Bold", fixedSize: 40))
                        Text(infoCurrentBody.string)
                        Spacer()
                    }
                    .onAppear() {
                        getCurrentInfo()
                    }.focusable(isCollapseSideBar ? false : true)
                        .frame(height: 900)
                }
            }.frame(height: 900).focusable(false)
            Spacer()
            
        }
        
    }
    
    func getCurrentInfo() {
        switch isCurrentInfoClick {
        case 2:
            guard let _title_privacy_policy = UserDefaults.standard.object(forKey: "privacy_policy_seo_title") as? String else {
                print("Invalid _title_about_us")
                return
            }
            
            guard let _body_privacy_policy = UserDefaults.standard.object(forKey: "privacy_policy_page_body") as? String else {
                print("Invalid _title_about_us")
                return
            }
            
            infoCurrentTitle = _title_privacy_policy
            let htmlData = NSString(string: _body_privacy_policy).data(using: String.Encoding.unicode.rawValue)
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
            let attributedString  = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
            infoCurrentBody = attributedString
        case 3:
            guard let _title_visitor_agreement = UserDefaults.standard.object(forKey: "visitor_agreement_seo_title") as? String else {
                print("Invalid _title_about_us")
                return
            }
            
            guard let _body_visitor_agreement = UserDefaults.standard.object(forKey: "visitor_agreement_page_body") as? String else {
                print("Invalid _title_about_us")
                return
            }
            
            infoCurrentTitle = _title_visitor_agreement
            let htmlData = NSString(string: _body_visitor_agreement).data(using: String.Encoding.unicode.rawValue)
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
            let attributedString  = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
            infoCurrentBody = attributedString
        default:
            guard let _title_about_us = UserDefaults.standard.object(forKey: "about_us_seo_title") as? String else {
                print("Invalid _title_about_us")
                return
            }
            
            guard let _body_about_us = UserDefaults.standard.object(forKey: "about_us_page_body") as? String else {
                print("Invalid _title_about_us")
                return
            }
            
            infoCurrentTitle = _title_about_us
            let htmlData = NSString(string: _body_about_us).data(using: String.Encoding.unicode.rawValue)
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
            let attributedString  = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
            infoCurrentBody = attributedString
        }
    }
}
