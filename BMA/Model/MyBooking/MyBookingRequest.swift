//
//  MyBookingRequest.swift
//  BMA
//
//  Created by iMac on 13/07/21.
//

import Foundation

struct MyBookingListRequest: Encodable {
    var bookingType: BOOKING_STATUS?
    var page: Int?
    var limit: Int?
    var dateFrom, dateTo: String?
    init(bookingType: BOOKING_STATUS? = nil, page: Int? = nil, limit: Int? = nil, dateTo: String? = nil, dateFrom: String? = nil){
        
        self.bookingType = bookingType
        self.page = page
        self.limit = limit
        self.dateTo = dateTo
        self.dateFrom = dateFrom
    }
}

struct MyBookingaAddRequest: Encodable {
    var eventRef: String?
    
    init(eventRef: String? = nil) {
        
         self.eventRef = eventRef
    }
}

struct MyBookingaCancelRequest: Encodable {
    var eventRef: String?
    
    init(eventRef: String? = nil) {
        
         self.eventRef = eventRef
    }
}

struct MyBookingDetailsRequest: Encodable {
    var eventRef: String?
    var userRef: String?
    
    init(eventRef: String? = nil, userRef: String? = nil) {
        
         self.eventRef = eventRef
        self.userRef = userRef
    }
}
