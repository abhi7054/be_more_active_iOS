//
//  SignUpViewModel.swift
//  TBC
//
//  Created by iMac on 5/21/21.
//  Copyright © 2021 iMac. All rights reserved.
//

import Foundation
import SainiUtils

protocol SignUpDelegate {
    func didRecieveSignUpResponse(response: SuccessModel)
}

struct SignUpViewModel {
    var delegate: SignUpDelegate?
    
    func signUpUser(signUpRequest: SignupRequest) {
        APIManager.sharedInstance.I_AM_COOL(params: signUpRequest.toJSON(), api: API.USER.signup, Loader: true, isMultipart: false) { (response) in
            if response != nil{                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(SuccessModel.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
                        self.delegate?.didRecieveSignUpResponse(response: success.self)
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

