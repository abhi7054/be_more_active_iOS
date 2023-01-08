//
//  EventsLeaguesResponse.swift
//  BMA
//
//  Created by iMac on 16/07/21.
//

import Foundation

// MARK: - EventsLeaguesResponse
struct EventsLeaguesResponse: Codable {
    let hasMore: Bool
    let format: String
    let data: [EventsLeaguesModel]
    let code: Int
    let message: String
    let limit, size, page: Int
    let timestamp: String
    
    init(from decoder: Decoder) throws {
           let values = try decoder.container(keyedBy: CodingKeys.self)
           hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? DocumentDefaultValues.Empty.bool
           code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
           limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? DocumentDefaultValues.Empty.int
           page = try values.decodeIfPresent(Int.self, forKey: .page) ?? DocumentDefaultValues.Empty.int
           size = try values.decodeIfPresent(Int.self, forKey: .size) ?? DocumentDefaultValues.Empty.int
           message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
           data = try values.decodeIfPresent([EventsLeaguesModel].self, forKey: .data) ?? []
           format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
           timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
       }
    
}

// MARK: - EventsLeaguesModel
struct EventsLeaguesModel: Codable {
    let endDate, id, startDate, name: String
    let images: [String]
    let location: Location?

    enum CodingKeys: String, CodingKey {
        case endDate
        case id = "_id"
        case startDate, name, images, location
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        location = try values.decodeIfPresent(Location.self, forKey: .location) ?? nil
        images = try values.decodeIfPresent([String].self, forKey: .images) ?? []
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate) ?? DocumentDefaultValues.Empty.string
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate) ?? DocumentDefaultValues.Empty.string
    }
    
}

//// MARK: - Location
//struct Location: Codable {
//    let type: String
//    let coordinates: [Double]
//    let address: String
//}
