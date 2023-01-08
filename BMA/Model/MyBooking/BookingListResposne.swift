//
//  BookingListResposne.swift
//  BMA
//
//  Created by iMac on 13/07/21.
//

import Foundation

// MARK: - BookingListResposne
struct BookingListResposne: Codable {
    let hasMore: Bool
    let format: String
    let data: [BookingListModel]
    let code: Int
    let message: String
    let limit, size, page: Int
    let timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? DocumentDefaultValues.Empty.bool
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent([BookingListModel].self, forKey: .data) ?? []
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? DocumentDefaultValues.Empty.int
        size = try values.decodeIfPresent(Int.self, forKey: .size) ?? DocumentDefaultValues.Empty.int
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? DocumentDefaultValues.Empty.int
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - BookingListModel
struct BookingListModel: Codable {
    let startTime, id, startDate, name: String
    let endDate, endTime, eventRef: String
    let images: [String]
    let status: Int

    enum CodingKeys: String, CodingKey {
        case startTime
        case id = "_id"
        case startDate, name, endDate, endTime, images, status, eventRef
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        startTime = try values.decodeIfPresent(String.self, forKey: .startTime) ?? DocumentDefaultValues.Empty.string
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate) ?? DocumentDefaultValues.Empty.string
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate) ?? DocumentDefaultValues.Empty.string
        endTime = try values.decodeIfPresent(String.self, forKey: .endTime) ?? DocumentDefaultValues.Empty.string
        images = try values.decodeIfPresent([String].self, forKey: .images) ?? []
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        eventRef = try values.decodeIfPresent(String.self, forKey: .eventRef) ?? DocumentDefaultValues.Empty.string
        status = try values.decodeIfPresent(Int.self, forKey: .status) ?? DocumentDefaultValues.Empty.int
    }
}
