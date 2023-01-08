//
//  CouponListViewModel.swift
//  BMA
//
//  Created by MACBOOK on 03/08/21.
//

import Foundation

protocol CouponListDelegate {
    var success: Box<Bool> { get set }
    var hasMore: Box<Bool> { get set }
    var list: Box<[CouponList]> { get set }
    func fetchCouponListing(request: MorePageRequest)
}

struct CouponListViewModel: CouponListDelegate {
    var list: Box<[CouponList]> = Box([CouponList]())
    var success: Box<Bool> = Box(Bool())
    var hasMore: Box<Bool> = Box(Bool())
    
    func fetchCouponListing(request: MorePageRequest) {
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.EVENT.couponList, Loader: true, isMultipart: false) { (response) in
            if response != nil{                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(CouponListResponse.self, from: response!) // decode the response into model
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
