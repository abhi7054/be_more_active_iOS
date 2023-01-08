//
//  LoginVC.swift
//  CollectionApp
//
//  Created by MACBOOK on 17/10/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

class LoginVC: SocialLogin {
    
    //OUTLETS
    @IBOutlet weak var termsLbl: UILabel!
    @IBOutlet weak var termsCheckBtn: UIButton!
    @IBOutlet weak var continueAsGuestBtn: UIButton!
    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var welcomeView: UIView!
    
    
    private var LoginVM : LoginViewModel = LoginViewModel()
    var isFromGuestLogin = false
    var isSignUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate().sharedDelegate().hideTabBar()
    }
    
    //MARK: - viewWillLayoutSubviews
    override func viewWillLayoutSubviews() {
        setCornerRadius(welcomeView, true, 40)
    }
    
    //MARK: - configUI
    private func configUI() {
        loginBtn.sainiCornerRadius(radius: 10)
        createAccountBtn.sainiCornerRadius(radius: 10)
        continueAsGuestBtn.sainiCornerRadius(radius: 10)
        continueAsGuestBtn.layer.borderColor = AppColors.LoaderColor.cgColor
        continueAsGuestBtn.layer.borderWidth = 1
        
        LoginVM.delegate = self
        termsGesture()
    }
    
    //MARK: - termsGesture
    private func termsGesture(){
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:)))
        termsLbl.isUserInteractionEnabled = true
        termsLbl.addGestureRecognizer(tapAction)
    }
    
    //MARK: - tapLabel
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
         let text = (termsLbl.text)!
         let termsRange = (text as NSString).range(of: "Terms of Service")

         if gesture.didTapAttributedTextInLabel(label: termsLbl, inRange: termsRange) {
            guard let url = URL(string: "https://beemoreactive.wixsite.com/beemoreactive/copy-of-policies") else {
                return
            }
             if #available(iOS 10.0, *) {
                 UIApplication.shared.open(url, options: [:], completionHandler: nil)
             } else {
                 UIApplication.shared.openURL(url)
             }
         } else {
             print("Tapped none")
         }
     }
    
    //MARK: - termsCheckBtnIsPressed
    @IBAction func termsCheckBtnIsPressed(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    //MARK: - facebookBtnIsPressed
    @IBAction func facebookBtnIsPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        setIsSocialUser(isUserLogin: true)
        if !termsCheckBtn.isSelected {
            displayToast(STATIC_LABELS.termsCheckToast.rawValue)
        } else {
            self.loginWithFacebook()
        }
    }
    
    //MARK: - appleBtnIsPressed
    @IBAction func appleBtnIsPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        setIsSocialUser(isUserLogin: true)
        if !termsCheckBtn.isSelected {
            displayToast(STATIC_LABELS.termsCheckToast.rawValue)
        } else {
            self.actionHandleAppleSignin()
        }
    }
    
    //MARK: - googleBtnIsPressed
    @IBAction func googleBtnIsPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        setIsSocialUser(isUserLogin: true)
        if !termsCheckBtn.isSelected {
            displayToast(STATIC_LABELS.termsCheckToast.rawValue)
        } else {
            self.loginWithGoogle()
        }
    }
    
    //MARK: - eyeBtnOfPasswordIsPressed
    @IBAction func eyeBtnOfPasswordIsPressed(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            passwordTextfield.isSecureTextEntry = true
        }
        else {
            sender.isSelected = true
            passwordTextfield.isSecureTextEntry = false
        }
    }
    
    //MARK: - loginBtnIsPressed
    @IBAction func loginBtnIsPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let email = emailTextfield.text else { return }
        guard let password = passwordTextfield.text else { return }
        if email == DocumentDefaultValues.Empty.string {
            displayToast(STATIC_LABELS.emptyEmail.rawValue)
        }
        else if !email.isValidEmail {
            displayToast(getTranslate(STATIC_LABELS.notValidEmail.rawValue))
        }
        else if password == DocumentDefaultValues.Empty.string {
            displayToast(getTranslate(STATIC_LABELS.emptyPassword.rawValue))
        }
        else if !termsCheckBtn.isSelected {
            displayToast(STATIC_LABELS.termsCheckToast.rawValue)
        }
        else {
            let request = LoginRequest(email: email, password: password, device: AppModel.shared.device, fcmToken: getPushToken())
            LoginVM.userLogin(request: request)
            
        }
    }
    
    //MARK: - forgotPasswordBtnIsPressed
    @IBAction func forgotPasswordBtnIsPressed(_ sender: UIButton) {
        let vc: ForgotPasswordVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.ForgotPasswordVC.rawValue) as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - createAnAccountBtnIsPressed
    @IBAction func createAnAccountBtnIsPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        let vc: RegisterVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.RegisterVC.rawValue) as! RegisterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - continueAsGuestBtnIsPressed
    @IBAction func continueAsGuestBtnIsPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        AppModel.shared.isGuestUser = true
        AppDelegate().sharedDelegate().navigateToDashboard()
    }
    
    deinit {
        log.success("LoginVC Memory deallocated!")/
    }
}

extension LoginVC: LoginDelegate {
    func didRecieveLoginResponse(response: LoginResponse) {
        self.view.endEditing(true)
        UserDefaults.standard.setValue(response.data?.accessToken, forKey: USER_DEFAULT_KEYS.token.rawValue)
        UserDefaults.standard.set(encodable: response.data?.user, forKey: USER_DEFAULT_KEYS.currentUser.rawValue)
        AppModel.shared.currentUser = response.data?.user
        AppModel.shared.token = response.data?.accessToken ?? DocumentDefaultValues.Empty.string
        AppModel.shared.isGuestUser = false
        guard let profileCompleted = response.data?.user?.profileCompleted else { return }
        if profileCompleted {
            switch AppModel.shared.guestUserType {
            case .explore:
                let vc = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.ExploreVC.rawValue) as! ExploreVC
                if let visibleViewController = visibleViewController(){
                    visibleViewController.navigationController?.pushViewController(vc, animated: true)
                }
                break
            case .myBooking:
                let vc = STORYBOARD.BOOKING.instantiateViewController(withIdentifier: "MyBookingVC") as! MyBookingVC
                if let visibleViewController = visibleViewController(){
                    visibleViewController.navigationController?.pushViewController(vc, animated: true)
                }
                break
            case .notification:
                let vc = STORYBOARD.BOOKING.instantiateViewController(withIdentifier: NOTIFICATION_STORYBOARD.NotificationVC.rawValue) as! NotificationVC
                if let visibleViewController = visibleViewController(){
                    visibleViewController.navigationController?.pushViewController(vc, animated: true)
                }
                break
            case .profile:
                let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
                if let visibleViewController = visibleViewController(){
                    visibleViewController.navigationController?.pushViewController(vc, animated: true)
                }
                break
            case .eventDetails:
                let vc = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.EventDetailVC.rawValue) as! EventDetailVC
                if let visibleViewController = visibleViewController(){
                    visibleViewController.navigationController?.pushViewController(vc, animated: true)
                }
                break
            case .none:
                AppDelegate().sharedDelegate().navigateToDashboard()
            }
        }
        else {
            let vc: SetUpProfileVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.SetUpProfileVC.rawValue) as! SetUpProfileVC
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
