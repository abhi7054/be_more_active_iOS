//
//  AddRatingResponse.swift
//  BMA
//
//  Created by MACBOOK on 15/07/21.
//

import Foundation

// MARK: - Welcome
struct AddRatingResponse: Codable {
    let code: Int
    let message: String
    let data: List
    let timestamp, format: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent(List.self, forKey: .data) ?? List()
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - DataClass
//struct DataClass: Codable {
//    let review, id: String
//    let deleted: Bool
//    let rating: Int
//    let eventRef: String
//    let v: Int
//    let updatedOn, createdOn, userRef: String
//
//    enum CodingKeys: String, CodingKey {
//        case review
//        case id = "_id"
//        case deleted, rating, eventRef
//        case v = "__v"
//        case updatedOn, createdOn, userRef
//    }
//}
