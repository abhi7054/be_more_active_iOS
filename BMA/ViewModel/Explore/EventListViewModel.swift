//
//  EventListViewModel.swift
//  BMA
//
//  Created by MACBOOK on 08/07/21.
//

import Foundation
import SainiUtils

protocol EventListDelegate {
    var success: Box<Bool> { get set }
    var hasMore: Box<Bool> { get set }
    var eventList: Box<[EventList]> { get set }
    func fetchEventListing(request: EventListRequest, loader: Bool)
}

struct EventListViewModel: EventListDelegate {
    var eventList: Box<[EventList]> = Box([EventList]())
    var hasMore: Box<Bool> = Box(Bool())
    var success: Box<Bool> = Box(Bool())
    
    func fetchEventListing(request: EventListRequest, loader: Bool) {
        var api: String = String()
        if AppModel.shared.isGuestUser {
            api = API.EVENT.guestList
        }
        else {
            api = API.EVENT.list
        }
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: api, Loader: loader, isMultipart: false) { (response) in
            print("Success found ", response)
            if response != nil{                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(EventListResponse.self, from: response!) // decode the response into model
                    print("Success found ", success.data)
                    switch success.code{
                    case 100:
                        self.eventList.value += success.data ?? []
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
