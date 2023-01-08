//
//  DiscountViewModel.swift
//  BMA
//
//  Created by iMac on 12/07/21.
//

import Foundation
import SainiUtils

protocol DiscountAddDelegate {
    func didRecieveDiscountAddResponse(response: AddDiscountResponse)
}

struct DiscountAddViewModel {
    var delegate: DiscountAddDelegate?

    func DiscountAdd(request: DiscountAddRequest) {
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.DISCOUNT.discount, Loader: true, isMultipart: false) { (response) in
            if response != nil {                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(AddDiscountResponse.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
                        self.delegate?.didRecieveDiscountAddResponse(response: success.self)
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
