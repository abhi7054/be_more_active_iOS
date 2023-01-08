//
//  AddFavouriteViewModel.swift
//  BMA
//
//  Created by MACBOOK on 13/07/21.
//

import Foundation
import SainiUtils

protocol AddFavouriteDelegate {
    var success: Box<Bool> { get set }
    func updateFavourite(request: AddFavoriteRequest)
}

struct AddFavouriteViewModel: AddFavouriteDelegate {
    var success: Box<Bool> = Box(Bool())
    
    func updateFavourite(request: AddFavoriteRequest) {
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.FAVORITE.favouriteAdd, Loader: false, isMultipart: false) { (response) in
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
