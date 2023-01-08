//
//  EventListRequest.swift
//  BMA
//
//  Created by MACBOOK on 08/07/21.
//

import UIKit
import CoreLocation

//MARK: - EventListRequest
struct EventListRequest: Encodable {
    var longitude: Double?
    var latitude: Double?
    var date: Int?
    var startDate: String?
    var endDate: String?
    var minDistance: Int?
    var maxDistance: Int?
    var page: Int?
    
    init(longitude: Double? = nil, latitude: Double? = nil, text: String? = nil, startDate: String? = nil, endDate: String? = nil, minDistance: Int? = nil, maxDistance: Int? = nil, date: Int? = nil, page: Int? = nil) {
        self.longitude = longitude
        self.latitude = latitude
        self.date = date
        self.startDate = startDate
        self.endDate = endDate
        self.minDistance = minDistance
        self.maxDistance = maxDistance
        self.date = date
        self.page = page
    }
}

//MARK: - EventSearchRequest
struct EventSearchRequest: Encodable {
    var longitude: Double?
    var latitude: Double?
    var date: Date?
    var text: String?
    
    init(longitude: Double? = nil, latitude: Double? = nil, date: Date? = nil, text: String? = nil) {
        self.longitude = longitude
        self.latitude = latitude
        self.date = date
        self.text = text
    }
}

//MARK: - EventDetailRequest
struct EventDetailRequest: Encodable {
    var eventRef: String
}

//MARK: - AddEventRequest
struct AddEventRequest: Encodable {
    var name: String?
    var images: [String]?
    var description: String?
    var address: String?
    var longitude, latitude: Double?
    var categoryRef, activityRef: String?
    var seats: Int?
    var startDate, endDate, startTime, endTime: String?
    var reviews, coupons, `repeat` : Bool?
    var phonecode, phoneNumber: String?
    var eventEmail, instagramUrl: String?
    var facebookUrl, websiteUrl: String?
    var eventRef, couponCode, couponDescription: String?
    
    init(eventRef : String? = nil, name: String? = nil, images: [String]? = nil, description: String? = nil, address: String? = nil, longitude: Double? = nil, latitude: Double? = nil, categoryRef: String? = nil, activityRef: String? = nil, seats: Int? = nil, startDate: String? = nil, endDate: String? = nil, startTime: String? = nil, endTime: String? = nil, reviews: Bool? = nil, coupons: Bool? = nil, repeat: Bool? = nil, phonecode: String? = nil, phoneNumber: String? = nil, eventEmail: String? = nil, instagramUrl: String? = nil, facebookUrl: String? = nil, couponCode: String? = nil, websiteUrl: String? = nil, couponDescription: String? = nil) {
        self.eventRef = eventRef
        self.name = name
        self.images = images
        self.description = description
        self.address = address
        self.longitude = longitude
        self.latitude = latitude
        self.categoryRef = categoryRef
        self.activityRef = activityRef
        self.seats = seats
        self.startDate = startDate
        self.endDate = endDate
        self.startTime = startTime
        self.endTime = endTime
        self.reviews = reviews
        self.coupons = coupons
        self.repeat = `repeat`
        self.phonecode = phonecode
        self.phoneNumber = phoneNumber
        self.eventEmail = eventEmail
        self.instagramUrl = instagramUrl
        self.facebookUrl = facebookUrl
        self.websiteUrl = websiteUrl
        self.couponCode = couponCode
        self.couponDescription = couponDescription
    }
}

//MARK: - ReportRequest
struct ReportRequest: Encodable {
    var eventRef: String
    var reason: String
}

//MARK: - BookEventRequest
struct BookEventRequest: Encodable {
    var eventRef: String
}

//MARK: - ReportRequest
struct AddFavoriteRequest: Encodable {
    var eventRef: String
    var status: Bool
}

//MARK: - RatingListRequest
struct ListRequest: Encodable {
    var eventRef: String
    var page: Int
}

//MARK: - AddRatingRequest
struct AddRatingRequest: Encodable {
    var eventRef: String
    var rating: Int
    var review: String
}

//MARK: - DeleteImageRequest
struct DeleteImageRequest: Encodable {
    var image: String
}

//MARK: - CalendarListRequest
struct CalendarListRequest: Encodable {
    var date: Int
    var dateTime: String
}

//MARK: - SubscriptionRequest
struct SubscriptionRequest: Encodable {
    var receiptId: String
    var device: String = "ios"
}
