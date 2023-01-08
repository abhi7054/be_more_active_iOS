//
//  RatingListResponse.swift
//  BMA
//
//  Created by MACBOOK on 15/07/21.
//

import Foundation

// MARK: - RatingListResponse
struct RatingListResponse: Codable {
    let code: Int
    let message: String
    let data: RatingData
    let timestamp, format: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent(RatingData.self, forKey: .data) ?? RatingData()
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - RatingData
struct RatingData: Codable {
    let page, limit: Int
    var list: [List]
    let hasMore: Bool
    let rating: Rating
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? DocumentDefaultValues.Empty.int
        limit = try values.decodeIfPresent(Int.self, forKey: .limit) ?? DocumentDefaultValues.Empty.int
        list = try values.decodeIfPresent([List].self, forKey: .list) ?? []
        hasMore = try values.decodeIfPresent(Bool.self, forKey: .hasMore) ?? DocumentDefaultValues.Empty.bool
        rating = try values.decodeIfPresent(Rating.self, forKey: .rating) ?? Rating()
    }
    
    init() {
        self.page = DocumentDefaultValues.Empty.int
        self.limit = DocumentDefaultValues.Empty.int
        self.list = []
        self.hasMore = DocumentDefaultValues.Empty.bool
        self.rating = Rating()
    }
}

// MARK: - List
struct List: Codable {
    let createdOn, id, review: String
    let addedBy: AddedBy
    let rating: Double

    enum CodingKeys: String, CodingKey {
        case createdOn
        case id = "_id"
        case review, addedBy, rating
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        review = try values.decodeIfPresent(String.self, forKey: .review) ?? DocumentDefaultValues.Empty.string
        addedBy = try values.decodeIfPresent(AddedBy.self, forKey: .addedBy) ?? AddedBy()
        rating = try values.decodeIfPresent(Double.self, forKey: .rating) ?? DocumentDefaultValues.Empty.double
    }
    
    init() {
        self.createdOn = DocumentDefaultValues.Empty.string
        self.id = DocumentDefaultValues.Empty.string
        self.review = DocumentDefaultValues.Empty.string
        self.addedBy = AddedBy()
        self.rating = DocumentDefaultValues.Empty.double
    }
}

// MARK: - AddedBy
struct AddedBy: Codable {
    let id, name, profilePicture: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, profilePicture
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? DocumentDefaultValues.Empty.string
        profilePicture = try values.decodeIfPresent(String.self, forKey: .profilePicture) ?? DocumentDefaultValues.Empty.string
    }
    
    init() {
        self.id = DocumentDefaultValues.Empty.string
        self.name = DocumentDefaultValues.Empty.string
        self.profilePicture = DocumentDefaultValues.Empty.string
    }
    
}

// MARK: - Rating
struct Rating: Codable {
    let id: String
    let poor, average, excellent, averageRating: Double
    let good, total, terrible: Double

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case poor, average, excellent, averageRating, good, total, terrible
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        poor = try values.decodeIfPresent(Double.self, forKey: .poor) ?? DocumentDefaultValues.Empty.double
        average = try values.decodeIfPresent(Double.self, forKey: .average) ?? DocumentDefaultValues.Empty.double
        excellent = try values.decodeIfPresent(Double.self, forKey: .excellent) ?? DocumentDefaultValues.Empty.double
        averageRating = try values.decodeIfPresent(Double.self, forKey: .averageRating) ?? DocumentDefaultValues.Empty.double
        good = try values.decodeIfPresent(Double.self, forKey: .good) ?? DocumentDefaultValues.Empty.double
        total = try values.decodeIfPresent(Double.self, forKey: .total) ?? DocumentDefaultValues.Empty.double
        terrible = try values.decodeIfPresent(Double.self, forKey: .terrible) ?? DocumentDefaultValues.Empty.double
    }
    
    internal init() {
        self.id = DocumentDefaultValues.Empty.string
        self.poor = DocumentDefaultValues.Empty.double
        self.average = DocumentDefaultValues.Empty.double
        self.excellent = DocumentDefaultValues.Empty.double
        self.averageRating = DocumentDefaultValues.Empty.double
        self.good = DocumentDefaultValues.Empty.double
        self.total = DocumentDefaultValues.Empty.double
        self.terrible = DocumentDefaultValues.Empty.double
    }
}
