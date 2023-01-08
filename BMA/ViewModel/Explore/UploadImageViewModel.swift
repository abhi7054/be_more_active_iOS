//
//  UploadImageViewModel.swift
//  BMA
//
//  Created by MACBOOK on 09/07/21.
//

import Foundation
import SainiUtils

protocol UploadImageDelegate {
    var success: Box<Bool> { get set }
    var data: Box<String> { get set }
    func uploadImage(iamageData: [UploadImageInfo])
}

struct UploadImageViewModel: UploadImageDelegate {
    var data: Box<String> = Box(String())
    var success: Box<Bool> = Box(Bool())
    
    func uploadImage(iamageData: [UploadImageInfo]) {
        APIManager.sharedInstance.MULTIPART_IS_COOL(iamageData, param: [String : Any](), api: API.IMAGE_UPLOAD_REMOVE.add, login: true) { (response) in
            if response != nil{                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(DataModel.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
                        self.data.value = success.data
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
