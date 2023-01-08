//
//  ExploreCalendarVC.swift
//  BMA
//
//  Created by MACBOOK on 07/07/21.
//

import UIKit
import FSCalendar

class ExploreCalendarVC: UIViewController {
    
    var locationInfo: Location = Location()
    private let calendar = Calendar.current
    private var day: Int = Int()
    private var month: Int = Int()
    private var year: Int = Int()
    private var calendarEventsVM: CalendarEventsViewModel = CalendarEventsViewModel()
    private var datesRange: [Date]?
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DATE_FORMATS.ddMMMyyyy.rawValue
        return formatter
    }()
    
    //OUTLETS
    @IBOutlet weak var bottomConstraintOfCalendarView: NSLayoutConstraint!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var yearLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate().sharedDelegate().showTabBar()
        if SCREEN.HEIGHT >= 812 {
            bottomConstraintOfCalendarView.constant = 76
        } else {
            bottomConstraintOfCalendarView.constant = 56
        }
    }
    
    //MARK: - configUI
    private func configUI() {
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.scrollDirection = .vertical
        calendarView.appearance.separators = .interRows
        calendarView.rowHeight = 55
        calendarView.pagingEnabled = false
        calendarView.placeholderType = FSCalendarPlaceholderType.none
        
        yearLbl.text = getDateStringFromDate(date: Date(), format: DATE_FORMATS.year.rawValue)
        calendarEventsVM.fetchCalendarEvents(request: EventListRequest())
        
        calendarEventsVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.calendarEventsVM.success.value {
                DispatchQueue.main.async {
                    self.calendarView.reloadData()
                }
            }
        }
    }
    
    //MARK: - switchToListViewBtnIsPressed
    @IBAction func switchToListViewBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - switchToMapViewBtnIsPressed
    @IBAction func switchToMapViewBtnIsPressed(_ sender: UIButton) {
        let vc: ExploreMapVC = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.ExploreMapVC.rawValue) as! ExploreMapVC
        vc.locationInfo = self.locationInfo
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - filterBtnIsPressed
    @IBAction func filterBtnIsPressed(_ sender: UIButton) {
        let vc: FilterVC = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.FilterVC.rawValue) as! FilterVC
        vc.filterDelegate = self
        vc.lat = self.locationInfo.coordinates[1]
        vc.long = self.locationInfo.coordinates[0]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - addEventBtnIsPressed
    @IBAction func addEventBtnIsPressed(_ sender: UIButton) {
        if AppModel.shared.currentUser.subscription {
            let vc: CreateEvent_OneVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.CreateEvent_OneVC.rawValue) as! CreateEvent_OneVC
            vc.userFrom = .calendar
            vc.isFromSubscription = false
            vc.calendarEventsVM = self.calendarEventsVM
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            showAlertWithOption(STATIC_LABELS.eventCreatePopUpHeading.rawValue, message: STATIC_LABELS.eventCreatePopUpMsg.rawValue, btns: [STATIC_LABELS.subscribeNow.rawValue, STATIC_LABELS.cancel.rawValue]) {
                // action of subscribe btn
                let vc: SubscriptionVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.SubscriptionVC.rawValue) as! SubscriptionVC
                vc.userFrom = .calendar
                self.navigationController?.pushViewController(vc, animated: true)
            } completionCancel: {
                // action of cancel btn
            }
        }
    }
}

//MARK: - FSCalendarDelegate and FSCalendarDataSource Methods
extension ExploreCalendarVC: FSCalendarDelegate, FSCalendarDataSource {
    // minimumDate
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    // didSelect
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        yearLbl.text = getDateStringFromDate(date: date, format: DATE_FORMATS.year.rawValue)
        let vc: CalendarListVC = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.CalendarListVC.rawValue) as! CalendarListVC
        vc.selectedDate = date
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // numberOfEventsFor
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        for dates in 0..<calendarEventsVM.calendarEventList.value.count {
            if self.calendarEventsVM.calendarEventList.value[dates].datumRepeat {
                let dateString = self.dateFormatter.string(from: date)
                if (self.calendarEventsVM.calendarEventList.value[dates].dates.contains(Int(dateString) ?? 0)) {
                    return 1
                }
            } else {
                let dateString = self.dateFormatter2.string(from: date)
                let firstDate = getDateFromDateString(strDate: self.calendarEventsVM.calendarEventList.value[dates].startDate)
                self.day = self.calendar.component(.day, from: firstDate)
                self.month = self.calendar.component(.month, from: firstDate )
                self.year = self.calendar.component(.year, from: firstDate )
                let dateComponents = DateComponents(calendar: self.calendar,
                                                    year: self.year,
                                                    month: self.month,
                                                    day: self.day, hour: 12, minute: 0, second: 0)
                let finalFirstDate = self.calendar.date(from: dateComponents)!
                let lastDate = getDateFromDateString(strDate: self.calendarEventsVM.calendarEventList.value[dates].endDate)
                self.day = self.calendar.component(.day, from: lastDate)
                self.month = self.calendar.component(.month, from: lastDate )
                self.year = self.calendar.component(.year, from: lastDate )
                let dateComponents2 = DateComponents(calendar: self.calendar,
                                                    year: self.year,
                                                    month: self.month,
                                                    day: self.day, hour: 12, minute: 0, second: 0)
                let finalLastDate = self.calendar.date(from: dateComponents2)!
                let range = BMA.datesRange(from: finalFirstDate, to: finalLastDate)
                var eventDates: [String] = [String]()
                for d in range {
                    eventDates.append(d.dateString(DATE_FORMATS.ddMMMyyyy.rawValue))
                }
                if (eventDates.contains(dateString)) {
                    return 1
                }
            }
        }
        return 0
    }
    
    // willDisplay
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        yearLbl.text = getDateStringFromDate(date: date, format: DATE_FORMATS.year.rawValue)
    }
    
}

//MARK: - ApplyFilterDelegate
extension ExploreCalendarVC: ApplyFilterDelegate {
    func filterEvents(request: EventListRequest) {
        calendarEventsVM.calendarEventList.value.removeAll()
        calendarEventsVM.fetchCalendarEvents(request: request)
    }
}
