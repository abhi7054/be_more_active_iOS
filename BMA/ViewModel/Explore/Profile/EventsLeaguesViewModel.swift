//
//  EventsLeaguesViewModel.swift
//  BMA
//
//  Created by iMac on 15/07/21.
//

import Foundation
import SainiUtils

protocol EventsLeaguesDelegate {
    var success: Box<Bool> { get set }
    var eventList: Box<[EventList]> { get set }
    func EventsLeagues(page: Int)
}

struct EventsLeaguesViewModel: EventsLeaguesDelegate {
    var eventList: Box<[EventList]> = Box([EventList]())
    var success: Box<Bool> = Box(Bool())

    func EventsLeagues(page: Int) {
        APIManager.sharedInstance.I_AM_COOL(params: ["page": page], api: API.EVENT.myList, Loader: true, isMultipart: false) { (response) in
            if response != nil {                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(EventListResponse.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
                        self.eventList.value = success.data ?? []
                        self.success.value = true
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
    
    func deleteEventLocally(eventRef: String) {
        self.eventList.value = self.eventList.value.filter({ $0.id != eventRef })
    }
}
