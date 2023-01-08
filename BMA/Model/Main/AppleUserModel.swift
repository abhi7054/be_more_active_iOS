//
//  AppleuserModel.swift
//  BMA
//
//  Created by iMac on 08/07/21.
//

import Foundation
import AuthenticationServices


struct AppleUser: Codable{
    var id: String
    let firstName: String
    let lastName: String
    let email: String
    
    @available(iOS 13.0, *)
    init(credentials: ASAuthorizationAppleIDCredential){
        self.id = credentials.user
        self.firstName = credentials.fullName?.givenName ?? ""
        self.lastName = credentials.fullName?.familyName ?? ""
        self.email = credentials.email ?? ""
    }
    init(){
        self.id = ""
        self.email = ""
        self.firstName = ""
        self.lastName = ""
    }
}

extension AppleUser:CustomDebugStringConvertible{
    var debugDescription: String{
        return """
        ID:\(id)
        First Name:\(firstName)
        Last Name:\(lastName)
        Email:\(email)
        """
    }
}
