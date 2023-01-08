//
//  NotificationListResponse.swift
//  InstantFest
//
//  Created by iMac on 18/06/21.
//

import Foundation


// MARK: - NotificationListResponse
struct NotificationListResponse: Codable {
    let code: Int
    let message: String
    let data: [NotificationListModel]
    let page, limit, size: Int
    let hasMore: Bool
    let format, timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        size = try values.decodeIfPresent(Int.self, forKey: .size) ?? DocumentDefaultValues.Empty.int
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? DocumentDefaultValues.Empty.int
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? DocumentDefaultValues.Empty.int
        data = try values.decodeIfPresent([NotificationListModel].self, forKey: .data) ?? []
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? DocumentDefaultValues.Empty.bool
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
        
    }
}

// MARK: - NotificationUserList
struct NotificationListModel: Codable {
    let id, additionalRef: String
    var seen: Bool
    let userRef, sourceRef, text: String
    let type: NOTIFICATION_TYPE
    let createdOn, updatedOn, image: String
    let user : User?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case seen, userRef, sourceRef, type, createdOn, updatedOn, image, text, user, additionalRef
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        userRef = try values.decodeIfPresent(String.self, forKey: .userRef) ?? DocumentDefaultValues.Empty.string
        let eventType = try values.decodeIfPresent(Int.self, forKey: .type) ?? DocumentDefaultValues.Empty.int
        type = NOTIFICATION_TYPE(rawValue: eventType) ?? NOTIFICATION_TYPE.ADMIN
        sourceRef = try values.decodeIfPresent(String.self, forKey: .sourceRef) ?? DocumentDefaultValues.Empty.string
        updatedOn = try values.decodeIfPresent(String.self, forKey: .updatedOn) ?? DocumentDefaultValues.Empty.string
        seen = try values.decodeIfPresent(Bool.self, forKey: .seen) ?? DocumentDefaultValues.Empty.bool
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? DocumentDefaultValues.Empty.string
        text = try values.decodeIfPresent(String.self, forKey: .text) ?? DocumentDefaultValues.Empty.string
        user = try values.decodeIfPresent(User.self, forKey: .user) ?? nil
        additionalRef = try values.decodeIfPresent(String.self, forKey: .additionalRef) ?? DocumentDefaultValues.Empty.string
    }

    init() {
        id = DocumentDefaultValues.Empty.string
        createdOn = DocumentDefaultValues.Empty.string
        userRef = DocumentDefaultValues.Empty.string
        type = NOTIFICATION_TYPE.ADMIN
        sourceRef = DocumentDefaultValues.Empty.string
        updatedOn = DocumentDefaultValues.Empty.string
        seen = DocumentDefaultValues.Empty.bool
        image = DocumentDefaultValues.Empty.string
        text = DocumentDefaultValues.Empty.string
        user = nil
        additionalRef = DocumentDefaultValues.Empty.string
    }
}
