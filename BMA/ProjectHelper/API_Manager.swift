//
//  API_Helper.swift
//  Trouvaille-ios
//
//  Created by MACBOOK on 01/04/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation
import SystemConfiguration
import Alamofire
import SainiUtils

public class APIManager {
    
    static let sharedInstance = APIManager()
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func getMultipartHeader() -> [String:String]{
        return ["Content-Type":"multipart/form-data"]
    }
    
    func getJsonHeader() -> [String:String]{
        return ["Content-Type":"application/json"]
    }
    
    func getJsonHeaderWithToken() -> [String:String]{
        if let token = UserDefaults.standard.value(forKey: USER_DEFAULT_KEYS.token.rawValue) as? String {
            return ["Content-Type":"application/json", "Authorization": token]
        }
        else {
            return ["Content-Type":"application/json", "Authorization":AppModel.shared.token]
        }
    }
    
    func getMultipartHeaderWithToken() -> [String:String]{
        if let token = UserDefaults.standard.value(forKey: USER_DEFAULT_KEYS.token.rawValue) as? String {
            return ["Content-Type":"multipart/form-data", "Authorization": token]
        }
        else {
            return ["Content-Type":"multipart/form-data", "Authorization":AppModel.shared.token]
        }
    }
    
    func getx_www_orm_urlencoded() -> [String:String]{
        if let token = UserDefaults.standard.value(forKey: USER_DEFAULT_KEYS.token.rawValue) as? String {
            return ["Content-Type":"x-www-form-urlencoded", "Authorization": token]
        }
        else {
            return ["Content-Type":"x-www-form-urlencoded", "Authorization":AppModel.shared.token]
        }
        
    }
    
    func networkErrorMsg()
    {
        log.error("You are not connected to the internet")/
        displayToast("You are not connected to the internet")
    }
    
    //MARK:- ERROR CODES
    func handleError(errorCode: Int) -> String {
        switch errorCode {
        case 101:
            return "Missing Required Properties"
        case 102:
            return "Connection Error"
        case 103:
            return "Requested user not found"
        case 104:
            return "Username/Password error"
        case 105:
            return "Nothing Modified/ No changes Made"
        case 106:
            return "Invalid Access Token"
        case 107:
            return "This Email id is already registered."
        case 108:
            return "Invalid OTP type."
        case 109:
            return "Token not verified."
        case 110:
            return "Email id already verified."
        case 111:
            return "Verficiation code try has been expired. Request a new token."
        case 112:
            return "verification code has been expired. Token expires in 24 hours."
        case 113:
            return "Invlid URL provided for verification."
        case 114:
            return "Broken reference found."
        case 115:
            return "Profile seems to have missing region data or you are trying to post in wrong region."
        case 400:
            return "Malformed Authorization token error when token in invalid or has been expired."
        case 500:
            return "Generic error or some default error"
            
        default:
            return ""
        }
        
    }
    
    //MARK:- MULTIPART_IS_COOL
    func MULTIPART_IS_COOL(_ imageArr: [UploadImageInfo], param: [String: Any],api: String,login: Bool, _ completion: @escaping (_ dictArr: Data?) -> Void){
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        
        DispatchQueue.main.async {
            showLoader()
        }
        
        let headerParams: HTTPHeaders = HTTPHeaders.init(login == true ? self.getMultipartHeaderWithToken() : self.getJsonHeaderWithToken())
        var params :[String : Any] = [String : Any] ()
        
        print("API URL ", api)
        print("header ", headerParams)
        print("param ", params)
        
        params["data"] = toJson(param)//Converting Array into JSON Object
        log.info("PARAMS: \(Log.stats()) \(params)")/
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if imageArr.count != 0
            {
                for image in imageArr {
                    if image.data != nil {
                        multipartFormData.append(image.data, withName: image.name, fileName: getCurrentTimeStampValue() + ".png", mimeType: "image/png")
                    }
                }
            }
            
        }, to: api, method: .post, headers: headerParams).responseJSON { (response) in
            
            switch response.result {
            case .success(let dict):
                DispatchQueue.main.async {
                    removeLoader()
                }
                
                print(dict)
                if let result = dict as? [String: Any] {
                    if let code = result["code"] as? Int{
                        if(code == 100){
                            
                            DispatchQueue.main.async {
                                completion(response.data)
                            }
                            return
                        }
                        else if code == 401{
                            if (result["message"] as? String) != nil{
                                AppDelegate().sharedDelegate().continueToLogout()
//                              displayToast(message)
                                return
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                completion(response.data)
                            }
                            if let message = result["message"] as? String{
                               displayToast(message)
                            }
                            return
                        }
                    }
                    if let message = result["message"] as? String{
                        print(message)
                        return
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    removeLoader()
                }
                print(error)
                displayToast(error.localizedDescription)
                break
            }
        }
    }
    
    //MARK:- I AM COOL
    func I_AM_COOL(params: [String: Any],api: String,Loader: Bool,isMultipart:Bool,_ completion: @escaping (_ dictArr: Data?) -> Void){
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        
        if Loader == true{
            DispatchQueue.main.async {
                showLoader()
            }
        }
        
        DispatchQueue.global().async {
            let headerParams: HTTPHeaders = HTTPHeaders.init(isMultipart == true ? self.getMultipartHeaderWithToken() : self.getJsonHeaderWithToken())
            var Params:[String: Any] = [String: Any]()
            if isMultipart == true{
                Params["data"] = toJson(params)
            }
            else{
                Params = params
            }
            log.info("HEADERS: \(Log.stats()) \(headerParams)")/
            log.info("API: \(Log.stats()) \(api)")/
            log.info("PARAMS: \(Log.stats()) \(Params)")/
            
            
            AF.request(api, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
                
                DispatchQueue.main.async {
                    removeLoader()
                }
                
                print("Response ", response.data?.prettyPrintedJSONString)
                
                switch response.result {
                case .success(let dict):
    //                log.result("\(String(describing: response.result.value))")/
                    log.ln("prettyJSON Start \n")/
                    log.result("\(String(describing: response.data?.prettyPrintedJSONString))")/
                    log.ln("prettyJSON End \n")/
                    if let result = dict as? [String: Any] {
                        if let code = result["code"] as? Int{
                            if(code == 100){
                                
                                DispatchQueue.main.async {
                                    completion(response.data)
                                }
                                return
                            }
                            else if code == 401{
                                if (result["message"] as? String) != nil{
                                    AppDelegate().sharedDelegate().continueToLogout()
//                                    displayToast(message)
                                    return
                                }
                            }
                            else{
                                if let message = result["message"] as? String{
                                    print(message)
                                    displayToast(message)
                                }
                                return
                            }
                        }
                        if let message = result["message"] as? String{
                            print(message)
                            return
                        }
                    }
                case .failure(let error):
                    log.error("\(Log.stats()) \(error)")/
                    displayToast("Server Error please check server logs.")
                    break
                }
            }
        }
    }
}
