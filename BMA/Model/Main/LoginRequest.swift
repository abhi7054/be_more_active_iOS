//
//  LoginRequest.swift
//  BMA
//
//  Created by iMac on 07/07/21.
//

import Foundation

struct LoginRequest: Encodable {
    var email, password: String
    var device, fcmToken: String
}

struct MorePageRequest: Encodable {
  var page: Int
}

struct SignupRequest: Encodable {
    var email: String?
    var name: String?
    var password: String?
    var device : String?
    var categoryRef: [String]?
    var fcmToken : String?
    var activities: [String]?
    
    init(email: String? = nil, name:String? = nil, password:String? = nil, device:String? = nil, categoryRef:[String]? = nil, fcmToken:String? = nil, activities:[String]? = nil){
        
        self.email = email
        self.name = name
        self.password = password
        self.device = device
        self.fcmToken = fcmToken
        self.categoryRef = categoryRef
        self.activities = activities
    }
}

struct ResendVerificationRequest: Encodable {
    var email: String
    var requestType: Int
}


struct CategoryRequest: Encodable {
    var page: Int?
    var limit: Int?
    
    init(page: Int? = nil, limit: Int? = nil){
        
        self.page = page
        self.limit = limit
    }
}


struct UpdateUserRequest: Encodable {
    var name: String?
    var location: String?
    var latitude: Double?
    var longitude: Double?
    var activities: [String]?
    var categoryRef: [String]?
    
    init(name: String? = nil, location: String? = nil, latitude: Double? = nil, longitude: Double? = nil, activities: [String]? = nil, categoryRef: [String]? = nil){
        
        self.name = name
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.activities = activities
        self.categoryRef = categoryRef
    }
}

struct SocialLoginRequest: Encodable {
    var socialId: String?
    var socialToken: String?
    var socialIdentifier: Int?
    var email: String?
    var name: String?
    var picture: String?
    var device : String?
    var fcmToken : String?
    
    init(socialId: String? = nil, socialToken: String? = nil, socialIdentifier: Int? = nil, email: String? = nil, picture: String? = nil, device: String? = nil, fcmToken: String? = nil, name: String? = nil){
        
        self.socialId = socialId
        self.socialToken = socialToken
        self.socialIdentifier = socialIdentifier
        self.email = email
        self.picture = picture
        self.name = name
        self.device = device
        self.fcmToken = fcmToken
    }
}
