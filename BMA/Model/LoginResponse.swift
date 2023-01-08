//
//  LoginResponse.swift
//  InstantFest
//
//  Created by iMac on 7/07/21.
//

import Foundation


// MARK: - LoginResponse
struct LoginResponse: Codable {
    let code: Int
    let message: String
    let data: UserDataModel?
    let format, timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent(UserDataModel.self, forKey: .data) ?? nil
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - UserDataModel
struct UserDataModel: Codable {
    var accessToken: String
    var user: User?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken) ?? DocumentDefaultValues.Empty.string
        user = try values.decodeIfPresent(User.self, forKey: .user) ?? nil
    }
    
    init() {
        accessToken = DocumentDefaultValues.Empty.string
        user = User.init()
    }
}

// MARK: - User
struct User: Codable {
    let id: String
    let location: Location?
    let category, picture, createdOn, updatedOn: String
    let email: String
    let activities: [String]
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case location, category, picture, createdOn, updatedOn, email, activities, name
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        category = try values.decodeIfPresent(String.self, forKey: .category) ?? DocumentDefaultValues.Empty.string
        picture = try values.decodeIfPresent(String.self, forKey: .picture) ?? DocumentDefaultValues.Empty.string
        updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn) ?? DocumentDefaultValues.Empty.string
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        email = try values.decodeIfPresent(String.self, forKey: .email) ?? DocumentDefaultValues.Empty.string
        activities = try values.decodeIfPresent([String].self, forKey: .activities) ?? []
        location = try values.decodeIfPresent(Location.self, forKey: .location) ?? nil
    }
    
    init() {
        id = DocumentDefaultValues.Empty.string
        createdOn = DocumentDefaultValues.Empty.string
        category = DocumentDefaultValues.Empty.string
        picture = DocumentDefaultValues.Empty.string
        updatedOn = DocumentDefaultValues.Empty.string
        name = DocumentDefaultValues.Empty.string
        email = DocumentDefaultValues.Empty.string
        activities = [String]()
        location = nil
    }
}


// MARK: - Location
struct Location: Codable {
    let coordinates: [Double]
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinates = try values.decodeIfPresent([Double].self, forKey: .coordinates) ?? []
    }
}

