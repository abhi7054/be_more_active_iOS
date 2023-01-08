//
//  UpdateUserViewModel.swift
//  InstantFest
//
//  Created by iMac on 7/07/21.
//

import Foundation
import SainiUtils

protocol UpdateUserDelegate {
    func didRecieveUpdateUserResponse(response: UpdateUserResponse)
}

struct UpdateUserViewModel {
    var delegate: UpdateUserDelegate?
    
    func updateUser(imageData: [UploadImageInfo], updateRequest: UpdateUserRequest) {
        APIManager.sharedInstance.MULTIPART_IS_COOL(imageData, param: updateRequest.toJSON(), api: API.USER.update, login: true) { (response) in
            if response != nil{                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(UpdateUserResponse.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
                        self.delegate?.didRecieveUpdateUserResponse(response: success.self)
                        break
                    default:
                        displayToast(success.message)
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

