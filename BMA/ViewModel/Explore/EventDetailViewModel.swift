//
//  EventDetailViewModel.swift
//  BMA
//
//  Created by MACBOOK on 09/07/21.
//

import Foundation
import SainiUtils

protocol EventDetailDelegate {
    var success: Box<Bool> { get set }
    var eventDetail: Box<EventDetail> { get set }
    func fetchEventDetail(request: EventDetailRequest)
}

struct EventDetailViewModel: EventDetailDelegate {
    var eventDetail: Box<EventDetail> = Box(EventDetail())
    var success: Box<Bool> = Box(Bool())
    
    func fetchEventDetail(request: EventDetailRequest) {
        var api: String = String()
        if AppModel.shared.isGuestUser {
            api = API.EVENT.guestDetail
        }
        else {
            api = API.EVENT.details
        }
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: api, Loader: true, isMultipart: false) { (response) in
            if response != nil{                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(EventDetailResponse.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
                        self.eventDetail.value = success.data
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
