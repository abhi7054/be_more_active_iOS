//
//  ContactAdminViewModel.swift
//  BMA
//
//  Created by MACBOOK on 31/07/21.
//

import Foundation

protocol ContactAdminDelegate {
    var success: Box<Bool> { get set }
    func contactAdmin(request: ContactAdminRequest)
}

struct ContactAdminViewModel: ContactAdminDelegate {
    var success: Box<Bool> = Box(Bool())
    
    func contactAdmin(request: ContactAdminRequest) {
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.USER.contactAdmin, Loader: true, isMultipart: false) { (response) in
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
