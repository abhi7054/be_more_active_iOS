//
//  BookingDetailsResponse.swift
//  BMA
//
//  Created by iMac on 15/07/21.
//

import Foundation

// MARK: - Welcome
struct BookingDetailsResponse: Codable {
    let code: Int
    let message: String
    let data: BookingDetailsModel?
    let timestamp, format: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent(BookingDetailsModel.self, forKey: .data) ?? nil
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - DataClass
struct BookingDetailsModel: Codable {
    let location: Location
    let instagramURL: String
    let status: Int
    let categoryName, id: String
    let images: [String]
    let memberJoined: Int
    let endTime, category, activity, name: String
    let seats: Int
    let endDate, couponDescription, facebookURL, couponCode: String
    let contactDetails: ContactDetails
    let activityName, startDate, userRef, startTime: String
    let rating: Int
    let dataDescription: String
    let reviews, coupons: Bool
    
    enum CodingKeys: String, CodingKey {
        case location, reviews, coupons
        case instagramURL = "instagramUrl"
        case status, categoryName
        case id = "_id"
        case images, memberJoined, endTime, category, activity, name, seats, endDate, couponDescription
        case facebookURL = "facebookUrl"
        case couponCode, contactDetails, activityName, startDate, userRef, startTime, rating
        case dataDescription = "description"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        images = try values.decodeIfPresent([String].self, forKey: .images) ?? []
        location = try values.decodeIfPresent(Location.self, forKey: .location) ?? Location()
        contactDetails = try values.decodeIfPresent(ContactDetails.self, forKey: .contactDetails) ?? ContactDetails()
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate) ?? DocumentDefaultValues.Empty.string
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate) ?? DocumentDefaultValues.Empty.string
        instagramURL = try values.decodeIfPresent(String.self, forKey: .instagramURL) ?? DocumentDefaultValues.Empty.string
        status = try values.decodeIfPresent(Int.self, forKey: .status) ?? DocumentDefaultValues.Empty.int
        memberJoined = try values.decodeIfPresent(Int.self, forKey: .memberJoined) ?? DocumentDefaultValues.Empty.int
        endTime = try values.decodeIfPresent(String.self, forKey: .endTime) ?? DocumentDefaultValues.Empty.string
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        category = try values.decodeIfPresent(String.self, forKey: .category) ?? DocumentDefaultValues.Empty.string
        activity = try values.decodeIfPresent(String.self, forKey: .activity) ?? DocumentDefaultValues.Empty.string
        seats = try values.decodeIfPresent(Int.self, forKey: .seats) ?? DocumentDefaultValues.Empty.int
        facebookURL = try values.decodeIfPresent(String.self, forKey: .facebookURL) ?? DocumentDefaultValues.Empty.string
        userRef = try values.decodeIfPresent(String.self, forKey: .userRef) ?? DocumentDefaultValues.Empty.string
        startTime = try values.decodeIfPresent(String.self, forKey: .startTime) ?? DocumentDefaultValues.Empty.string
        rating = try values.decodeIfPresent(Int.self, forKey: .rating) ?? DocumentDefaultValues.Empty.int
        dataDescription = try values.decodeIfPresent(String.self, forKey: .dataDescription) ?? DocumentDefaultValues.Empty.string
        couponCode = try values.decodeIfPresent(String.self, forKey: .couponCode) ?? DocumentDefaultValues.Empty.string
        couponDescription = try values.decodeIfPresent(String.self, forKey: .couponDescription) ?? DocumentDefaultValues.Empty.string
        categoryName = try values.decodeIfPresent(String.self, forKey: .categoryName) ?? DocumentDefaultValues.Empty.string
        activityName = try values.decodeIfPresent(String.self, forKey: .activityName) ?? DocumentDefaultValues.Empty.string
        reviews = try values.decodeIfPresent(Bool.self, forKey: .reviews) ?? DocumentDefaultValues.Empty.bool
        coupons = try values.decodeIfPresent(Bool.self, forKey: .coupons) ?? DocumentDefaultValues.Empty.bool
    }
    
    init() {
        id = DocumentDefaultValues.Empty.string
        images = []
        location = Location()
        startDate = DocumentDefaultValues.Empty.string
        endDate = DocumentDefaultValues.Empty.string
        instagramURL = DocumentDefaultValues.Empty.string
        status = DocumentDefaultValues.Empty.int
        memberJoined = DocumentDefaultValues.Empty.int
        endTime = DocumentDefaultValues.Empty.string
        name = DocumentDefaultValues.Empty.string
        category = DocumentDefaultValues.Empty.string
        activity = DocumentDefaultValues.Empty.string
        seats = DocumentDefaultValues.Empty.int
        facebookURL = DocumentDefaultValues.Empty.string
        userRef = DocumentDefaultValues.Empty.string
        startTime = DocumentDefaultValues.Empty.string
        rating = DocumentDefaultValues.Empty.int
        dataDescription = DocumentDefaultValues.Empty.string
        couponCode = DocumentDefaultValues.Empty.string
        couponDescription = DocumentDefaultValues.Empty.string
        categoryName = DocumentDefaultValues.Empty.string
        activityName = DocumentDefaultValues.Empty.string
        reviews = DocumentDefaultValues.Empty.bool
        coupons = DocumentDefaultValues.Empty.bool
        contactDetails = ContactDetails()
    }
    
}

//// MARK: - Location
//struct Location: Codable {
//    let type: String
//    let coordinates: [Double]
//    let address: String
//}
