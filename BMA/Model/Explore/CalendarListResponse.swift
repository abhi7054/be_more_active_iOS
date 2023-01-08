//
//  CalendarListResponse.swift
//  BMA
//
//  Created by MACBOOK on 21/07/21.
//

import Foundation

// MARK: - CalendarListResponse
struct CalendarListResponse: Codable {
    let code: Int
    let message: String
    let data: CalendarList
    let timestamp, format: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent(CalendarList.self, forKey: .data) ?? CalendarList()
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - CalendarList
struct CalendarList: Codable {
    let myBookings: [MyEvent]
    let myEvents: [MyEvent]
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        myEvents = try values.decodeIfPresent([MyEvent].self, forKey: .myEvents) ?? []
        myBookings = try values.decodeIfPresent([MyEvent].self, forKey: .myBookings) ?? []
    }
    
    init() {
        self.myBookings = []
        self.myEvents = []
    }
}

// MARK: - MyEvent
struct MyEvent: Codable {
    let id, name: String
    let location: Location
    let startTime, endTime: String
    let startDate, endDate: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, location, endTime, startTime, endDate, startDate
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        startTime = try values.decodeIfPresent(String.self, forKey: .startTime) ?? DocumentDefaultValues.Empty.string
        endTime = try values.decodeIfPresent(String.self, forKey: .endTime) ?? DocumentDefaultValues.Empty.string
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate) ?? DocumentDefaultValues.Empty.string
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate) ?? DocumentDefaultValues.Empty.string
        location = try values.decodeIfPresent(Location.self, forKey: .location) ?? Location()
    }
}
