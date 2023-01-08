//
//  MemberJoinedViewModel.swift
//  BMA
//
//  Created by MACBOOK on 16/07/21.
//

import Foundation

protocol MemberJoinedDelegate {
    var success: Box<Bool> { get set }
    var joinedMemberList: Box<[MemberJoinedList]> { get set }
    func fetchJoinedMemberList(request: ListRequest)
}

struct MemberJoinedViewModel: MemberJoinedDelegate {
    var joinedMemberList: Box<[MemberJoinedList]> = Box([MemberJoinedList]())
    var success: Box<Bool> = Box(Bool())
    
    func fetchJoinedMemberList(request: ListRequest) {
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.EVENT.membersJoined, Loader: false, isMultipart: false) { (response) in
            if response != nil{                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(MemberJoinedResponse.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
                        self.joinedMemberList.value = success.data
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
