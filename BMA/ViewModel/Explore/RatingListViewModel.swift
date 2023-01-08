//
//  RatingListViewModel.swift
//  BMA
//
//  Created by MACBOOK on 15/07/21.
//

import Foundation
import SainiUtils

protocol RatingListDelegate {
    var success: Box<Bool> { get set }
    var ratingData: Box<RatingData> { get set }
    func fetchRatingList(request: ListRequest)
}

struct RatingListViewModel: RatingListDelegate {
    var ratingData: Box<RatingData> = Box(RatingData())
    var success: Box<Bool> = Box(Bool())
    
    func fetchRatingList(request: ListRequest) {
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.RATING.list, Loader: false, isMultipart: false) { (response) in
            if response != nil{                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(RatingListResponse.self, from: response!) // decode the response into model
                    switch success.code {
                    case 100:
                        self.ratingData.value = success.data
                        self.success.value = true
                        break
                    default:
                        log.error("\(Log.stats()) \(success.message)")/
                    }
                }
                catch let err {
                    log.error("ERROR OCCURED WHILE DECODING: \(Log.stats()) \(err)")/
                }
            }
        }
    }
}
