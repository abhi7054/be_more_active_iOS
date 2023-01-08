//
//  AddEventViewModel.swift
//  BMA
//
//  Created by MACBOOK on 09/07/21.
//

import Foundation
import SainiUtils

protocol AddEventDelegate {
    var success: Box<Bool> { get set }
    func addNewEvent(request: AddEventRequest)
}

struct AddEventViewModel: AddEventDelegate {
    var success: Box<Bool> = Box(Bool())
    
    func addNewEvent(request: AddEventRequest) {
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.EVENT.add, Loader: true, isMultipart: false) { (response) in
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
