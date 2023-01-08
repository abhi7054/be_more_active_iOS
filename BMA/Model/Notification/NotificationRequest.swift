//
//  NotificationRequest.swift
//  BMA
//
//  Created by iMac on 16/07/21.
//

import Foundation

//MARK: - NotificationRequest
struct NotificationRequest: Encodable {
    var page: Int?
    var limit: Int?
    
    init(page: Int? = nil, limit: Int? = nil){
        
        self.page = page
        self.limit = limit
    }
}

//MARK: - NotificationSeenRequest
struct NotificationSeenRequest: Encodable {
    var notificationId: String
}
