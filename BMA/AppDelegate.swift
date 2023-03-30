//
//  AppDelegate.swift
//  BMA
//
//  Created by Keyur on 28/06/21.
//

import UIKit
@_exported import SainiUtils
import NVActivityIndicatorView
import IQKeyboardManagerSwift
@_exported import GooglePlaces
import Firebase
import GoogleSignIn
import GoogleMaps
//import FBSDKCoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var customTabbarVc : CustomTabBarController!
    var activityLoader : NVActivityIndicatorView!
    private var appDetailVM: AppDetailViewModel = AppDetailViewModel()
    private var userDetailVM: UserDetailViewModel = UserDetailViewModel()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Thread.sleep(forTimeInterval: 4.0)
        //IQKeyboard
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
        
        //Firebase
        FirebaseApp.configure()
        // for facebookLogin
//        ApplicationDelegate.shared.application(
//            application,
//            didFinishLaunchingWithOptions: launchOptions
//        )
        
        //Google
        GIDSignIn.sharedInstance().clientID = GOOGLE.CLIENT_ID.rawValue
        GMSServices.provideAPIKey(GOOGLE.PLACE_KEY.rawValue)
        GMSPlacesClient.provideAPIKey(GOOGLE.PLACE_KEY.rawValue)
        
        getCategoryList()
        autoLogin()
        loadCountryCodes()
        
        appDetailVM.fetchDetails()
        registerPushNotification(application)
        
        appDetailVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.appDetailVM.success.value {
                AppModel.shared.appDetail = self.appDetailVM.appDetail.value
            }
        }
        
        userDetailVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.userDetailVM.success.value {
                UserDefaults.standard.set(encodable: self.userDetailVM.userDetail.value, forKey: USER_DEFAULT_KEYS.currentUser.rawValue)
                AppModel.shared.currentUser = self.userDetailVM.userDetail.value
            }
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

extension AppDelegate {
    //MARK:- Share Appdelegate
    func storyboard() -> UIStoryboard
    {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func sharedDelegate() -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    //MARK:- Tab bar
    func showTabBar() {
        if customTabbarVc != nil {
            customTabbarVc.setTabBarHidden(tabBarHidden: false)
        }
    }
    
    func hideTabBar() {
        if customTabbarVc != nil {
            customTabbarVc.setTabBarHidden(tabBarHidden: true)
        }
    }
    
    func showLoader()
    {
        removeLoader()
        DispatchQueue.main.async { [self] in
            self.window?.isUserInteractionEnabled = false
            self.activityLoader = NVActivityIndicatorView(frame: CGRect(x: ((self.window?.frame.size.width)!-50)/2, y: ((self.window?.frame.size.height)!-50)/2, width: 50, height: 50))
            self.activityLoader.type = .ballSpinFadeLoader
            self.activityLoader.color = AppColors.LoaderColor
            self.window?.addSubview(self.activityLoader)
            self.activityLoader.startAnimating()
        }
    }
    
    func removeLoader()
    {
        DispatchQueue.main.async { [self] in
            self.window?.isUserInteractionEnabled = true
            if self.activityLoader == nil {
                return
            }
            self.activityLoader.stopAnimating()
            self.activityLoader.removeFromSuperview()
            self.activityLoader = nil
        }
    }
    
    //MARK: - navigateToOnboarding
    func navigateToOnboarding() {
        let navigationVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "InfoVCNav") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = navigationVC
    }
    
    //MARK: - navigateToLogin
    func navigateToLogin() {
        let navigationVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVCNav") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = navigationVC
    }
    
    //MARK: - navigateToDashboard
    func navigateToDashboard() {
        customTabbarVc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "CustomTabBarController") as? CustomTabBarController
        let navigationController = UINavigationController(rootViewController: customTabbarVc)
        navigationController.navigationBar.isHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func continueToGuestLogin(isRootVC: Bool, headingName: String) {
        let vc : GuestLoginVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "GuestLoginVC") as! GuestLoginVC
        vc.isRootVC = isRootVC
        vc.headerName = headingName
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: false)
    }
    
    func continueToLogout() {
        KeychainItem.deleteUserIdentifierFromKeychain()
        removeUserDefaultValues()
        AppModel.shared.resetAllModel()
        AppModel.shared.guestUserType = .none
        AppModel.shared.fcmToken = getFCMToken()
        self.navigateToLogin()
        getCategoryList()
    }
    
    //MARK:- autoLogin
    private func autoLogin(){
        if UserDefaults.standard.value(forKey: USER_DEFAULT_KEYS.token.rawValue) as? String != "" {
            guard let token = UserDefaults.standard.value(forKey: USER_DEFAULT_KEYS.token.rawValue) as? String else{
                log.todo("No logged in user found yet")/
                AppModel.shared.isGuestUser = true
                //navigateToDashboard()
                return
            }
            
            if let savedPerson = UserDefaults.standard.object(forKey: USER_DEFAULT_KEYS.currentUser.rawValue) as? Data {
                let decoder = JSONDecoder()
                if let loadedPerson = try? decoder.decode(User.self, from: savedPerson) {
                    AppModel.shared.currentUser = loadedPerson
                }
                
                if token != ""{
                    //navigate to home Screen
                    AppModel.shared.token = token
                    
                    if AppModel.shared.currentUser.profileCompleted {
                        self.navigateToDashboard()
                    }
                    else{
                        let vc: SetUpProfileVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.SetUpProfileVC.rawValue) as! SetUpProfileVC
                        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                    }
                    userDetailVM.fetchUserDetails()
                }
            }
        }
        else{
            log.todo("No logged in user found yet")/
            AppModel.shared.isGuestUser = true
            // navigateToDashboard()
        }
    }
    
    //MARK:- loadCountryCodes
    private func loadCountryCodes(){
        if let url = Bundle.main.url(forResource: "countryCodes", withExtension: "json") {
            do {
                let data =  try Data(contentsOf: url)
                do {
                    let success = try JSONDecoder().decode([CountryCodeModel].self, from: data) // decode the response into success model
                    AppModel.shared.countryCodes = success
                    log.success("\(Log.stats()) Successfully parsed country code,name,countyname")/
                }
                catch let err {
                    log.error("\(Log.stats())\(err)")/
                }
            } catch let err{
                log.error("\(Log.stats())\(err)")/
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    //MARK:- Notification
    func registerPushNotification(_ application: UIApplication)
    {
        //       Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Notification registered")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    //Get Push Notification
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        //application.applicationIconBadgeNumber = Int((userInfo["aps"] as! [String : Any])["badge"] as! String)!
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        // handler for Push Notifications
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return true
    }
    
    func getFCMToken() -> String
    {
        let fcmToken = Messaging.messaging().fcmToken ?? ""
        log.info("FCM TOKEN========\(fcmToken)")/
        return fcmToken
    }
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        _ = notification.request.content.userInfo
        print(notification.request.content.userInfo)
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if UIApplication.shared.applicationState == .inactive
        {
            _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(delayForNotification(tempTimer:)), userInfo: userInfo, repeats: false)
        }
        else
        {
            print(userInfo)
            notificationHandler(userInfo as! [String : Any])
        }
        
        completionHandler()
    }
    
    @objc func delayForNotification(tempTimer:Timer)
    {
        notificationHandler(tempTimer.userInfo as! [String : Any])
    }
    
    //Redirect to screen
    func notificationHandler(_ dict : [String : Any])
    {
        print(dict)
        guard let notificationType = dict["gcm.notification.type"] as? String else { return }
        if let payload = dict["gcm.notification.payload"]{
            let payliadDict : [String : Any] = convertToDictionary(text: payload as! String) ?? [String : Any]()
            if let userDict = payliadDict["user"] as? [String: Any]{
                guard let userId : String = userDict["_id"] as? String else { return }
                guard let additionalId : String = payliadDict["additionalRef"] as? String else { return }
                let pushNotification: NOTIFICATION_TYPE = NOTIFICATION_TYPE(rawValue: Int(notificationType) ?? 0) ?? .ADMIN
                if pushNotification == .ADMIN {
                    return
                } else {
                    let vc = STORYBOARD.BOOKING.instantiateViewController(withIdentifier: "BookingDetailsVC") as! BookingDetailsVC
                    vc.eventRef = additionalId
                    vc.userRef = userId
                    if let visibleViewController = visibleViewController(){
                        visibleViewController.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
}

//MARK:- API Manager
extension AppDelegate {
    func getCategoryList() {
        var CategorylistVM : CategoryViewModel = CategoryViewModel()
        CategorylistVM.delegate = self
        CategorylistVM.getCategoryList(request: CategoryRequest(page: 1, limit: 100))
    }
}

extension AppDelegate: CategoryViewDelegate {
    func didRecieveCategoryListResponse(response: CategoryListResponse) {
        setCategoryListData(response.data)
        
    }
}
