//
//  EventListResponse.swift
//  BMA
//
//  Created by MACBOOK on 08/07/21.
//

import Foundation

// MARK: - EventListResponse
struct EventListResponse: Codable {
    let hasMore: Bool
    let format: String
    let data: [EventList]
    let code: Int
    let message: String
    let limit, size, page: Int
    let timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? DocumentDefaultValues.Empty.bool
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent([EventList].self, forKey: .data) ?? []
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? DocumentDefaultValues.Empty.int
        size = try values.decodeIfPresent(Int.self, forKey: .size) ?? DocumentDefaultValues.Empty.int
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? DocumentDefaultValues.Empty.int
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - EventList
struct EventList: Codable {
    let id: String
    let images: [String]?
    let location: Location
    let startDate, endDate: String
    let distance: Double
    let type: EVENT_TYPE
    let name: String
    var isSelected: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case images, location, startDate, endDate, distance, type, name, isSelected
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        images = try values.decodeIfPresent([String].self, forKey: .images) ?? []
        location = try values.decodeIfPresent(Location.self, forKey: .location) ?? Location()
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate) ?? DocumentDefaultValues.Empty.string
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate) ?? DocumentDefaultValues.Empty.string
        distance = try values.decodeIfPresent(Double.self, forKey: .distance) ?? DocumentDefaultValues.Empty.double
        let eventType = try values.decodeIfPresent(Int.self, forKey: .type) ?? DocumentDefaultValues.Empty.int
        type = EVENT_TYPE(rawValue: eventType) ?? EVENT_TYPE.weekly
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        isSelected = try values.decodeIfPresent(Bool.self, forKey: .isSelected) ?? DocumentDefaultValues.Empty.bool
    }
}

// MARK: - Location
//struct Location: Codable {
//    let type: String
//    let coordinates: [Double]
//    let address: String
//}
