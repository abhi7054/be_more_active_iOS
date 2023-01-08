//
//  ActivityListViewModel.swift
//  BMA
//
//  Created by iMac on 08/07/21.
//

import Foundation
import SainiUtils

protocol ActivityListDelegate {
    func didRecieveActivityListResponse(response: CategoryListResponse)
}

struct ActivityListViewModel {
    var delegate: ActivityListDelegate?

    func ActivityList(request: ActivityListRequest) {
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.ACTIVITY.activityList, Loader: true, isMultipart: false) { (response) in
            if response != nil {                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(CategoryListResponse.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
                        print("Data  loaded successfully ", response?.prettyPrintedJSONString)
                        self.delegate?.didRecieveActivityListResponse(response: success.self)
                        break
                    default:
                        displayToast(success.message)
                        print("Data  loaded fail ", response?.prettyPrintedJSONString)
                        log.error("\(Log.stats()) \(success.message)")/
                    }
                }
                catch let err {
                    log.error("ERROR OCCURED WHILE DEC4ODING: \(Log.stats()) \(err)")/
                }
            }
        }
    }
    
    func getMyActivityList(_ completion: @escaping (_ response: [CategoryModel]) -> Void) {
        APIManager.sharedInstance.I_AM_COOL(params: [String : Any](), api: API.ACTIVITY.myActivityList, Loader: true, isMultipart: false) { (response) in
            if response != nil {                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(MyActivityResponse.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
                        completion(success.data.self)
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
