//
//  MemberJoinedResponse.swift
//  BMA
//
//  Created by MACBOOK on 16/07/21.
//

import Foundation

// MARK: - MemberJoinedResponse
struct MemberJoinedResponse: Codable {
    let hasMore: Bool
    let format: String
    let data: [MemberJoinedList]
    let code: Int
    let message: String
    let limit, size, page: Int
    let timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? DocumentDefaultValues.Empty.bool
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent([MemberJoinedList].self, forKey: .data) ?? []
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? DocumentDefaultValues.Empty.int
        size = try values.decodeIfPresent(Int.self, forKey: .size) ?? DocumentDefaultValues.Empty.int
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? DocumentDefaultValues.Empty.int
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - Datum
struct MemberJoinedList: Codable {
    let email, id, picture, name: String
    let creator: Bool

    enum CodingKeys: String, CodingKey {
        case email
        case id = "_id"
        case picture, name, creator
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        creator = try values.decodeIfPresent(Bool.self, forKey: .creator) ?? DocumentDefaultValues.Empty.bool
        email = try values.decodeIfPresent(String.self, forKey: .email) ?? DocumentDefaultValues.Empty.string
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        picture = try values.decodeIfPresent(String.self, forKey: .picture) ?? DocumentDefaultValues.Empty.string
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
    }
}
