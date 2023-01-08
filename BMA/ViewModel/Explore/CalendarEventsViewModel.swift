//
//  CalendarEventsViewModel.swift
//  BMA
//
//  Created by MACBOOK on 20/07/21.
//

import Foundation

protocol CalendarEventsDelegate {
    var success: Box<Bool> { get set }
    var calendarEventList: Box<[CalendarEvents]> { get set }
    func fetchCalendarEvents(request: EventListRequest)
}

struct CalendarEventsViewModel: CalendarEventsDelegate {
    var calendarEventList: Box<[CalendarEvents]> = Box([CalendarEvents]())
    var success: Box<Bool> = Box(Bool())
    
    func fetchCalendarEvents(request: EventListRequest) {
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.EVENT.calendar, Loader: true, isMultipart: false) { (response) in
            if response != nil{                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(CalendarEventsResponse.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
                        self.calendarEventList.value = success.data
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
