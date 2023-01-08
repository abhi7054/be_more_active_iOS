//
//  NotificationListViewModel.swift
//  InstantFest
//
//  Created by iMac on 18/06/21.
//

import Foundation
import SainiUtils

//protocol NotificationDelegate {
//    var hasMore: Box<Bool> { get set }
//    var notificationList: Box<[NotificationListModel]> { get set }
//    func getNotificationList(request: MorePageRequest)
////    var seenSuccess: Box<Bool> { get set }
////    func getNotificationUpdate(request: NotificationUpdateRequest)
//}
//
//struct NotificationListViewModel: NotificationDelegate {
//    var hasMore: Box<Bool> = Box(Bool())
//    var notificationList: Box<[NotificationListModel]> = Box([])
//
//
//    func getNotificationList(request: MorePageRequest) {
//        APIManager.sharedInstance.I_AM_COOL(params: [String: Any](), api: API.NOTIFICATION.list, Loader: false, isMultipart: false) { (response) in
//            if response != nil{                             //if response is not empty
//                do {
//                    let success = try JSONDecoder().decode(NotificationListResponse.self, from: response!) // decode the response into model
//                    switch success.code{
//                    case 100:
//                        self.notificationList.value += success.data
//                        self.hasMore.value = success.hasMore
//                        break
//                    default:
//                        log.error("\(Log.stats()) \(success.message)")/
//                    }
//                }
//                catch let err {
//                    log.error("ERROR OCCURED WHILE DECODING: \(Log.stats()) \(err)")/
//                }
//            }
//        }
//    }
//}



protocol NotificationDelegate {
    func didRecieveNotificationResponse(response: NotificationListResponse)
}

struct NotificationListViewModel {
    var delegate: NotificationDelegate?

    func NotificationList(request: MorePageRequest) {
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.NOTIFICATION.list, Loader: true, isMultipart: false) { (response) in
            if response != nil {                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(NotificationListResponse.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
                        self.delegate?.didRecieveNotificationResponse(response: success.self)
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
