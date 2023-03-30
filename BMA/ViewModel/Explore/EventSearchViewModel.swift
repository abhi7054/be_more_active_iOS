//
//  EventSearchViewModel.swift
//  BMA
//
//  Created by MACBOOK on 08/07/21.
//

import Foundation
import SainiUtils

protocol EventSearchDelegate {
    var success: Box<Bool> { get set }
    var hasMore: Box<Bool> { get set }
    var eventList: Box<[EventList]> { get set }
    func fetchSearchedListing(request: EventSearchRequest)
}

struct EventSearchViewModel: EventSearchDelegate {
    var hasMore: Box<Bool> = Box(Bool())
    var eventList: Box<[EventList]> = Box([EventList]())
    var success: Box<Bool> = Box(Bool())
    
    func fetchSearchedListing(request: EventSearchRequest) {
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.EVENT.search, Loader: false, isMultipart: false) { (response) in
            if response != nil{                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(EventListResponse.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
                        self.eventList.value = success.data ?? []
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
