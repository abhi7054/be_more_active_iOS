//
//  CreateEvent_TwoVC.swift
//  BMA
//
//  Created by MACBOOK on 01/07/21.
//

import UIKit
import SainiUtils

class CreateEvent_TwoVC: UIViewController {
    
    private var startDate: String = String()
    private var selectedStartTime: String = String()
    private var selectedEndTime: String = String()
    var addEventRequest: AddEventRequest?
    private var isReviewOn: Bool = Bool()
    private var isCoupenOn: Bool = Bool()
    private var firstDate: Date?
    private var startTime: Date = Date()
    private let calendar = Calendar.current
    private var day: Int = Int()
    private var month: Int = Int()
    private var year: Int = Int()
    
    var calendarEventsVM: CalendarEventsViewModel = CalendarEventsViewModel()
    var eventDetailVM: EventDetailViewModel = EventDetailViewModel()
    var eventListVM: EventsLeaguesViewModel?
    var userFrom: USER_FROM = .login
    
    // OUTLETS
    @IBOutlet weak var couponStackView: UIStackView!
    @IBOutlet weak var couponDescriptionTextfield: UITextField!
    @IBOutlet weak var couponCodeTextfield: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var couponOffBtn: UIButton!
    @IBOutlet weak var couponOnBtn: UIButton!
    @IBOutlet weak var noReviewBtn: UIButton!
    @IBOutlet weak var yesReviewBtn: UIButton!
    @IBOutlet weak var webUrlTextfield: UITextField!
    @IBOutlet weak var fbUrlTextfield: UITextField!
    @IBOutlet weak var instaUrlTextfield: UITextField!
    @IBOutlet weak var phoneNumberTextfield: UITextField!
    @IBOutlet weak var phoneCodeLbl: UILabel!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var endEventTimeLbl: UILabel!
    @IBOutlet weak var endEventTimeView: UIView!
    @IBOutlet weak var startEventTimeLbl: UILabel!
    @IBOutlet weak var startEventTimeView: UIView!
    @IBOutlet weak var eventDateLbl: UILabel!
    @IBOutlet weak var eventDateView: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configUI()
        
    }
    
    //MARK: - configUI
    private func configUI() {
        eventDateView.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1), borderWidth: 1, cornerRadius: 5)
        startEventTimeView.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1), borderWidth: 1, cornerRadius: 5)
        endEventTimeView.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1), borderWidth: 1, cornerRadius: 5)
        phoneNumberView.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1), borderWidth: 1, cornerRadius: 5)
        nextBtn.sainiCornerRadius(radius: 10)
        noReviewBtn.isSelected = true
        couponOffBtn.isSelected = true
        couponStackView.isHidden = true
        
        switch userFrom {
        case .login:
            headerLbl.text = STATIC_LABELS.createEvent.rawValue
        case .explore:
            headerLbl.text = STATIC_LABELS.createEvent.rawValue
        case .eventDetail:
            headerLbl.text = STATIC_LABELS.editEvent.rawValue
            renderData(data: eventDetailVM.eventDetail.value)
        case .calendar:
            headerLbl.text = STATIC_LABELS.createEvent.rawValue
        case .profile:
            headerLbl.text = STATIC_LABELS.createEvent.rawValue
        }
    }
    
    //MARK: - renderData
    private func renderData(data: EventDetail) {
        let startDateOfEvent = getDateStringFromDateString(strDate: data.startDate, format: DATE_FORMATS.yyyyMMMdd.rawValue)
        eventDateLbl.text = startDateOfEvent
        self.startDate = data.startDate
        let startTime = getDateStringFromDateString(strDate: data.startTime, format: DATE_FORMATS.time.rawValue)
        firstDate = getDateFromDateString(strDate: data.startDate)
        let endTime = getDateStringFromDateString(strDate: data.endTime, format: DATE_FORMATS.time.rawValue)
        self.selectedStartTime = data.startTime
        self.selectedEndTime = data.endTime
        startEventTimeLbl.text = startTime
        endEventTimeLbl.text = endTime
        phoneCodeLbl.text = data.contactDetails.phonecode
        phoneNumberTextfield.text = data.contactDetails.phoneNumber
        emailTextfield.text = data.contactDetails.email
        instaUrlTextfield.text = data.instagramURL
        fbUrlTextfield.text = data.facebookURL
        webUrlTextfield.text = data.websiteURL
        isCoupenOn = data.coupons
        if isCoupenOn {
            couponOnBtn.isSelected = true
            couponOffBtn.isSelected = false
            couponStackView.isHidden = false
            couponCodeTextfield.text = data.couponCode
            couponDescriptionTextfield.text = data.couponDescription
        }
        else {
            couponOnBtn.isSelected = false
            couponOffBtn.isSelected = true
            couponStackView.isHidden = true
        }
        isReviewOn = data.reviews
        if isReviewOn {
            yesReviewBtn.isSelected = true
            noReviewBtn.isSelected = false
        }
        else {
            yesReviewBtn.isSelected = false
            noReviewBtn.isSelected = true
        }
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - selectEventDateBtnIsPressed
    @IBAction func selectEventDateBtnIsPressed(_ sender: UIButton) {
        showDatePicker(title: "", selected: Date(), minDate: Date(), maxDate: nil) { (date) in
            let selectedDate = getDateStringFromDate(date: date, format: DATE_FORMATS.yyyyMMMdd.rawValue)
            self.day = self.calendar.component(.day, from: date)
            self.month = self.calendar.component(.month, from: date)
            self.year = self.calendar.component(.year, from: date)
            let dateComponents = DateComponents(calendar: self.calendar,
                                                year: self.year,
                                                month: self.month,
                                                day: self.day, hour: 12, minute: 0, second: 0)
            let finalDate = self.calendar.date(from: dateComponents)!
            self.startDate = getDateStringFromDate(date: finalDate, format: DATE_FORMATS.utcFormat.rawValue)
            self.eventDateLbl.text = selectedDate
            self.firstDate = date
        } completionClose: {
        }
        
    }
    
    //MARK: - selectStartTimeOfEventIsPressed
    @IBAction func selectStartTimeOfEventIsPressed(_ sender: UIButton) {
        showTimePicker(title: "", selected: Date()) { (time) in
            let selectedTime = time.dateString(DATE_FORMATS.time.rawValue)
            self.startTime = time
            self.startEventTimeLbl.text = selectedTime
            self.selectedStartTime = getDateStringFromDate(date: time, format: DATE_FORMATS.utcFormat.rawValue)
        } completionClose: {
        }
        
    }
    
    //MARK: - endTimeOfEventIsPressed
    @IBAction func endTimeOfEventIsPressed(_ sender: UIButton) {
        showTimePicker(title: "", selected: self.startTime) { (time) in
            if time < self.startTime {
                displayToast(STATIC_LABELS.timeToast.rawValue)
                return
            }
            let selectedTime = time.dateString(DATE_FORMATS.time.rawValue)
            self.endEventTimeLbl.text = selectedTime
            self.selectedEndTime = getDateStringFromDate(date: time, format: DATE_FORMATS.utcFormat.rawValue)
        } completionClose: {
        }
    }
    
    //MARK: - selectPhoneCodeBtnIsPressed
    @IBAction func selectPhoneCodeBtnIsPressed(_ sender: UIButton) {
        let countryCodeArr = AppModel.shared.countryCodes.map({ (country: CountryCodeModel) -> String in
            country.dial_code
        })
        PickerManager.shared.showPicker(title: "Select PhoneCode", selected: "91", strings: countryCodeArr) { [weak self](country, index, success) in
            if country != nil {
                self?.phoneCodeLbl.text = (country ?? "0")
            }
            self?.view.endEditing(true)
        }
    }
    
    //MARK: - selectReviewOnOffIsPressed
    @IBAction func selectReviewOnOffIsPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            isReviewOn = true
            yesReviewBtn.isSelected = true
            noReviewBtn.isSelected = false
        }
        else if sender.tag == 1 {
            isReviewOn = false
            yesReviewBtn.isSelected = false
            noReviewBtn.isSelected = true
        }
        else {
            isReviewOn = false
            yesReviewBtn.isSelected = false
            noReviewBtn.isSelected = false
        }
    }
    
    //MARK: - selectCouponOnOffBtnIsPressed
    @IBAction func selectCouponOnOffBtnIsPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            isCoupenOn = true
            couponOnBtn.isSelected = true
            couponOffBtn.isSelected = false
            couponStackView.isHidden = false
        }
        else if sender.tag == 1 {
            isCoupenOn = false
            couponStackView.isHidden = true
            couponOnBtn.isSelected = false
            couponOffBtn.isSelected = true
        }
        else {
            isCoupenOn = false
            couponStackView.isHidden = true
            couponOnBtn.isSelected = false
            couponOffBtn.isSelected = false
        }
    }
    
    //MARK: - nextBtnIsPressed
    @IBAction func nextBtnIsPressed(_ sender: UIButton) {
//        guard let phoneCode = phoneCodeLbl.text else { return }
        guard let phoneNumber = phoneNumberTextfield.text else { return }
        guard let email = emailTextfield.text else { return }
        guard let instaUrl = instaUrlTextfield.text else { return }
        guard let fbUrl = fbUrlTextfield.text else { return }
        guard let webUrl = webUrlTextfield.text else { return }
        guard let couponCode = couponCodeTextfield.text else { return }
        guard let couponDes = couponDescriptionTextfield.text else { return }
        if startDate == DocumentDefaultValues.Empty.string {
            displayToast(STATIC_LABELS.emptyStartDate.rawValue)
        }
        else if selectedStartTime == DocumentDefaultValues.Empty.string {
            displayToast(STATIC_LABELS.emptyStartTime.rawValue)
        }
        else if selectedEndTime == DocumentDefaultValues.Empty.string {
            displayToast(STATIC_LABELS.emptyEndTime.rawValue)
        }
//        else if phoneCode == DocumentDefaultValues.Empty.string {
//            displayToast(STATIC_LABELS.emptyPhoneCode.rawValue)
//        }
        else if phoneNumber == DocumentDefaultValues.Empty.string {
            displayToast(STATIC_LABELS.emptyPhoneNumber.rawValue)
        }
        else if email == DocumentDefaultValues.Empty.string {
            displayToast(STATIC_LABELS.emptyEmail.rawValue)
        }
        else if !email.isValidEmail {
            displayToast(STATIC_LABELS.notValidEmail.rawValue)
        }
        else if webUrl != DocumentDefaultValues.Empty.string {
            displayToast("Enter a valid sign up URL")
        }
        else if instaUrl != DocumentDefaultValues.Empty.string && !instaUrl.isValidUrl{         displayToast(STATIC_LABELS.notValidInstaUrl.rawValue)
        }
        else if fbUrl != DocumentDefaultValues.Empty.string && !fbUrl.isValidUrl{
            displayToast(STATIC_LABELS.notValidFbUrl.rawValue)
        }
        else if webUrl != DocumentDefaultValues.Empty.string && !webUrl.isValidUrl{
            displayToast(STATIC_LABELS.notValidWebUrl.rawValue)
        }
        else if !noReviewBtn.isSelected && !yesReviewBtn.isSelected {
            displayToast(STATIC_LABELS.emptyTurnReview.rawValue)
        }
        else if couponOnBtn.isSelected && couponCode.isEmpty {
            displayToast(STATIC_LABELS.emptyCouponCode.rawValue)
        }
        else if couponOnBtn.isSelected && couponDes.isEmpty {
            displayToast(STATIC_LABELS.emptyCouponDescription.rawValue)
        }
        else {
            self.addEventRequest?.startDate = startDate
            self.addEventRequest?.startTime = selectedStartTime
            self.addEventRequest?.endTime = selectedEndTime
            self.addEventRequest?.reviews = isReviewOn
            self.addEventRequest?.coupons = isCoupenOn
//            self.addEventRequest?.phonecode = phoneCode
            self.addEventRequest?.phoneNumber = phoneNumber
            self.addEventRequest?.eventEmail = email
            self.addEventRequest?.instagramUrl = instaUrl
            self.addEventRequest?.facebookUrl = fbUrl
            self.addEventRequest?.websiteUrl = webUrl
            self.addEventRequest?.couponCode = couponCode
            self.addEventRequest?.couponDescription = couponDes
            
            let vc: CreateEvent_ThreeVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.CreateEvent_ThreeVC.rawValue) as! CreateEvent_ThreeVC
            vc.addEventRequest = self.addEventRequest
            vc.firstDate = firstDate
            vc.userFrom = userFrom
            vc.eventDetailVM = eventDetailVM
            vc.eventListVM = self.eventListVM
            vc.calendarEventsVM = self.calendarEventsVM
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    deinit {
        log.success("CreateEvent_TwoVC Memory deallocated!")/
    }
}
