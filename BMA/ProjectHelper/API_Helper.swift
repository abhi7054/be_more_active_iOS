//
//  API_Helper.swift
//  Trouvaille-ios
//
//  Created by MACBOOK on 01/04/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation

//MARK: - AppImageUrl
struct AppImageUrl {
    
    //Dev
//    static let IMAGE_BASE = "https://be-more-active.s3.us-east-2.amazonaws.com/development/images/"
    
    //Staging
//    static let IMAGE_BASE = "https://be-more-active.s3.us-east-2.amazonaws.com/staging/images/"
    
    //Production
    static let IMAGE_BASE = "https://be-more-active.s3.us-east-2.amazonaws.com/production/images/"
    
    static let small = IMAGE_BASE + "small/"
    static let average = IMAGE_BASE + "average/"
    static let best = IMAGE_BASE + "best/"
}

//MARK: - API
struct API {
    //Development
//    static let BASE_URL = "http://3.131.188.109:3000/api/"
    
    //Staging
//    static let BASE_URL = "http://18.217.123.31:3000/api/"
    
    //Production
    static let BASE_URL = "https://18.190.105.31:3000/api/"
    
    
    struct USER {
        static let signup                 = BASE_URL + "user/signup"
        static let login                  = BASE_URL + "user/login"
        static let resendVerification     = BASE_URL + "user/resendVerification"
        static let socialLogin            = BASE_URL + "user/socialLogin"
        static let update                 = BASE_URL + "user/update"
        static let details                = BASE_URL + "user/details"
        static let search                 = BASE_URL + "user/search"
        static let contactAdmin           = BASE_URL + "user/contactAdmin"
    }
    
    struct CATEGORY {
        static let list                   = BASE_URL + "category/list"
    }
    
    struct EVENT {
        static let list                   = BASE_URL + "event/list"
        static let add                    = BASE_URL + "event/add"
        static let update                 = BASE_URL + "event/update"
        static let search                 = BASE_URL + "event/search"
        static let details                = BASE_URL + "event/details"
        static let myList                 = BASE_URL + "event/myList"
        static let membersJoined          = BASE_URL + "event/memberJoined"
        static let delete                 = BASE_URL + "event/delete"
        static let calendar               = BASE_URL + "event/calender"
        static let calendarList           = BASE_URL + "event/calenderList"
        static let guestList              = BASE_URL + "event/guestList"
        static let guestDetail            = BASE_URL + "event/guestView"
        static let couponList             = BASE_URL + "event/couponList"
    }
    
    struct IMAGE_UPLOAD_REMOVE {
        static let add                    = BASE_URL + "image/add"
        static let delete                 = BASE_URL + "image/delete"
    }
    
    struct APP_DETAIL {
        static let list                   = BASE_URL + "appDetail/list"
    }
    
    struct FAQS {
        static let list                   = BASE_URL + "faq/list"
    }
    
    struct NOTIFICATION {
        static let list                   = BASE_URL + "notification/list"
        static let seen                   = BASE_URL + "notification/seen"
        static let count                  = BASE_URL + "notification/count"
    }
    
    struct CHAT {
        static let create                 = BASE_URL + "chat/create"
        static let listChats              = BASE_URL + "chat/list"
        static let listMessages           = BASE_URL + "chat/listMessages"
        static let member                 = BASE_URL + "chat/members"
    }
    
    struct DISCOUNT {
        static let discount                 = BASE_URL + "discount/add"
        static let discountList             = BASE_URL + "discount/list"
        static let discountDelete           = BASE_URL + "discount/delete"
    }
    struct BOOKING {
        static let add                      = BASE_URL + "booking/add"
        static let cancel                   = BASE_URL + "booking/cancel"
        static let myBooking                = BASE_URL + "booking/myBooking"
        static let details                  = BASE_URL + "booking/details"
    }
    
    struct FAVORITE {
        static let favouriteAdd      = BASE_URL + "favourite/add"
        static let favouriteList     = BASE_URL + "favourite/list"
    }
    
    struct ACTIVITY {
        static let activityList      = BASE_URL + "activity/list"
        static let myActivityList    = BASE_URL + "user/activityList"
    }
    
    struct REPORT {
        static let add                 = BASE_URL + "report/add"
    }
    
    struct RATING {
        static let add                    = BASE_URL + "rating/add"
        static let list                   = BASE_URL + "rating/list"
    }
    
    struct SUBSCRIPTION {
        static let create                 = BASE_URL + "subscription/create"
    }
}
