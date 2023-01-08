//
//  MyBookingDetailsViewModel.swift
//  BMA
//
//  Created by iMac on 14/07/21.
//

import Foundation
import SainiUtils

protocol MyBookingDetailsDelegate {
    func didRecieveMyBookingDetailsResponse(response: BookingDetailsResponse)
}

struct MyBookingDetailsViewModel {
    var delegate: MyBookingDetailsDelegate?

    func MyBookingDetails(request: MyBookingDetailsRequest) {
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.BOOKING.details, Loader: true, isMultipart: false) { (response) in
            if response != nil {                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(BookingDetailsResponse.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
                        self.delegate?.didRecieveMyBookingDetailsResponse(response: success.self)
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

