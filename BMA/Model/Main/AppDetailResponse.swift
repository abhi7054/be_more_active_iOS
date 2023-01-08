//
//  AppDetailResponse.swift
//  BMA
//
//  Created by MACBOOK on 17/07/21.
//

import Foundation

// MARK: - AppDetailResponse
struct AppDetailResponse: Codable {
    let code: Int
    let message: String
    let data: AppDetail
    let format, timestamp: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code) ?? DocumentDefaultValues.Empty.int
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? DocumentDefaultValues.Empty.string
        data = try values.decodeIfPresent(AppDetail.self, forKey: .data) ?? AppDetail()
        format = try values.decodeIfPresent(String.self, forKey: .format) ?? DocumentDefaultValues.Empty.string
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp) ?? DocumentDefaultValues.Empty.string
    }
}

// MARK: - AppDetail
struct AppDetail: Codable {
    let id, aboutUs, aboutUsUpdatedOn, createdOn: String
    let privacyPolicy, privacyPolicyUpdatedOn, termsAndConditions, termsAndConditionsUpdatedOn: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case aboutUs, aboutUsUpdatedOn, createdOn, privacyPolicy, privacyPolicyUpdatedOn, termsAndConditions, termsAndConditionsUpdatedOn
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? DocumentDefaultValues.Empty.string
        aboutUs = try values.decodeIfPresent(String.self, forKey: .aboutUs) ?? DocumentDefaultValues.Empty.string
        aboutUsUpdatedOn = try values.decodeIfPresent(String.self, forKey: .aboutUsUpdatedOn) ?? DocumentDefaultValues.Empty.string
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn) ?? DocumentDefaultValues.Empty.string
        privacyPolicy = try values.decodeIfPresent(String.self, forKey: .privacyPolicy) ?? DocumentDefaultValues.Empty.string
        privacyPolicyUpdatedOn = try values.decodeIfPresent(String.self, forKey: .privacyPolicyUpdatedOn) ?? DocumentDefaultValues.Empty.string
        termsAndConditions = try values.decodeIfPresent(String.self, forKey: .termsAndConditions) ?? DocumentDefaultValues.Empty.string
        termsAndConditionsUpdatedOn = try values.decodeIfPresent(String.self, forKey: .termsAndConditionsUpdatedOn) ?? DocumentDefaultValues.Empty.string
    }
    
    init() {
        self.id = DocumentDefaultValues.Empty.string
        self.aboutUs = DocumentDefaultValues.Empty.string
        self.aboutUsUpdatedOn = DocumentDefaultValues.Empty.string
        self.createdOn = DocumentDefaultValues.Empty.string
        self.privacyPolicy = DocumentDefaultValues.Empty.string
        self.privacyPolicyUpdatedOn = DocumentDefaultValues.Empty.string
        self.termsAndConditions = DocumentDefaultValues.Empty.string
        self.termsAndConditionsUpdatedOn = DocumentDefaultValues.Empty.string
    }
}
