//
//  DiscountListViewModel.swift
//  BMA
//
//  Created by iMac on 12/07/21.
//

import Foundation
import SainiUtils

protocol DiscountListDelegate {
     var hasMore: Box<Bool> { get set }
     var discountList: Box<[AddDiscountModel]> { get set }
     func DiscountList(request: MorePageRequest)
}

struct DiscountListViewModel : DiscountListDelegate {
    
    var hasMore: Box<Bool> = Box(Bool())
    var discountList: Box<[AddDiscountModel]> = Box([])

    func DiscountList(request: MorePageRequest) {
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.DISCOUNT.discountList, Loader: true, isMultipart: false) { (response) in
            if response != nil {                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(DiscountListResponse.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
                        self.discountList.value += success.data
                        break
                    default:
                        displayToast(success.message)
                        log.error("\(Log.stats()) \(success.message)")/
                    }
                }
                catch let err {
                    log.error("ERROR OCCURED WHILE DEC4ODING: \(Log.stats()) \(err)")/
                }
            }
        }
    }
}

