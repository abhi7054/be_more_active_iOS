//
//  CalendarListViewModel.swift
//  BMA
//
//  Created by MACBOOK on 21/07/21.
//

import Foundation

protocol CalendarListDelegate {
    var success: Box<Bool> { get set }
    var calendarList: Box<CalendarList> { get set }
    func fetchCalenderEventList(request: CalendarListRequest)
}

struct CalendarListViewModel: CalendarListDelegate {
    var calendarList: Box<CalendarList> = Box(CalendarList())
    var success: Box<Bool> = Box(Bool())
    
    func fetchCalenderEventList(request: CalendarListRequest) {
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.EVENT.calendarList, Loader: true, isMultipart: false) { (response) in
            if response != nil{                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(CalendarListResponse.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
                        self.calendarList.value = success.data
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
