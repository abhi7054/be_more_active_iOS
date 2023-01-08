//
//  CategoryViewModel.swift
//  BMA
//
//  Created by iMac on 07/07/21.
//

import Foundation
import SainiUtils

protocol CategoryViewDelegate {
     func didRecieveCategoryListResponse(response: CategoryListResponse)
}

struct CategoryViewModel {
   var delegate: CategoryViewDelegate?

   func getCategoryList(request: CategoryRequest) {
       APIManager.sharedInstance.I_AM_COOL(params: request.toJSON(), api: API.CATEGORY.list, Loader: false, isMultipart: false) { (response) in
           if response != nil{                             //if response is not empty
               do {
                   let success = try JSONDecoder().decode(CategoryListResponse.self, from: response!) // decode the response into model
                   switch success.code{
                   case 100:
                       self.delegate?.didRecieveCategoryListResponse(response: success.self)
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
