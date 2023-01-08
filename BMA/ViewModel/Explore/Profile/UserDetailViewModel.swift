//
//  UserDetailViewModel.swift
//  BMA
//
//  Created by MACBOOK on 26/07/21.
//

import Foundation

protocol UserDetailDelegate {
    var success: Box<Bool> { get set }
    var userDetail: Box<User> { get set }
    func fetchUserDetails()
}

struct UserDetailViewModel: UserDetailDelegate {
    var success: Box<Bool> = Box(Bool())
    var userDetail: Box<User> = Box(User())
    
    func fetchUserDetails() {
        APIManager.sharedInstance.I_AM_COOL(params: [String : Any](), api: API.USER.details, Loader: false, isMultipart: false) { (response) in
            if response != nil{                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(UserDetailResponse.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
                        self.userDetail.value = success.data
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
