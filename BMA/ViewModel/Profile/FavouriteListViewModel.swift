//
//  FavoriteViewModel.swift
//  BMA
//
//  Created by iMac on 09/07/21.
//

import Foundation
import SainiUtils

protocol FavoriteListDelegate {
    var hasMore: Box<Bool> { get set }
    var favoriteList: Box<[FavoriteListModel]> { get set }
    func FavoriteList(request: MorePageRequest)
}

struct FavoriteListViewModel: FavoriteListDelegate {
    var hasMore: Box<Bool> = Box(Bool())
    var favoriteList: Box<[FavoriteListModel]> = Box([])
    
    func FavoriteList(request: MorePageRequest) {
        APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.FAVORITE.favouriteList, Loader: true, isMultipart: false) { (response) in
            if response != nil{                             //if response is not empty
                do {
                    let success = try JSONDecoder().decode(FavoriteListResponse.self, from: response!) // decode the response into model
                    switch success.code{
                    case 100:
                        self.favoriteList.value += success.data
                        self.hasMore.value = success.hasMore
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
