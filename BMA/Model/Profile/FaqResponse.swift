//
//  FaqResponse.swift
//  GolfApp
//
//  Created by MACBOOK on 03/01/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import Foundation

// MARK: - FaqResponse
struct FaqResponse: Codable {
    let code: Int
    let message: String
    let data: [FaqList]
    let format, timestamp: String
    let total, page, limit, size: Int
    let hasMore: Bool
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent([FaqList].self, forKey: .data) ?? []
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        total = try values.decodeIfPresent(Int.self, forKey: .total) ?? DocumentDefaultValues.Empty.int
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? DocumentDefaultValues.Empty.int
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? DocumentDefaultValues.Empty.int
        size = try values.decodeIfPresent(Int.self, forKey: .size) ?? DocumentDefaultValues.Empty.int
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? DocumentDefaultValues.Empty.bool
    }
}

// MARK: - FaqList
struct FaqList: Codable {
    let deleted: Bool
    let id, question, answer, createdOn: String
    let updatedOn: String
    var isOpened: Bool

    enum CodingKeys: String, CodingKey {
        case deleted
        case id = "_id"
        case question, answer, createdOn, updatedOn, isOpened
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        deleted = try values.decodeIfPresent(Bool.self, forKey: .deleted) ?? DocumentDefaultValues.Empty.bool
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        question = try values.decodeIfPresent(String.self, forKey: .question) ?? DocumentDefaultValues.Empty.string
        answer = try values.decodeIfPresent(String.self, forKey: .answer) ?? DocumentDefaultValues.Empty.string
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn) ?? DocumentDefaultValues.Empty.string
        isOpened = try values.decodeIfPresent(Bool.self, forKey: .isOpened) ?? DocumentDefaultValues.Empty.bool
    }
}
