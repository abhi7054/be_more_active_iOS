//
//  MyBookingAddViewModel.swift
//  BMA
//
//  Created by iMac on 13/07/21.
//

import Foundation
import SainiUtils

protocol MyBookingAddDelegate {
    func didRecieveBookingCancelResponse(response: SuccessModel)
}

struct MyBookingAddViewModel {
    var delegate: MyBookingAddDelegate?

    func MyBookingCancel(request: MyBookingaAddRequest) {
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.BOOKING.add, Loader: true, isMultipart: false) { (response) in
            if response != nil {                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
                        self.delegate?.didRecieveBookingCancelResponse(response: success.self)
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
