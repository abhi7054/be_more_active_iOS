//
//  Preference.swift
//  Cozy Up
//
//  Created by Keyur on 15/10/18.
//  Copyright © 2018 Keyur. All rights reserved.
//

import UIKit

class Preference: NSObject {

    static let sharedInstance = Preference()
    
    let IS_USER_LOGIN_KEY       =   "IS_USER_LOGIN"
    let IS_USER_SOCIAL_LOGIN_KEY  =   "IS_USER_SOCIAL_LOGIN"
    let USER_DATA_KEY           =   "USER_DATA"
    let IS_USER_INFO_SHOW       =   "IS_USER_INFO_SHOW"
    let PUSH_DEVICE_TOKEN       =   "PUSH_DEVICE_TOKEN"
    
    let CATEGORY_LIST_DATA    =  "CATEGORY_LIST_DATA"
    let ACTIVITY_LIST_DATA    =  "ACTIVITY_LIST_DATA"
}

//MARK: - UserDefaultKeys
struct UserDefaultKeys {
    static let currentUser = "currentUser"
    static let token = "accessToken"
}

func setDataToPreference(data: AnyObject, forKey key: String)
{
    UserDefaults.standard.set(data, forKey: MD5(key))
    UserDefaults.standard.synchronize()
}

func getDataFromPreference(key: String) -> AnyObject?
{
    return UserDefaults.standard.object(forKey: MD5(key)) as AnyObject?
}

func removeDataFromPreference(key: String)
{
    UserDefaults.standard.removeObject(forKey: key)
    UserDefaults.standard.synchronize()
}

func removeUserDefaultValues()
{
    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    UserDefaults.standard.synchronize()
}

//MARK: - Push notification device token
func setPushToken(_ token: String)
{
    setDataToPreference(data: token as AnyObject, forKey: Preference.sharedInstance.PUSH_DEVICE_TOKEN)
//    AppModel.shared.fcmToken = token
}

func getPushToken() -> String
{
    if let token : String = getDataFromPreference(key: Preference.sharedInstance.PUSH_DEVICE_TOKEN) as? String
    {
        let refreshToken = AppDelegate().sharedDelegate().getFCMToken()
        if refreshToken == token {
            return token
        }
        else {
            return refreshToken
        }
    }
    return AppDelegate().sharedDelegate().getFCMToken()
}

//MARK: - User login boolean
func setIsUserLogin(isUserLogin: Bool)
{
    setDataToPreference(data: isUserLogin as AnyObject, forKey: Preference.sharedInstance.IS_USER_LOGIN_KEY)
}

func isUserLogin() -> Bool
{
    let isUserLogin = getDataFromPreference(key: Preference.sharedInstance.IS_USER_LOGIN_KEY)
    return isUserLogin == nil ? false:(isUserLogin as! Bool)
}

//func setLoginUserData(_ dictData: UserDataModel)
//{
//    print(dictData)
//    UserDefaults.standard.set(encodable: dictData, forKey: Preference.sharedInstance.USER_DATA_KEY)
//    setIsUserLogin(isUserLogin: true)
//}
//
//func getLoginUserData() -> UserDataModel?
//{
//    if let data = UserDefaults.standard.get(UserDataModel.self, forKey: Preference.sharedInstance.USER_DATA_KEY)
//    {
//        return data
//    }
//    return nil
//}

//MARK: - User login boolean
func setIsSocialUser(isUserLogin: Bool)
{
    setDataToPreference(data: isUserLogin as AnyObject, forKey: Preference.sharedInstance.IS_USER_SOCIAL_LOGIN_KEY)
}

func isSocialUser() -> Bool
{
    let isSocialUser = getDataFromPreference(key: Preference.sharedInstance.IS_USER_SOCIAL_LOGIN_KEY)
    return isSocialUser == nil ? false:(isSocialUser as! Bool)
}


//MARK: - Show User Info
func setIsUserShownInfo(isUserLogin: Bool)
{
    UserDefaults.standard.set(encodable: isUserLogin, forKey: Preference.sharedInstance.IS_USER_INFO_SHOW)
}

func isUserShownInfo() -> Bool
{
    let isUserLogin = UserDefaults.standard.get(Bool.self, forKey: Preference.sharedInstance.IS_USER_INFO_SHOW)
    return (isUserLogin == nil ? false:(isUserLogin)) ?? false
}

func setActivityListData(_ dictData: [CategoryListModel])
{
    UserDefaults.standard.set(encodable: dictData, forKey: Preference.sharedInstance.ACTIVITY_LIST_DATA)
}

func getActivityListData() -> [CategoryListModel]
{
    if let data = UserDefaults.standard.get([CategoryListModel].self, forKey: Preference.sharedInstance.ACTIVITY_LIST_DATA)
    {
        return data
    }
    return []
}

func setCategoryListData(_ dictData: [CategoryListModel])
{
    UserDefaults.standard.set(encodable: dictData, forKey: Preference.sharedInstance.CATEGORY_LIST_DATA)
}

func getCategoryListData() -> [CategoryListModel]?
{
    if let data = UserDefaults.standard.get([CategoryListModel].self, forKey: Preference.sharedInstance.CATEGORY_LIST_DATA)
    {
        return data
    }
    return nil
}


