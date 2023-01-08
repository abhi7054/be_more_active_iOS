//
//  CouponListResponse.swift
//  BMA
//
//  Created by MACBOOK on 03/08/21.
//

import Foundation

// MARK: - CouponListResponse
struct CouponListResponse: Codable {
    let code: Int
    let message: String
    let data: [CouponList]
    let timestamp, format: String
    let total, page, limit, size: Int
    let hasMore: Bool
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent([CouponList].self, forKey: .data) ?? []
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        total = try values.decodeIfPresent(Int.self, forKey: .total) ?? DocumentDefaultValues.Empty.int
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? DocumentDefaultValues.Empty.int
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? DocumentDefaultValues.Empty.int
        size = try values.decodeIfPresent(Int.self, forKey: .size) ?? DocumentDefaultValues.Empty.int
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? DocumentDefaultValues.Empty.bool
    }
}

// MARK: - CouponList
struct CouponList: Codable {
    let id, couponCode, couponDescription: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case couponCode, couponDescription
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        couponCode = try values.decodeIfPresent(String.self, forKey: .couponCode) ?? DocumentDefaultValues.Empty.string
        couponDescription = try values.decodeIfPresent(String.self, forKey: .couponDescription) ?? DocumentDefaultValues.Empty.string
    }
}
