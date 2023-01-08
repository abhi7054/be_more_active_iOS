//
//  DiscountListResponse.swift
//  BMA
//
//  Created by iMac on 12/07/21.
//

import Foundation


// MARK: - DiscountListResponse
struct DiscountListResponse: Codable {
    let code: Int
    let message: String
    let data: [AddDiscountModel]
    let timestamp, format: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent([AddDiscountModel].self, forKey: .data) ?? []
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}
