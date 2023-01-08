//
//  BookingFilterVC.swift
//  BMA
//
//  Created by iMac on 01/07/21.
//

import UIKit

protocol ApplyBookingFilterDelegate {
    func filterEvents(request: MyBookingListRequest)
}

class BookingFilterVC: UIViewController {
    
    var filterDelegate: ApplyBookingFilterDelegate?
    var isUpcoming: Bool = false
    private var fromDate: String = String()
    private var toDate: String = String()
    private let calendar = Calendar.current
    private var day: Int = Int()
    private var month: Int = Int()
    private var year: Int = Int()
    private var selectedFromDate: Date = Date()
    private var selectedToDate: Date = Date()
    
    @IBOutlet weak var fromDateView: UIView!
    @IBOutlet weak var toDateView: UIView!
    @IBOutlet weak var fromDateTxt: UITextField!
    @IBOutlet weak var toDateTxt: UITextField!
    @IBOutlet weak var onGoingBtn: UIButton!
    @IBOutlet weak var upComingBtn: UIButton!
    @IBOutlet weak var cancelledBtn: UIButton!
    @IBOutlet weak var completedBtn: UIButton!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var upcomingStatusView: UIView!
    @IBOutlet weak var pastStatusView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    func configUI() {
        
        if isUpcoming{  // 1st tab is selected
            pastStatusView.isHidden = true
        }else{  //  2nd tab is selected
            upcomingStatusView.isHidden = true
        }
        applyBtn.sainiCornerRadius(radius: 10)
        fromDateView.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), borderWidth: 1, cornerRadius: 5)
        toDateView.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), borderWidth: 1, cornerRadius: 5)
    }
    
    //MAR: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate().sharedDelegate().hideTabBar()
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSelectDate(_ sender: UIButton) {
        if sender.tag == 1 {    // fromDate
            if isUpcoming {
                showDatePicker(title: "", selected: Date(), minDate: Date(), maxDate: nil) { (date) in
                    let selectedDate = getDateStringFromDate(date: date, format: DATE_FORMATS.ddMMMyyyy.rawValue)
                    self.fromDateTxt.text = selectedDate
                    self.day = self.calendar.component(.day, from: date)
                    self.month = self.calendar.component(.month, from: date)
                    self.year = self.calendar.component(.year, from: date)
                    let dateComponents = DateComponents(calendar: self.calendar,
                                                        year: self.year,
                                                        month: self.month,
                                                        day: self.day, hour: 12, minute: 0, second: 0)
                    let finalDate = self.calendar.date(from: dateComponents)!
                    self.selectedFromDate = finalDate
                    self.fromDate = getDateStringFromDate(date: finalDate, format: DATE_FORMATS.utcFormat.rawValue)
                } completionClose: {
                }
            }
            else {
                showDatePicker(title: "", selected: Date(), minDate: nil, maxDate: Date()) { (date) in
                    let selectedDate = getDateStringFromDate(date: date, format: DATE_FORMATS.ddMMMyyyy.rawValue)
                    self.fromDateTxt.text = selectedDate
                    self.day = self.calendar.component(.day, from: date)
                    self.month = self.calendar.component(.month, from: date)
                    self.year = self.calendar.component(.year, from: date)
                    let dateComponents = DateComponents(calendar: self.calendar,
                                                        year: self.year,
                                                        month: self.month,
                                                        day: self.day, hour: 12, minute: 0, second: 0)
                    let finalDate = self.calendar.date(from: dateComponents)!
                    self.selectedFromDate = finalDate
                    self.fromDate = getDateStringFromDate(date: finalDate, format: DATE_FORMATS.utcFormat.rawValue)
                } completionClose: {
                }
            }
            
        }
        else if sender.tag == 2 {   // toDate
            if isUpcoming {
                showDatePicker(title: "", selected: Date(), minDate: Date(), maxDate: nil) { (date) in
                    let selectedDate = getDateStringFromDate(date: date, format: DATE_FORMATS.ddMMMyyyy.rawValue)
                    self.toDateTxt.text = selectedDate
                    self.day = self.calendar.component(.day, from: date)
                    self.month = self.calendar.component(.month, from: date)
                    self.year = self.calendar.component(.year, from: date)
                    let dateComponents = DateComponents(calendar: self.calendar,
                                                        year: self.year,
                                                        month: self.month,
                                                        day: self.day, hour: 23, minute: 59, second: 59)
                    let finalDate = self.calendar.date(from: dateComponents)!
                    self.selectedToDate = finalDate
                    self.toDate = getDateStringFromDate(date: finalDate, format: DATE_FORMATS.utcFormat.rawValue)
                } completionClose: {
                }
            }
            else {
                showDatePicker(title: "", selected: Date(), minDate: nil, maxDate: Date()) { (date) in
                    let selectedDate = getDateStringFromDate(date: date, format: DATE_FORMATS.ddMMMyyyy.rawValue)
                    self.toDateTxt.text = selectedDate
                    self.day = self.calendar.component(.day, from: date)
                    self.month = self.calendar.component(.month, from: date)
                    self.year = self.calendar.component(.year, from: date)
                    let dateComponents = DateComponents(calendar: self.calendar,
                                                        year: self.year,
                                                        month: self.month,
                                                        day: self.day, hour: 23, minute: 59, second: 59)
                    let finalDate = self.calendar.date(from: dateComponents)!
                    self.selectedToDate = finalDate
                    self.toDate = getDateStringFromDate(date: finalDate, format: DATE_FORMATS.utcFormat.rawValue)
                } completionClose: {
                }
            }
            
        }
    }
    
    @IBAction func clickToOnGoingUpcoming(_ sender: UIButton) {
        onGoingBtn.isSelected = false
        upComingBtn.isSelected = false
        sender.isSelected = true
    }
    
    @IBAction func clickToCancelCompleted(_ sender: UIButton) {
        cancelledBtn.isSelected = false
        completedBtn.isSelected = false
        sender.isSelected = true
    }
    
    @IBAction func applyFilterBtnIsPressed(_ sender: UIButton) {
        if fromDate.isEmpty && !toDate.isEmpty {
            displayToast("Kindly add from data")
        }
        else if !fromDate.isEmpty && toDate.isEmpty {
            displayToast("Kindly add to data")
        }
        else if selectedToDate < selectedFromDate {
            displayToast(STATIC_LABELS.dateCompareToast.rawValue)
        }
        else {
            var booking: BOOKING_STATUS = .ONGOING
            if isUpcoming {
                if onGoingBtn.isSelected {
                    booking = .ONGOING
                }
                else {
                    booking = .UPCOMING
                }
            }
            else {
                if cancelledBtn.isSelected {
                    booking = .CANCELLED
                }
                else {
                    booking = .COMPLETED
                }
            }
            let request = MyBookingListRequest(bookingType: booking, page: 1, limit: 30, dateTo: toDate, dateFrom: fromDate)
            filterDelegate?.filterEvents(request: request)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}
