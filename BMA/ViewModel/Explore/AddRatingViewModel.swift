//
//  AddRatingViewModel.swift
//  BMA
//
//  Created by MACBOOK on 15/07/21.
//

import Foundation
import SainiUtils

protocol AddRatingDelegate {
    var success: Box<Bool> { get set }
    var list: Box<List> { get set }
    func addRating(request: AddRatingRequest)
}

struct AddRatingViewModel: AddRatingDelegate {
    var list: Box<List> = Box(List())
    var success: Box<Bool> = Box(Bool())
    
    func addRating(request: AddRatingRequest) {
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.RATING.add, Loader: true, isMultipart: false) { (response) in
            if response != nil{                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(AddRatingResponse.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
                        self.list.value = success.data
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
