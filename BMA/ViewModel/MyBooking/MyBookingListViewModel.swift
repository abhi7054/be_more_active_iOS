//
//  MyBookingListViewModel.swift
//  BMA
//
//  Created by iMac on 13/07/21.
//

import Foundation
import SainiUtils

protocol MyBookingListDelegate {
    func didRecieveMyBookingListResponse(response: BookingListResposne)
}

struct MyBookingListViewModel {
    var delegate: MyBookingListDelegate?

    func MyBookingList(request: MyBookingListRequest, loader: Bool) {
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.BOOKING.myBooking, Loader: loader, isMultipart: false) { (response) in
            if response != nil {                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(BookingListResposne.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
                        self.delegate?.didRecieveMyBookingListResponse(response: success.self)
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
