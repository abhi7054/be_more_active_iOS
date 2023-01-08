//
//  AppEnums.swift
//  TBC
//
//  Created by MACBOOK on 12/05/21.
//  Copyright © 2021 iMac. All rights reserved.
//

import Foundation

//MARK: - IAPProduct
enum IAPProduct: String {
    case essential = "BMA.Essential"
    case team = "BMA.Team"
    case corporate = "BMA.corporate"
    case enterprise = "BMA.Enterprise"
}

//MARK: - TABLE_VIEW_CELL
enum TABLE_VIEW_CELL: String {
    case SelectActivityCell, SubscriptionFeatureCell, MyBookingTVC, NotificationTVC, ProfileTVC, SelectActivityTVC, EventsLeaguesTVC, MySubscriptionTVC, MyCouponTVC, SettingsTVC, MembersJoinedCell, RatingListCell, CustomQuestionTVC, CategorySectionTVC
}

//MARK: - TABLE_VIEW_CELL
enum COLLECTION_VIEW_CELL: String {
    case OnboardingCVC, SubscriptionHeaderCVC, ImageCVC
}

//MARK: - MAIN_STORYBOARD
enum MAIN_STORYBOARD: String {
    case OnboadingVC, LoginVC, RegisterVC, ForgotPasswordVC, SetUpProfileVC, CreateEvent_OneVC, CreateEvent_TwoVC, CreateEvent_ThreeVC, SubscriptionVC, SelectCategoryVC, SelectActivityVC
}

//MARK: - EXPLORE_STORYBOARD
enum EXPLORE_STORYBOARD: String {
    case ExploreVC, SearchVC, EventDetailVC, DetailsVC, MembersJoinedVC, FilterVC, ReportVC, RatingListVC, AddRatingVC, ExploreMapVC, ExploreCalendarVC, CalendarListVC
}

//MARK: - MY_BOOKING_STORYBOARD
enum MY_BOOKING_STORYBOARD: String {
    case MyBookingVC
}

//MARK: - NOTIFICATION_STORYBOARD
enum NOTIFICATION_STORYBOARD: String {
    case NotificationVC
}

//MARK: - PROFILE_STORYBOARD
enum PROFILE_STORYBOARD: String {
    case ProfileVC
}

enum APP_FONT: String {
    case regular = "Poppins-Regular"
}

//MARK: - STATIC_LABELS
enum STATIC_LABELS: String {
    case noDataFound = "No Data Found."
    case image = "image"
    case usCode = "+1"
    
    // Button Labels
    case cancel = "Cancel"
    case delete = "Delete"
    case edit = "Edit"
    case report = "Report this event"
    case yesBtn = "Yes"
    case okBtn = "Ok"
    case noBtn = "No"
    case subscribeNow = "Subscribe now"
    case favourite = "Favorite"
    case unFavourite = "Unfavorite"
    case saveBtn = "Save"
    case createBtn = "Create"
    
    // headings
    case createEvent = "Create event/league"
    case editEvent = "Edit event/league"
    case couponDetail = "Coupon details"
    case contactDetail = "Contact details"
    case reportTextViewPlaceholder = "Write briefly about your reason."
    case reviewPlaceholder = "Share details of your own experience."
    case contactAdminPlaceholder = "How can we help?"
    
    // toasts
    case emptySearch = "There were no results found with this keyword. Try searching with a different keyword."
    case noImageAdded = "Kindly add Images"
    case emptyName = "Kindly enter name of the Event"
    case emptyDescription = "Kindly add description to event"
    case emptyLocation = "Kindly select Location for event"
    case emptyCategory = "Kindly select category for event"
    case emptyCategoryActivity = "Kindly select category and activity"
    case emptyActivity = "Kindly select activity for event"
    case emptyStartDate = "Kindly select date of event"
    case emptyStartTime = "Kindly select start time of event"
    case emptyEndTime = "Kindly select end time of event"
    case emptyPhoneCode = "Kindly select your phone code"
    case emptyPhoneNumber = "Kindly select your phone number"
    case emptyseats = "Kindly add required members"
    case emptyEmail = "Kindly add your email"
    case notValidEmail = "Kindly enter a valid email"
    case notValidInstaUrl = "Kindly enter a valid instagram Url"
    case notValidFbUrl = "Kindly enter a valid facebook Url"
    case notValidWebUrl = "Kindly enter a valid website link"
    case emptyCouponCode = "Kindly enter coupon code"
    case emptyCouponDescription = "Kindly enter coupon description"
    case emptyTurnReview = "Kindly select Yes or No for Reviews"
    case unfavToast = "Unmarked Favourite Successfully"
    case favToast = "Marked Favourite Successfully"
    case emptyStarToast = "Kindly add stars to add your rating"
    case emptyReview = "Kindly add your review"
    case descriptionLimitToast = "You can add 300 characters only."
    case emptyLocPlaceholder = "Select Location"
    case timeToast = "end time should be geater than start time"
    case emptyDescriptionPlaceholder = "Description of the event"
    case emptyPassword = "Kindly enter your password"
    case emptyConfirmPassword = "Kindly confirm your password"
    case passwordNotMatch = "Password does not match"
    case emptyUserName = "Kindly enter your name"
    case emptyQuery = "Kindly enter your query"
    case contactAdminSuccessToast = "Your query has been submitted!"
    case dateCompareToast = "To date should be smaller than from date."
    case termsCheckToast = "Kindly accept to the terms and conditions."
    case maxCategoryToast = "You can select maximum 4 categories"
    case maxActivityToast = "You can select maximum 5 activities"
    
    // report popUp
    case emptyReportToast = "Kindly enter reason to report"
    case reportPopUpHeading = "Event reported"
    case reportPopUpMsg = "Thank You for reporting. Our team will look back to it soon."
    
    // event booked popUp
    case eventBookPopUpHeading = "Event booked"
    case eventBookPopUpMsg = "Thank you for joining with us. Your event has been booked successfully."
    
    // event deleted popUp
    case eventDeletePopUpHeading = "Delete Event"
    case eventDeletePopUpMsg = "Hey, Are you sure you want to delete this event."
    
    // review submitted popUp
    case reviewPopUpHeading = "Review submitted"
    case reviewPopUpMsg = "Thank you for submitting your reviews for this event."
    
    // event create popup
    case eventCreatePopUpHeading = "Create event"
    case eventCreatePopUpMsg = "Hey, if you want to post events or leagues, you have to purchase a subscription."
    
    // registerPopUp
    case registerPopUpMsg = "An email with verification link is sent to your email account. Please verify to login."
    
    //forgotPasswordPopUp
    case forgotPasswordPopUpMsg = "A Link to Reset your password has been sent to your registered email account."
    
    // cancel subscription popUpMsg
    case subscriptionPopUpMsg = "You have to cancel the subsciption manually from your Apple Account."
}

//MARK: - USER_DEFAULT_KEYS
enum USER_DEFAULT_KEYS: String {
    case currentUser, userLocation, token
}

//MARK: - GLOBAL_IMAGES
enum GLOBAL_IMAGES: String {
    case uploadPlaceholder = "ic_upload_image"
    case profilePlaceHolder = "image"
    case eventPlaceHolder = "ic_signup_image-upload"
    case openDropDown = "ic_dropdown_open"
    case closeDropDown = "ic_dropdown_closed"
    case adminImage = "ic_admin_img"
}

//MARK: - DATE_FORMATS
enum DATE_FORMATS: String {
    case ddMMMyyyy = "dd-MMM-yyyy"
    case yyyyMMMdd = "yyyy-MMM-dd"
    case time = "hh:mm a"
    case utcFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    case mmmm = "MMMM"
    case HHmm = "HH:mm"
    case year = "yyyy"
    case format1 = "dd MMM, yyyy EEEE"
}

//MARK: - GuestUserType
enum GuestUserType:Int {
    case explore = 1
    case myBooking = 2
    case notification = 3
    case profile = 4
    case eventDetails = 5
    case none = 6
}

//MARK: - NOTIFICATION_NAME
enum NOTIFICATION_NAME: String {
    case redirectTabBar = "REDICT_TAB_BAR"
    case updateCategory = "UPDATE_CATEGORY_ACTIVITY"
}

//MARK: - ONBOARDING_BG_IMAGES
enum ONBOARDING_BG_IMAGES: String, CaseIterable {
    case onboarding1 = "Onboarding-1"
    case onboarding2 = "Onboarding-2"
    case onboarding3 = "Onboarding-3"
}

//MARK: - ONBOARDING_IMAGES
enum ONBOARDING_IMAGES: String, CaseIterable {
    case onboarding1 = "ic_find_sports"
    case onboarding2 = "ic_event_review"
    case onboarding3 = "ic_create_event"
}

//MARK: - ONBOARDING_TEXT
enum ONBOARDING_TEXT: String, CaseIterable {
    case onboarding1 = "Find nearby sports events & leagues."
    case onboarding2 = "See & add reviews of events & leagues."
    case onboarding3 = "Create your own event & add coupons for users."
}

//MARK: - SELECTED_SUB
enum SELECTED_SUB {
    case monthly, threeMonth, sixMonth, annually
}

//MARK: - SUBSCRIPTION_PRICE
enum SUBSCRIPTION_PRICE: String {
    case monthly = "$24.99/month"
    case threeMonth = "$49.99"
    case sixMonth = "$79.99"
    case annually = "$149.99"
}

//MARK: - SUBSCRIPTION_TYPE
enum SUBSCRIPTION_TYPE: String {
    case monthly = "Essential"
    case threeMonth = "Team"
    case sixMonth = "Corporate"
    case annually = "Enterprise"
}

//MARK: - SUBSCRIPTION
enum SUBSCRIPTION: Int, Encodable {
    case monthly = 1
    case threeMonth = 2
    case sixMonth = 3
    case annually = 4
}

//MARK: - SUBSCRIPTION_TYPE
enum SUBSCRIPTION_DURATION: String {
    case monthly = "(Month to Month)"
    case threeMonth = "( 3 months )"
    case sixMonth = "( 6 months )"
    case annually = "(Annually)"
}


//MARK: - FEATURES_FOR_MONTHLY_SUBSCRIPTION
enum FEATURES_FOR_MONTHLY_SUBSCRIPTION: String, CaseIterable {
    case feature1 = "Prompt client to post reviews"
    case feature2 = "List your business and services"
    case feature3 = "Send Push notifications"
    case feature4 = "Reach the right audience with clients search"
    case feature5 = "Access to calendar"
}

//MARK: - FEATURES_FOR_THREE_MONTH_SUBSCRIPTION
enum FEATURES_FOR_THREE_MONTH_SUBSCRIPTION: String, CaseIterable {
    case feature1 = "7 days risk free trial"
    case feature2 = "Send clients Discount codes"
    case feature3 = "Prompt client to post reviews"
    case feature4 = "List your business and services"
    case feature5 = "Send Push notifications"
    case feature6 = "Reach the right audience with clients search"
    case feature7 = "Access to calendar"
}

//MARK: - FEATURES_FOR_SIX_MONTH_SUBSCRIPTION
enum FEATURES_FOR_SIX_MONTH_SUBSCRIPTION: String, CaseIterable {
    case feature1 = "7 days risk free trial"
    case feature2 = "Send clients Discount codes"
    case feature3 = "Prompt client to post reviews"
    case feature4 = "List your business and services"
    case feature5 = "Send Push notifications"
    case feature6 = "Reach the right audience with clients search"
    case feature7 = "Access to calendar"
}

//MARK: - FEATURES_FOR_ANNUAL_SUBSCRIPTION
enum FEATURES_FOR_ANNUAL_SUBSCRIPTION: String, CaseIterable {
    case feature1 = "7 days risk free trial"
    case feature2 = "Send clients Discount codes"
    case feature3 = "Prompt client to post reviews"
    case feature4 = "List your business and services"
    case feature5 = "Send Push notifications"
    case feature6 = "Reach the right audience with clients search"
    case feature7 = "Access to calendar"
}

//MARK: - DETAIL_TYPE
enum DETAIL_TYPE {
    case contact, coupon
}

//MARK: - EVENT_TYPE
enum EVENT_TYPE: Int, Encodable {
    case weekly = 1
    case monthly = 2
}

//MARK: - USER_FROM
enum USER_FROM {
    case login, explore, eventDetail, calendar, profile
}

//MARK: - BOOKING_STATUS
enum BOOKING_STATUS: Int, Encodable {
    case UPCOMING_ONGOING = 5
    case PAST_CANCELLED = 6
    case ONGOING = 1
    case UPCOMING = 2
    case CANCELLED = 3
    case COMPLETED = 4
}

enum USER_PROFILE_OPTIONS:String, CaseIterable {
    case OPTIONS1 = "Events/leagues posted" //"Uploaded photos"
    case OPTIONS2 = "My favorites" //"Favorite clubs"
    case OPTIONS3 = "My subscription" //"Favorite drinks"
    case OPTIONS4 = "My coupons" //"Manage cards"
    case OPTIONS5 = "Settings" //"My transactions"
    
    static var list: [String] {
        return USER_PROFILE_OPTIONS.allCases.map { $0.rawValue }
    }
    
    func localizedString() -> String {
      return NSLocalizedString(self.rawValue, comment: "")
    }
}

enum USER_PROFILE_OPTION_IMG:String, CaseIterable {
    case OPTION_IMG1 = "ic_calendar"
    case OPTION_IMG2 = "ic_myfavorities"
    case OPTION_IMG3 = "ic_mysubscription"
    case OPTION_IMG4 = "ic_mycoupon"
    case OPTION_IMG5 = "ic_settings"
    
    static var list: [String] {
      return USER_PROFILE_OPTION_IMG.allCases.map { $0.rawValue }
    }
    
    func localizedString() -> String {
      return NSLocalizedString(self.rawValue, comment: "")
    }
}

enum SELECT_ACTIVITY_BTN: String, CaseIterable {
    case ACTIVITY1 = "Sports league"
    case ACTIVITY2 = "Sports match"
    case ACTIVITY3 = "Football playship"
    case ACTIVITY4 = "Volleyball players"
    case ACTIVITY5 = "Cricket league"
    case ACTIVITY6 = "Basketball league"
    case ACTIVITY7 = "Chess league"
    case ACTIVITY8 = "Indoor tennis"
    
    
    static var list: [String] {
      return SELECT_ACTIVITY_BTN.allCases.map { $0.rawValue }
    }
    
    func localizedString() -> String {
      return NSLocalizedString(self.rawValue, comment: "")
    }
}

enum SUBSCRIBE_DETAILS: String, CaseIterable {
    case ACTIVITY1 = "Prompt client to post reviews"
    case ACTIVITY2 = "List you business and services"
    case ACTIVITY3 = "Send Push notifications"
    case ACTIVITY4 = "Reach the right audience with clients search"
    case ACTIVITY5 = "Access to calendar"

    
    
    static var list: [String] {
      return SUBSCRIBE_DETAILS.allCases.map { $0.rawValue }
    }
    
    func localizedString() -> String {
      return NSLocalizedString(self.rawValue, comment: "")
    }
}

enum SETTING_OPTION_TITLE: String, CaseIterable {
    case ACTIVITY1 = "Share app with friends"
    case ACTIVITY2 = "About us"
    case ACTIVITY3 = "Terms & conditions"
    case ACTIVITY4 = "Privacy policy"
    case ACTIVITY5 = "Contact admin"
    case ACTIVITY6 = "FAQs"
    case ACTIVITY7 = "Logout"
    
    static var list: [String] {
      return SETTING_OPTION_TITLE.allCases.map { $0.rawValue }
    }
    
    func localizedString() -> String {
      return NSLocalizedString(self.rawValue, comment: "")
    }
}

enum SETTING_OPTION_IMG: String, CaseIterable {
    case ACTIVITY1 = "ic_share"
    case ACTIVITY2 = "ic_aboutus"
    case ACTIVITY3 = "ic_terms&conditions"
    case ACTIVITY4 = "ic_privacy_policy"
    case ACTIVITY5 = "ic_contact_admin"
    case ACTIVITY6 = "ic_faq"
    case ACTIVITY7 = "ic_logout"
    
    static var list: [String] {
      return SETTING_OPTION_IMG.allCases.map { $0.rawValue }
    }
    
    func localizedString() -> String {
      return NSLocalizedString(self.rawValue, comment: "")
    }
}

enum SETUP_ABOUT_REDIRECTION: String {
    case ABOUT_US = "About_us" //"About Us"
    case TERMS_CONDITION = "Terms_conditions" //"Terms and Conditions"
    case PRIVACY_POLICY = "Privacy_policy" //"Privacy Policy"
}

enum VALUE: Int{
    case NONE = -1
    case ZERO = 0
    case ONE = 1
    case TWO = 2
    func getValue() ->Int{
        return self.rawValue
    }
}

enum BOOKING_TYPE:Int{
    case UPCOMING = 1
    case PAST = 2
    func getValue() ->Int{
        return self.rawValue
    }
}

enum NOTIFICATION_TYPE:Int, Encodable{
    case ADMIN = 1
    case ADD_BOOKING = 2
    case CANCEL_BOOKING = 3
    func getValue() ->Int{
        return self.rawValue
    }
}
