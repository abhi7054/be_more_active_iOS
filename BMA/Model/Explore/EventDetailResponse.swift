//
//  EventDetailResponse.swift
//  BMA
//
//  Created by MACBOOK on 09/07/21.
//

import Foundation

// MARK: - EventDetailResponse
struct EventDetailResponse: Codable {
    let format: String
    let data: EventDetail
    let code: Int
    let message: String
    let timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent(EventDetail.self, forKey: .data) ?? EventDetail()
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - EventDetail
struct EventDetail: Codable {
    let datumDescription, categoryName, facebookURL: String
    let rating: Double
    let instagramURL, userRef, id: String
    let type: EVENT_TYPE
    let endDate, websiteURL: String
    let contactDetails: ContactDetails
    let location: Location
    let endTime, activityName: String
    let seats, memberJoined: Int
    let images: [String]
    let startDate, startTime, name: String
    var isFav: Bool
    let coupons, reviews, `repeat`: Bool
    let activity, category, couponCode, couponDescription: String
    
    enum CodingKeys: String, CodingKey {
        case datumDescription = "description"
        case categoryName
        case facebookURL = "facebookUrl"
        case rating
        case instagramURL = "instagramUrl"
        case websiteURL = "websiteUrl"
        case userRef, coupons, reviews, `repeat`
        case id = "_id"
        case couponDescription
        case type, endDate, contactDetails, location, endTime, activityName, seats, images, startDate, startTime, name, isFav, memberJoined, category, activity, couponCode
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        datumDescription = try values.decodeIfPresent(String.self, forKey: .datumDescription) ?? DocumentDefaultValues.Empty.string
        categoryName = try values.decodeIfPresent(String.self, forKey: .categoryName) ?? DocumentDefaultValues.Empty.string
        facebookURL = try values.decodeIfPresent(String.self, forKey: .facebookURL) ?? DocumentDefaultValues.Empty.string
        rating = try values.decodeIfPresent(Double.self, forKey: .rating) ?? DocumentDefaultValues.Empty.double
        instagramURL = try values.decodeIfPresent(String.self, forKey: .instagramURL) ?? DocumentDefaultValues.Empty.string
        userRef = try values.decodeIfPresent(String.self, forKey: .userRef) ?? DocumentDefaultValues.Empty.string
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        let eventType = try values.decodeIfPresent(Int.self, forKey: .type) ?? DocumentDefaultValues.Empty.int
        type = EVENT_TYPE(rawValue: eventType) ?? EVENT_TYPE.weekly
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate) ?? DocumentDefaultValues.Empty.string
        contactDetails = try values.decodeIfPresent(ContactDetails.self, forKey: .contactDetails) ?? ContactDetails()
        location = try values.decodeIfPresent(Location.self, forKey: .location) ?? Location()
        endTime = try values.decodeIfPresent(String.self, forKey: .endTime) ?? DocumentDefaultValues.Empty.string
        activityName = try values.decodeIfPresent(String.self, forKey: .activityName) ?? DocumentDefaultValues.Empty.string
        seats = try values.decodeIfPresent(Int.self, forKey: .seats) ?? DocumentDefaultValues.Empty.int
        memberJoined = try values.decodeIfPresent(Int.self, forKey: .memberJoined) ?? DocumentDefaultValues.Empty.int
        images = try values.decodeIfPresent([String].self, forKey: .images) ?? []
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate) ?? DocumentDefaultValues.Empty.string
        startTime = try values.decodeIfPresent(String.self, forKey: .startTime) ?? DocumentDefaultValues.Empty.string
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        isFav = try values.decodeIfPresent(Bool.self, forKey: .isFav) ?? DocumentDefaultValues.Empty.bool
        coupons = try values.decodeIfPresent(Bool.self, forKey: .coupons) ?? DocumentDefaultValues.Empty.bool
        reviews = try values.decodeIfPresent(Bool.self, forKey: .reviews) ?? DocumentDefaultValues.Empty.bool
        `repeat` = try values.decodeIfPresent(Bool.self, forKey: .repeat) ?? DocumentDefaultValues.Empty.bool
        websiteURL = try values.decodeIfPresent(String.self, forKey: .websiteURL) ?? DocumentDefaultValues.Empty.string
        activity = try values.decodeIfPresent(String.self, forKey: .activity) ?? DocumentDefaultValues.Empty.string
        category = try values.decodeIfPresent(String.self, forKey: .category) ?? DocumentDefaultValues.Empty.string
        couponCode = try values.decodeIfPresent(String.self, forKey: .couponCode) ?? DocumentDefaultValues.Empty.string
        couponDescription = try values.decodeIfPresent(String.self, forKey: .couponDescription) ?? DocumentDefaultValues.Empty.string
    }
    
    internal init() {
        self.datumDescription = DocumentDefaultValues.Empty.string
        self.categoryName = DocumentDefaultValues.Empty.string
        self.facebookURL = DocumentDefaultValues.Empty.string
        self.rating = DocumentDefaultValues.Empty.double
        self.instagramURL = DocumentDefaultValues.Empty.string
        self.userRef = DocumentDefaultValues.Empty.string
        self.id = DocumentDefaultValues.Empty.string
        self.type = .weekly
        self.endDate = DocumentDefaultValues.Empty.string
        self.contactDetails = ContactDetails()
        self.location = Location()
        self.endTime = DocumentDefaultValues.Empty.string
        self.activityName = DocumentDefaultValues.Empty.string
        self.seats = DocumentDefaultValues.Empty.int
        self.memberJoined = DocumentDefaultValues.Empty.int
        self.images = []
        self.startDate = DocumentDefaultValues.Empty.string
        self.startTime = DocumentDefaultValues.Empty.string
        self.name = DocumentDefaultValues.Empty.string
        self.isFav = DocumentDefaultValues.Empty.bool
        self.coupons = DocumentDefaultValues.Empty.bool
        self.reviews = DocumentDefaultValues.Empty.bool
        self.repeat = DocumentDefaultValues.Empty.bool
        self.websiteURL = DocumentDefaultValues.Empty.string
        self.activity = DocumentDefaultValues.Empty.string
        self.category = DocumentDefaultValues.Empty.string
        self.couponCode = DocumentDefaultValues.Empty.string
        self.couponDescription = DocumentDefaultValues.Empty.string
    }
}

// MARK: - ContactDetails
struct ContactDetails: Codable {
    let email, phonecode, name, phoneNumber: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try values.decodeIfPresent(String.self, forKey: .email) ?? DocumentDefaultValues.Empty.string
        phonecode = try values.decodeIfPresent(String.self, forKey: .phonecode) ?? DocumentDefaultValues.Empty.string
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        phoneNumber = try values.decodeIfPresent(String.self, forKey: .phoneNumber) ?? DocumentDefaultValues.Empty.string
    }
    
    internal init() {
        self.email = DocumentDefaultValues.Empty.string
        self.phonecode = DocumentDefaultValues.Empty.string
        self.name = DocumentDefaultValues.Empty.string
        self.phoneNumber = DocumentDefaultValues.Empty.string
    }
}

// MARK: - Location
//struct Location: Codable {
//    let type: String
//    let coordinates: [Double]
//    let address: String
//}
