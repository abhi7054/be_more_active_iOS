//
//  SocialLogin.swift
//  E-Auction
//
//  Created by iMac on 08/07/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
//import FBSDKLoginKit
import GoogleSignIn
import SainiUtils
import AuthenticationServices

//Gmail account & Firebase :    pw:
//Facebook account :    pw:


class SocialLogin: UIViewController, GIDSignInDelegate {
    
//    let fbLoginManager = LoginManager()
    private var SocialLoginVM: SocialLoginViewModel = SocialLoginViewModel()
    var isFromLogin : Bool = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().delegate = self
        SocialLoginVM.delegate = self
    }
    
    //MARK: - Facebook Login
//    func loginWithFacebook() {
//        fbLoginManager.logOut()
//        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: AppDelegate().sharedDelegate().window?.rootViewController) { (result, error) in
//            if error != nil {
//                return
//            }
//            guard let token = result?.token else {
//                return
//            }
//
//            let accessToken : String = token.tokenString as String
//
//            if accessToken == "" {
//                return
//            }
//
//            let request : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields" : "picture.width(500).height(500), email, id, name, first_name, last_name, gender"])
//
//            let connection : GraphRequestConnection = GraphRequestConnection()
//            connection.add(request) { (connection, result, error) in
//
//                if result != nil
//                {
//                    let dict = result as! [String : AnyObject]
//                    log.info("\(dict)")/
//
//                    guard let userId = dict["id"] as? String else { return }
//
//                    var emailId = ""
//                    if let email = dict["email"]
//                    {
//                        emailId = email as! String
//                    }
//
//                    var name = ""
//                    if let temp = dict["name"] as? String {
//                        name = temp
//                    }
//                    var imgUrl = ""
//                    if let picture = dict["picture"] as? [String : Any]
//                    {
//                        if let data = picture["data"] as? [String : Any]
//                        {
//                            if let url = data["url"]
//                            {
//                                imgUrl = url as! String
//                            }
//                        }
//                    }
//                    let socialRequest = SocialLoginRequest(socialId: userId, socialToken: accessToken, socialIdentifier: SocialType.facebook.rawValue, email: emailId, picture: imgUrl, device: "iOS", fcmToken: getPushToken(), name: name)
//                    log.info("PARAMS: \(Log.stats()) \(socialRequest)")/
//                    self.SocialLoginVM.SocialLogin(request: socialRequest)
//                }
//            }
//            connection.start()
//        }
//    }
    
    //MARK: - GoogleLogin
    
    func loginWithGoogle() {
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            log.error("\(error.localizedDescription)")/
        } else {
            // Perform any operations on signed in user here.
            log.info(user.userID ?? "")/               // For client-side use only!
            log.info(user.authentication.idToken ?? "")/ // Safe to send to the server
            log.info(user.profile.name ?? "")/
            log.info(user.profile.givenName ?? "")/
            log.info(user.profile.familyName ?? "")/
            log.info(user.profile.email ?? "")/
            
            guard let token = user.authentication.idToken  else { return }
            guard let userId = user.userID else { return }
            
            var emailId = ""
            if let email = user.profile.email
            {
                emailId = email
            }
            var fname = ""
            if let temp = user.profile.givenName {
                fname = temp
            }
            
//            var lname = ""
//            if let temp = user.profile.familyName {
//                lname = temp
//            }
            
            var imgUrl = ""
            if user.profile.hasImage
            {
                if let url = user.profile.imageURL(withDimension: 200)?.absoluteString
                {
                    imgUrl = url
                }
            }
            let socialRequest = SocialLoginRequest(socialId: userId, socialToken: token, socialIdentifier: SocialType.google.rawValue, email: emailId, picture: imgUrl, device: "iOS", fcmToken: getPushToken(), name: fname)
            
            log.info("PARAMS: \(Log.stats()) \(socialRequest)")/
            self.SocialLoginVM.SocialLogin(request: socialRequest)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        log.error("\(Log.stats()) \(error!)")/
    }
    
    
    //Apple login
    @objc func actionHandleAppleSignin() {
        if #available(iOS 13.0, *) {
            let authorizationAppleIDProvider = ASAuthorizationAppleIDProvider()
            let authorizationRequest = authorizationAppleIDProvider.createRequest()
            authorizationRequest.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [authorizationRequest])
            authorizationController.presentationContextProvider = self
            authorizationController.delegate = self
            authorizationController.performRequests()
        } else {
            displayToast("Kindly update your OS")
        }
    }
}

//MARK: - SocialLoginDelegate
extension SocialLogin: SocialLoginDelegate {
    func didRecieveSocialLoginResponse(response: LoginResponse) {
        self.view.endEditing(true)
        
        guard let data = response.data  else { return }
        UserDefaults.standard.setValue(data.accessToken, forKey: USER_DEFAULT_KEYS.token.rawValue)
        UserDefaults.standard.set(encodable: data.user, forKey: USER_DEFAULT_KEYS.currentUser.rawValue)
        AppModel.shared.currentUser = data.user
        AppModel.shared.token = data.accessToken
        AppModel.shared.isGuestUser = false
        
        if AppModel.shared.currentUser.profileCompleted {
            AppDelegate().sharedDelegate().navigateToDashboard()
        }
        else{
            let vc: SetUpProfileVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.SetUpProfileVC.rawValue) as! SetUpProfileVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


@available(iOS 13.0, *)
extension SocialLogin: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    // ASAuthorizationControllerDelegate function for authorization failed
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.view.endEditing(true)
        log.error("\(Log.stats()) \(error)")/
    }
    
    // ASAuthorizationControllerDelegate function for successful authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential{
        case let credentials as ASAuthorizationAppleIDCredential:
            var appleUser = AppleUser()
            appleUser = AppleUser(credentials: credentials)
            if appleUser.email != ""{
                KeychainWrapper.standard.set(appleUser.toJSONData(), forKey: KEY_CHAIN.apple.rawValue)
            }
            else{
                if let storedAppleCred = KeychainWrapper.standard.data(forKey: KEY_CHAIN.apple.rawValue){
                    if let apple = try? JSONDecoder().decode(AppleUser.self, from: storedAppleCred){
                        appleUser = apple
                    }
                }
            }
            appleUser.id = credentials.user
            log.success("Apple User: \(appleUser)")/
            self.saveUserInKeychain(appleUser.id)
            let socialToken = String(decoding : credentials.identityToken ?? Data(), as: UTF8.self)
            
            let socialRequest = SocialLoginRequest(socialId: appleUser.id, socialToken: socialToken, socialIdentifier: SocialType.apple.rawValue, email: appleUser.email, device: "iOS", fcmToken: getPushToken(), name: appleUser.firstName)
            
            log.info("PARAMS: \(Log.stats()) \(socialRequest)")/
            self.SocialLoginVM.SocialLogin(request: socialRequest)
        case let passwordCredential as ASPasswordCredential:
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            //  show the password credential as an alert.
            DispatchQueue.main.async {
                self.showPasswordCredentialAlert(username: username, password: password)
            }
        default:
            break
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    private func saveUserInKeychain(_ userIdentifier: String) {
        do {
            try KeychainItem(service: "com.app.aura", account: "userIdentifier").saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    
    private func showPasswordCredentialAlert(username: String, password: String) {
        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
