//
//  NotificationSeenViewModel.swift
//  BMA
//
//  Created by MACBOOK on 21/07/21.
//

import Foundation

protocol NotificationSeenDelegate {
    var success: Box<Bool> { get set }
    func markNotificationSeen(request: NotificationSeenRequest)
}

struct NotificationSeenViewModel: NotificationSeenDelegate {
    var success: Box<Bool> = Box(Bool())
    
    func markNotificationSeen(request: NotificationSeenRequest) {
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.NOTIFICATION.seen, Loader: false, isMultipart: false) { (response) in
            if response != nil{                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
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
