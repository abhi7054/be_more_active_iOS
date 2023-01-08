//
//  GlobalConstants.swift
//  forthgreen
//
//  Created by MACBOOK on 04/05/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

//MARK: - STORYBOARD
struct STORYBOARD {
    static let MAIN = UIStoryboard(name: "Main", bundle: nil)
    static let EXPLORE = UIStoryboard(name: "Explore", bundle: nil)
    static let BOOKING = UIStoryboard(name: "MyBooking", bundle: nil)
    static let PROFILE = UIStoryboard(name: "Profile", bundle: nil)
}

//MARK:- AppColors
struct AppColors{
    static let LoaderColor =  UIColor.darkGray
    static let themeColor = #colorLiteral(red: 0.9921568627, green: 0.7450980392, blue: 0.05882352941, alpha: 1)
}

//MARK:- DocumentDefaultValues
struct DocumentDefaultValues{
    struct Empty{
        static let string =  ""
        static let int =  0
        static let bool = false
        static let double = 0.0
    }
}

//MARK: - SCREEN
struct SCREEN {
    static var WIDTH = UIScreen.main.bounds.size.width
    static var HEIGHT = UIScreen.main.bounds.size.height
}


//MARK: - SelectedSub
struct SelectedSub {
    var id: String
    var name: String
    var isSelected: Bool
}

//MARK: - SUBSCIPTION_HEADING
struct SUBSCIPTION_HEADING {
    static var headingList = [
        SelectedSub(id: "1", name: "Monthly", isSelected: true),
        SelectedSub(id: "2", name: "3 Months", isSelected: false),
        SelectedSub(id: "3", name: "6 Months", isSelected: false),
        SelectedSub(id: "4", name: "Annually", isSelected: false)
    ]
}

//MARK: - UploadImageInfo
struct UploadImageInfo {
    var name: String
    var data: Data
    var isImagePresent: Bool
}

//MARK: - AddRatingInfo
struct AddRatingInfo {
    init(eventName: String, image: String, location: String) {
        self.eventName = eventName
        self.image = image
        self.location = location
    }
    
    init() {
        self.eventName = DocumentDefaultValues.Empty.string
        self.image = DocumentDefaultValues.Empty.string
        self.location = DocumentDefaultValues.Empty.string
    }
    
    var eventName, image, location: String
}

enum VERIFICATION_TYPE:Int{
    case password_reset = 1
    case email_verification = 2
    
    func getValue() ->Int{
        return self.rawValue
    }
}

//MARK: - PLACEHOLDER
enum PLACEHOLDER:String{
    case profile_img = "ic_signup_image-upload"
    func getValue() ->String{
        return self.rawValue
    }
}

//MARK: - KEY_CHAIN
enum KEY_CHAIN:String{
    case apple
}

enum SocialType : Int {
    case facebook = 1
    case google = 3
    case apple = 2
}

enum GOOGLE:String {
    case PLACE_KEY = "AIzaSyBIP2Yp59o6_jc0P5OEexAxyhAQDjLpxxI"
    case CLIENT_ID = "983504886584-f9m2fc1lgkd3ls2a1qrlgv0m13rhbjl5.apps.googleusercontent.com"


}


