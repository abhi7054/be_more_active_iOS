//
//  CategoryListResponse.swift
//  BMA
//
//  Created by iMac on 07/07/21.
//

import Foundation

// MARK: - CategoryListResponse
struct CategoryListResponse: Codable {
    let hasMore: Bool
    let format: String
    let data: [CategoryListModel]
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
        data = try values.decodeIfPresent([CategoryListModel].self, forKey: .data) ?? []
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - CategoryListModel
struct CategoryListModel: Codable {
    let deleted: Bool
    let createdOn, id, name, updatedOn: String
    
    enum CodingKeys: String, CodingKey {
        case deleted, createdOn
        case id = "_id"
        case name, updatedOn
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        deleted = try values.decodeIfPresent(Bool.self, forKey: .deleted) ?? DocumentDefaultValues.Empty.bool
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn) ?? DocumentDefaultValues.Empty.string
    }
    
}
