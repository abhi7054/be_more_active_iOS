//
//  UserDetailResponse.swift
//  BMA
//
//  Created by MACBOOK on 26/07/21.
//

import Foundation

// MARK: - AddDiscountResponse
struct UserDetailResponse: Codable {
    let code: Int
    let message: String
    let data: User
    let timestamp, format: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent(User.self, forKey: .data) ?? User()
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}
