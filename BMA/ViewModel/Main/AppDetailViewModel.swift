//
//  AppDetailViewModel.swift
//  BMA
//
//  Created by MACBOOK on 17/07/21.
//

import Foundation

protocol AppDetailDelegate {
    var success: Box<Bool> { get set }
    var appDetail: Box<AppDetail> { get set }
    func fetchDetails()
}

struct AppDetailViewModel: AppDetailDelegate {
    var appDetail: Box<AppDetail> = Box(AppDetail())
    var success: Box<Bool> = Box(Bool())
    
    func fetchDetails() {
        APIManager.sharedInstance.I_AM_COOL(params: [String: Any](), api: API.APP_DETAIL.list, Loader: false, isMultipart: false) { (response) in
            if response != nil{                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(AppDetailResponse.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
                        self.appDetail.value = success.data
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

