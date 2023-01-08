//
//  UpdateEventViewModel.swift
//  BMA
//
//  Created by MACBOOK on 17/07/21.
//

import Foundation

protocol UpdateEventDelegate {
    var success: Box<Bool> { get set }
    var eventDetail: Box<EventDetail> { get set }
    func updateEvent(request: AddEventRequest)
}

struct UpdateEventViewModel: UpdateEventDelegate {
    var eventDetail: Box<EventDetail> = Box(EventDetail())
    var success: Box<Bool> = Box(Bool())
    
    func updateEvent(request: AddEventRequest) {
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.EVENT.update, Loader: true, isMultipart: false) { (response) in
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
