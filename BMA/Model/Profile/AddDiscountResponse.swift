//
//  AddDiscountResponse.swift
//  BMA
//
//  Created by iMac on 12/07/21.
//

import Foundation

// MARK: - AddDiscountResponse
struct AddDiscountResponse: Codable {
    let code: Int
    let message: String
    let data: AddDiscountModel?
    let timestamp, format: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent(AddDiscountModel.self, forKey: .data) ?? nil
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - AddDiscountModel
struct AddDiscountModel: Codable {
    let id: String
    let deleted: Bool
    let v: Int
    let discountCode, createdOn, userRef, dataDescription: String
    let updatedOn: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case deleted
        case v = "__v"
        case discountCode, createdOn, userRef
        case dataDescription = "description"
        case updatedOn = "UpdatedOn"
    }
    
    init(from decoder: Decoder) throws {
         let values = try decoder.container(keyedBy: CodingKeys.self)
        
         id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
         createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
         discountCode = try values.decodeIfPresent(String.self, forKey: .discountCode) ?? DocumentDefaultValues.Empty.string
         userRef = try values.decodeIfPresent(String.self, forKey: .userRef) ?? DocumentDefaultValues.Empty.string
         updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn) ?? DocumentDefaultValues.Empty.string
         dataDescription = try values.decodeIfPresent(String.self, forKey: .dataDescription) ?? DocumentDefaultValues.Empty.string
         v = try values.decodeIfPresent(Int.self, forKey: .v) ?? DocumentDefaultValues.Empty.int
         deleted = try values.decodeIfPresent(Bool.self, forKey: .deleted) ?? DocumentDefaultValues.Empty.bool
     }
}
