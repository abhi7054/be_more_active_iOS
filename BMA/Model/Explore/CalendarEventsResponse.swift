//
//  CalendarEventsResponse.swift
//  BMA
//
//  Created by MACBOOK on 20/07/21.
//

import Foundation

// MARK: - CalendarEventsResponse
struct CalendarEventsResponse: Codable {
    let code: Int
    let message: String
    let data: [CalendarEvents]
    let timestamp, format: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent([CalendarEvents].self, forKey: .data) ?? []
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - CalendarEvents
struct CalendarEvents: Codable {
    let dates: [Int]
    let id, startDate, endDate: String
    let datumRepeat: Bool

    enum CodingKeys: String, CodingKey {
        case dates
        case id = "_id"
        case startDate, endDate
        case datumRepeat = "repeat"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate) ?? DocumentDefaultValues.Empty.string
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate) ?? DocumentDefaultValues.Empty.string
        dates = try values.decodeIfPresent([Int].self, forKey: .dates) ?? []
        datumRepeat = try values.decodeIfPresent(Bool.self, forKey: .datumRepeat) ?? DocumentDefaultValues.Empty.bool
    }
}
