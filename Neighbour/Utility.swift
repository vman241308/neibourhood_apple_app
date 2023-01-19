//
//  Utility.swift
//  Neighbour
//
//  Created by fulldev on 1/17/23.
//

import Foundation

struct TokenResponse:Codable {
    var message: String
    var code: String
    var systemTime: Int
    var status: String
    var results: TokenResponseResults
}

struct TokenResponseResults:Codable {
    var config: TokenResponseResultsConfig
    var geoip: TokenResponseResultsGeoip
    var home_uri: String
    var refreshToken: String
    var location: [TokenResponseResultsLocation]
    var accessToken: String
    var userInfo: TokenResponseResultsUserInfo
}

struct TokenResponseResultsConfig:Codable {
    var api_about_us: String
    var api_base_url : String
    var api_privacy_policy : String
    var api_visitor_agreement : String
    var api_refresh_token : String
    var app_exit_dialog_show : String
    var header_background : String
    var company_details: TokenResponseResultsConfigCompanyDetails
}

struct TokenResponseResultsConfigCompanyDetails:Codable {
    var phone :String
    var address : String
    var logo_dark : String
    var icon : String
    var copyright : String
    var email : String
    var favicon : String
    var description : String
    var name : String
    var logo : String
}

struct TokenResponseResultsGeoip:Codable {
    var state: String
    var continent: String
    var countryName: String
    var longitude: Float
    var ipAddress: String
    var latitude: Float
    var stateName: String
    var zipcode: String
    var city: String
    var timezone: String
    var continentName: String
    var country: String
}

struct TokenResponseResultsLocation:Codable {
    var _id : String
    var title : String
    var uri : String
    var thumbnailUrl : String
}

struct TokenResponseResultsUserInfo:Codable {
    var type : String
    var firstName : String
    var lastName : String
}

/* Create Model */
struct UploadData: Codable {
    let version_name: String
    let device_id: String
    let device_model: String
    let version_code: String
    let device_type: String
}

let uploadDataModel = UploadData(version_name: "1.0", device_id: "1", device_model: "1", version_code: "1.0", device_type: "Fire TV")
let jsonData = try? JSONEncoder().encode(uploadDataModel)
/* default parameter */

var mlist = [mediaList]()
let tokenURL = "https://api.watchntv.tv/v2/user"
var vURL : String = ""

func getToken() {
    guard let tokenParseURL = URL(string: tokenURL) else {
        print("Invalid URL")
        return
    }
    var request = URLRequest(url: tokenParseURL)
    request.httpMethod = "POST"
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
    request.httpBody = jsonData
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard error == nil else {
            print("Error: error calling POST")
            print(error!)
            return
        }
        guard let data = data else {
            print("Error: Did not receive data")
            return
        }
        guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
            print("Error: HTTP request failed")
            return
        }
        do {
            guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("Error: Cannot convert data to JSON object")
                return
            }
            
            guard let responseResults = jsonObject["results"] as? [String: Any] else {
                print("Error: Cannot convert data to JSON object")
                return
            }
            UserDefaults.standard.set(responseResults["accessToken"], forKey: "accessToken")
            UserDefaults.standard.set(responseResults["home_uri"], forKey: "home_sub_uri")
            
            guard let responseConfig = responseResults["config"] as? [String: Any] else {
                print("Error: Cannot convert data to JSON object")
                return
            }
            UserDefaults.standard.set(responseConfig["api_base_url"], forKey: "api_base_url")
            
        } catch {
            print("Error: Trying to convert JSON data to string")
            return
        }
    }.resume()
}





