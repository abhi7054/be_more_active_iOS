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
    var isSelect: Bool
    
    enum CodingKeys: String, CodingKey {
        case deleted, createdOn
        case id = "_id"
        case name, updatedOn, isSelect
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        deleted = try values.decodeIfPresent(Bool.self, forKey: .deleted) ?? DocumentDefaultValues.Empty.bool
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn) ?? DocumentDefaultValues.Empty.string
        isSelect = try values.decodeIfPresent(Bool.self, forKey: .isSelect) ?? DocumentDefaultValues.Empty.bool
    }
    
}


struct MyActivityResponse: Codable {
    let hasMore: Bool
    let format: String
    let data: [CategoryModel]
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
        data = try values.decodeIfPresent([CategoryModel].self, forKey: .data) ?? [CategoryModel]()
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - Datum
struct CategoryModel: Codable {
    var isSelected: Bool
    let id: String
    var activities: [ActivityModel]
    let name: String
    var selectedActivity : Int
    
    enum CodingKeys: String, CodingKey {
        case isSelected
        case id = "_id"
        case activities, name, selectedActivity
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        activities = try values.decodeIfPresent([ActivityModel].self, forKey: .activities) ?? [ActivityModel]()
        isSelected = try values.decodeIfPresent(Bool.self, forKey: .isSelected) ?? DocumentDefaultValues.Empty.bool
        selectedActivity = try values.decodeIfPresent(Int.self, forKey: .selectedActivity) ?? DocumentDefaultValues.Empty.int
    }
    
    init() {
        name = DocumentDefaultValues.Empty.string
        id = DocumentDefaultValues.Empty.string
        activities = [ActivityModel]()
        isSelected = DocumentDefaultValues.Empty.bool
        selectedActivity = DocumentDefaultValues.Empty.int
    }
    
}

// MARK: - Activity
struct ActivityModel: Codable {
    let id, name: String
    var isSelected: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, isSelected
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        isSelected = try values.decodeIfPresent(Bool.self, forKey: .isSelected) ?? DocumentDefaultValues.Empty.bool
    }
    
    init() {
        name = DocumentDefaultValues.Empty.string
        id = DocumentDefaultValues.Empty.string
        isSelected = DocumentDefaultValues.Empty.bool
    }
}
