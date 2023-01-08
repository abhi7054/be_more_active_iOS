//
//  AppModel.swift
//  cwrnch-ios
//
//  Created by App Knit on 27/12/19.
//  Copyright © 2019 Sukhmani. All rights reserved.
//

import Foundation
//MARK: - AppModel
class AppModel: NSObject {
    static let shared = AppModel()
    
    var currentUser: User!
    var isGuestUser: Bool = Bool()
    var fcmToken: String = ""
    var token = ""
    var device = "iOS"
    var inChatScreen: Bool = Bool()
    var countryCodes: [CountryCodeModel]!
    var appDetail: AppDetail = AppDetail()
    var guestUserType: GuestUserType = .none
    
    func resetAllModel()
    {
        currentUser = nil
        fcmToken = ""
        token = ""
    }
    
    func getIntValue(_ dict : [String : Any], _ key : String) -> Int {
        if let temp = dict[key] as? Int {
            return temp
        }
        else if let temp = dict[key] as? String, temp != "" {
            return Int(temp)!
        }
        else if let temp = dict[key] as? Float {
            return Int(temp)
        }
        else if let temp = dict[key] as? Double {
            return Int(temp)
        }
        return 0
    }
    
}

// MARK: - SuccessModel
struct SuccessModel: Codable {
    let code: Int
    let message, format, timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
    
    init() {
        code = DocumentDefaultValues.Empty.int
        message = DocumentDefaultValues.Empty.string
        format = DocumentDefaultValues.Empty.string
        timestamp = DocumentDefaultValues.Empty.string
    }
}

// MARK: - DataModel
struct DataModel: Codable {
    let code: Int
    let data, message, format, timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent(String.self, forKey: .data) ?? DocumentDefaultValues.Empty.string
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
    
    init() {
        code = DocumentDefaultValues.Empty.int
        message = DocumentDefaultValues.Empty.string
        data = DocumentDefaultValues.Empty.string
        format = DocumentDefaultValues.Empty.string
        timestamp = DocumentDefaultValues.Empty.string
    }
}

//MARK: - CountryCodeModel
struct CountryCodeModel: Codable {
    var name, dial_code, code : String!
    
    init(_ dict : [String : Any]) {
        name = dict["name"] as? String ?? ""
        dial_code = dict["dial_code"] as? String ?? ""
        code = dict["code"] as? String ?? ""
    }
}

//MARK: - CurrentLocation
struct CurrentLocation: Codable{
    var latitude: Double
    var longitude: Double
}
