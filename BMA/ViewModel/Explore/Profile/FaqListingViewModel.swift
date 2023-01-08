//
//  FaqListingViewModel.swift
//  BMA
//
//  Created by MACBOOK on 02/08/21.
//

import Foundation

protocol FaqListDelegate {
    var success: Box<Bool> { get set }
    var hasMore: Box<Bool> { get set }
    var list: Box<[FaqList]> { get set }
    func fetchFaqListing(request: MorePageRequest)
}

struct FaqListingViewModel: FaqListDelegate {
    var list: Box<[FaqList]> = Box([FaqList]())
    var success: Box<Bool> = Box(Bool())
    var hasMore: Box<Bool> = Box(Bool())
    
    func fetchFaqListing(request: MorePageRequest) {
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.FAQS.list, Loader: true, isMultipart: false) { (response) in
            if response != nil{                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(FaqResponse.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
                        self.list.value += success.data
                        self.hasMore.value = success.hasMore
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
