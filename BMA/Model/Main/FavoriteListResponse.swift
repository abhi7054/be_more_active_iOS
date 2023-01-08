//
//  FavoriteListResponse.swift
//  BMA
//
//  Created by iMac on 09/07/21.
//

import Foundation

// MARK: - Welcome
struct FavoriteListResponse: Codable {
    let hasMore: Bool
    let format: String
    let data: [FavoriteListModel]
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
        data = try values.decodeIfPresent([FavoriteListModel].self, forKey: .data) ?? []
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
    
}

// MARK: - Datum
struct FavoriteListModel: Codable {
    let id: String
    let location: Location?
    let images: [String]
    let createdOn: String
    let type: Int
    let name, startDateText, endDateText: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case location, images, createdOn, type, name, startDateText, endDateText
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(Int.self, forKey: .type) ?? DocumentDefaultValues.Empty.int
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        location = try values.decodeIfPresent(Location.self, forKey: .location) ?? nil
        images = try values.decodeIfPresent([String].self, forKey: .images) ?? []
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        startDateText = try values.decodeIfPresent(String.self, forKey: .startDateText) ?? DocumentDefaultValues.Empty.string
        endDateText = try values.decodeIfPresent(String.self, forKey: .endDateText) ?? DocumentDefaultValues.Empty.string
    }
}
