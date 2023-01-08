//
//  ProfileRequest.swift
//  BMA
//
//  Created by iMac on 12/07/21.
//

import Foundation

struct ActivityListRequest: Encodable {
    var categoryRef: [String]?
    var page: Int?
    var limit: Int?
    
    init(categoryRef: [String]? = nil, page: Int? = nil, limit: Int? = nil){
        self.categoryRef = categoryRef
        self.page = page
        self.limit = limit
    }
}

struct DiscountAddRequest: Encodable {
    var discountCode: String?
    var description: String?
    
    init(discountCode: String? = nil, description: String? = nil){
        
        self.discountCode = discountCode
        self.description = description
    }
}

struct DiscountListRequest: Encodable {
    var userRef: String?
    var page: Int?
    var limit: Int?
    
    init(userRef: String? = nil, page: Int? = nil, limit: Int? = nil){
        
        self.userRef = userRef
        self.page = page
        self.limit = limit
    }
}

struct EventsLeaguesRequest: Encodable {
    var page: Int?
    var limit: Int?
    init(page: Int? = nil, limit: Int? = nil){
        self.page = page
        self.limit = limit
    }
}

struct ContactAdminRequest: Encodable {
    var message: String
}
