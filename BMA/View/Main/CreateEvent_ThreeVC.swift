//
//  CreateEvent_ThreeVC.swift
//  BMA
//
//  Created by MACBOOK on 01/07/21.
//

import UIKit
import FSCalendar
import SainiUtils

class CreateEvent_ThreeVC: UIViewController {
    
    var firstDate: Date?
    private var lastDate: Date?
    var addEventRequest: AddEventRequest?
    private var datesRange: [Date]?
    private var endDate: String = String()
    private var addEventVM: AddEventViewModel = AddEventViewModel()
    private var updateEventVM: UpdateEventViewModel = UpdateEventViewModel()
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DATE_FORMATS.ddMMMyyyy.rawValue
        return formatter
    }()
    
    private let calendar = Calendar.current
    private var day: Int = Int()
    private var month: Int = Int()
    private var year: Int = Int()
    
    var calendarEventsVM: CalendarEventsViewModel = CalendarEventsViewModel()
    var eventDetailVM: EventDetailViewModel = EventDetailViewModel()
    var eventListVM: EventsLeaguesViewModel?
    var userFrom: USER_FROM = .login
    
    // OUTLETS
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var repeatEventBtn: UIButton!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var selectWeekBtn: UIButton!
    @IBOutlet weak var navHeaderLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configUI()
    }
    
    //MARK: - configUI
    private func configUI() {
        selectWeekBtn.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1), borderWidth: 1, cornerRadius: 10)
        createBtn.sainiCornerRadius(radius: 10)
        
        switch userFrom {
        case .login:
            createBtn.setTitle(STATIC_LABELS.createBtn.rawValue, for: .normal)
            navHeaderLbl.text = STATIC_LABELS.createEvent.rawValue
        case .explore:
            createBtn.setTitle(STATIC_LABELS.createBtn.rawValue, for: .normal)
            navHeaderLbl.text = STATIC_LABELS.createEvent.rawValue
        case .eventDetail:
            renderData(data: eventDetailVM.eventDetail.value)
            createBtn.setTitle(STATIC_LABELS.saveBtn.rawValue, for: .normal)
            navHeaderLbl.text = STATIC_LABELS.editEvent.rawValue
        case .calendar:
            createBtn.setTitle(STATIC_LABELS.createBtn.rawValue, for: .normal)
            navHeaderLbl.text = STATIC_LABELS.createEvent.rawValue
        case .profile:
            createBtn.setTitle(STATIC_LABELS.createBtn.rawValue, for: .normal)
            navHeaderLbl.text = STATIC_LABELS.createEvent.rawValue
        }
        
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.allowsMultipleSelection = true
        calendarView.swipeToChooseGesture.isEnabled = true
        calendarView.backgroundColor = UIColor.white
        headerLbl.text = calendarView.currentPage.dateString(DATE_FORMATS.mmmm.rawValue)
        calendarView.select(firstDate)
        
        addEventVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.addEventVM.success.value {
                
                var isRedirect: Bool = false
                switch self.userFrom {
                case .login:
                    AppDelegate().sharedDelegate().navigateToDashboard()
                case .explore:
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: ExploreVC.self) {
                            isRedirect = true
                            self.navigationController?.popToViewController(controller, animated: true)
                            break
                        }
                    }
                case .eventDetail:
                    isRedirect = true
                    self.navigationController?.popViewController(animated: true)
                case .calendar:
                    self.calendarEventsVM.fetchCalendarEvents(request: EventListRequest())
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: ExploreCalendarVC.self) {
                            isRedirect = true
                            self.navigationController?.popToViewController(controller, animated: true)
                            break
                        }
                    }
                case .profile:
                    self.eventListVM?.EventsLeagues(page: 1)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: EventsLeaguesPostedVC.self) {
                                isRedirect = true
                                let vc = controller as! EventsLeaguesPostedVC
                                vc.currentPage = 1
                                vc.isHasMore = false
                                self.navigationController?.popToViewController(controller, animated: true)
                                break
                            }
                        }
                    }
                }
//                if !isRedirect {
//                    self.navigationController?.popToRootViewController(animated: true)
//                }
            }
        }
        
        updateEventVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.updateEventVM.success.value {
                if self.userFrom == .eventDetail {
                    self.eventListVM?.EventsLeagues(page: 1)
                    self.eventDetailVM.eventDetail.value = self.updateEventVM.eventDetail.value
                    var isRedirect: Bool = false
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: EventDetailVC.self) {
                            isRedirect = true
                            self.navigationController?.popToViewController(controller, animated: true)
                            break
                        }
                    }
                    if !isRedirect {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
    }
    
    //MARK: - renderData
    private func renderData(data: EventDetail) {
        repeatEventBtn.isSelected = data.repeat
        lastDate = getDateFromDateString(strDate: data.endDate)
        self.day = self.calendar.component(.day, from: lastDate ?? Date())
        self.month = self.calendar.component(.month, from: lastDate ?? Date())
        self.year = self.calendar.component(.year, from: lastDate ?? Date())
        let dateComponents = DateComponents(calendar: self.calendar,
                                            year: self.year,
                                            month: self.month,
                                            day: self.day, hour: 12, minute: 0, second: 0)
        let finalDate = self.calendar.date(from: dateComponents)!
        
        if firstDate != nil {
            let range = datesRange(from: firstDate!, to: finalDate)
            print(range)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                for d in range {
                    self.calendarView.select(d)
                    
                }
            }
            datesRange = range
        }
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - selectWeekBtnIsPressed
    @IBAction func selectWeekBtnIsPressed(_ sender: UIButton) {
        // only first date is selected:
        if firstDate != nil && lastDate == nil {
            let weekLastDate = firstDate?.sainiAddDays(6)
            let range = datesRange(from: firstDate!, to: weekLastDate!)
            
            lastDate = range.last
            
            for d in range {
                calendarView.select(d)
            }
            
            datesRange = range
            
            print("datesRange contains: \(datesRange!)")
            if let endDate = lastDate{
                self.day = self.calendar.component(.day, from: endDate)
                self.month = self.calendar.component(.month, from: endDate)
                self.year = self.calendar.component(.year, from: endDate)
                let dateComponents = DateComponents(calendar: self.calendar,
                                                    year: self.year,
                                                    month: self.month,
                                                    day: self.day, hour: 23, minute: 59, second: 59)
                let finalDate = self.calendar.date(from: dateComponents)!
                print("Final Date::: \(finalDate)")
                self.endDate = getDateStringFromDate(date: finalDate, format: DATE_FORMATS.utcFormat.rawValue) //lastDate!.getEventEndDate ?? startDate
                print(self.endDate)
            }
            return
        }
    }
    
    //MARK: - repeatEventEveryMonthBtnIsPressed
    @IBAction func repeatEventEveryMonthBtnIsPressed(_ sender: UIButton) {
        if !repeatEventBtn.isSelected {
            repeatEventBtn.isSelected = true
        }
        else {
            repeatEventBtn.isSelected = false
        }
    }
    
    //MARK: - clickToNextMonth
    @IBAction func clickToNextMonth(_ sender: UIButton) {
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: calendarView.currentPage)
        calendarView.setCurrentPage(nextMonth!, animated: true)
        headerLbl.text = calendarView.currentPage.dateString(DATE_FORMATS.mmmm.rawValue)
    }
    
    //MARK: - clickToPreviousMonth
    @IBAction func clickToPreviousMonth(_ sender: UIButton) {
        let nextMonth = Calendar.current.date(byAdding: .month, value: -1, to: calendarView.currentPage)
        calendarView.setCurrentPage(nextMonth!, animated: true)
        headerLbl.text = calendarView.currentPage.dateString(DATE_FORMATS.mmmm.rawValue)
    }
    
    //MARK: - createEventBtnIsPressed
    @IBAction func createEventBtnIsPressed(_ sender: UIButton) {
        
        if endDate == "" && firstDate != nil {
            self.day = self.calendar.component(.day, from: firstDate!)
            self.month = self.calendar.component(.month, from: firstDate!)
            self.year = self.calendar.component(.year, from: firstDate!)
            let dateComponents = DateComponents(calendar: self.calendar,
                                                year: self.year,
                                                month: self.month,
                                                day: self.day, hour: 23, minute: 59, second: 59)
            let finalDate = self.calendar.date(from: dateComponents)!
            endDate = getDateStringFromDate(date: finalDate, format: DATE_FORMATS.utcFormat.rawValue)
        }
        self.addEventRequest?.endDate = endDate
        self.addEventRequest?.repeat = repeatEventBtn.isSelected
        if userFrom == .eventDetail {
            updateEventVM.updateEvent(request: self.addEventRequest ?? AddEventRequest())
        }
        else {
            addEventVM.addNewEvent(request: self.addEventRequest ?? AddEventRequest())
        }
    }
    
    deinit {
        log.success("CreateEvent_ThreeVC Memory deallocated!")/
    }
}

//MARK: - FSCalendarDelegate and FSCalendarDataSource Methods
extension CreateEvent_ThreeVC: FSCalendarDelegate, FSCalendarDataSource {
    // minimumDate
    func minimumDate(for calendar: FSCalendar) -> Date {
        return firstDate ?? Date()
    }
    
    // didSelect
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        headerLbl.text = calendarView.currentPage.dateString(DATE_FORMATS.mmmm.rawValue)
        print("did select date \(self.dateFormatter.string(from: date))")
        // nothing selected:
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            
            print("datesRange contains: \(datesRange!)")
            
            return
        }
        
        // only first date is selected:
        if firstDate != nil || lastDate == nil {
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                //                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]
                
                print("datesRange contains: \(datesRange!)")
                
                return
            }
            
            let range = datesRange(from: firstDate!, to: date)
            
            lastDate = range.last
            
            for d in range {
                calendar.select(d)
            }
            
            datesRange = range
            
            print("datesRange contains: \(datesRange!)")
            if let endDate = lastDate {
                self.day = self.calendar.component(.day, from: endDate)
                self.month = self.calendar.component(.month, from: endDate)
                self.year = self.calendar.component(.year, from: endDate)
                let dateComponents = DateComponents(calendar: self.calendar,
                                                    year: self.year,
                                                    month: self.month,
                                                    day: self.day, hour: 23, minute: 59, second: 59)
                let finalDate = self.calendar.date(from: dateComponents)!
                self.endDate = getDateStringFromDate(date: finalDate, format: DATE_FORMATS.utcFormat.rawValue)
            }
            return
        }
        
        // both are selected:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            
            lastDate = nil
            calendar.select(firstDate)
            
            datesRange = []
            
            print("datesRange contains: \(datesRange!)")
        }
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    // calendarCurrentPageDidChange
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
        headerLbl.text = getDateStringFromDate(date: calendar.currentPage, format: DATE_FORMATS.mmmm.rawValue)
    }
    
    // didDeselect
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if date == firstDate {
            calendar.select(date)
            return
        }
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            
            lastDate = date.sainiAddDays(-1)
            calendar.select(firstDate)
            
            datesRange = []
            let range = datesRange(from: firstDate!, to: lastDate!)
            
            lastDate = range.last
            
            for d in range {
                calendar.select(d)
            }
            
            datesRange = range
            
            print("datesRange contains: \(datesRange!)")
            
            return
        }
    }
    
    // didSelect
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        headerLbl.text = calendarView.currentPage.dateString(DATE_FORMATS.mmmm.rawValue)
        print("did select date \(self.dateFormatter.string(from: date))")
        calendar.reloadData()
    }
    
    //MARK: - datesRange
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }
        
        var tempDate = from
        var array = [tempDate]
        
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        
        return array
    }
}
