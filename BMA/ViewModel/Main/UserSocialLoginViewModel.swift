//
//  UserSocialLoginViewModel.swift
//  BMA
//
//  Created by iMac on 07/07/21.
//

import Foundation
import SainiUtils

protocol SocialLoginDelegate {
    func didRecieveSocialLoginResponse(response: LoginResponse)
}

struct SocialLoginViewModel {
    var delegate: SocialLoginDelegate?

    func SocialLogin(request: SocialLoginRequest) {
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.USER.socialLogin, Loader: true, isMultipart: false) { (response) in
            if response != nil{                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(LoginResponse.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
                        self.delegate?.didRecieveSocialLoginResponse(response: success.self)
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
}


