//
//  CalendarListVC.swift
//  BMA
//
//  Created by MACBOOK on 07/07/21.
//

import UIKit
import KVKCalendar
import EventKit

class CalendarListVC: UIViewController {
    
    private var calendarListVM: CalendarListViewModel = CalendarListViewModel()
    var createdEvents: [Event] = [Event]()
    var bookedEvents: [Event] = [Event]()
    var selectedDate: Date = Date()
    let calendar = Calendar.current
    private var style: Style = {
        var style = Style()
        if UIDevice.current.userInterfaceIdiom == .phone {
            style.timeline.widthTime = 40
            style.timeline.currentLineHourWidth = 45
            style.timeline.offsetTimeX = 2
            style.timeline.offsetLineLeft = 2
            style.headerScroll.titleDateAlignment = .center
            style.headerScroll.isAnimateTitleDate = true
            style.headerScroll.heightHeaderWeek = 70
            style.event.isEnableVisualSelect = false
            style.month.isHiddenEventTitle = true
            style.month.weekDayAlignment = .center
        } else {
            style.timeline.widthEventViewer = 350
            style.headerScroll.fontNameDay = .systemFont(ofSize: 17)
        }
        style.event.textForNewEvent = ""
        style.event.isEnableVisualSelect = false
        style.defaultType = .day
        style.month.autoSelectionDateWhenScrolling = false
        style.timeline.offsetTimeY = 54
        //        style.event.defaultHeight = 50
        style.startWeekDay = .sunday
        style.timeSystem = .twelve
        style.headerScroll.isHidden = true
        style.timeline.isEnabledCreateNewEvent = false
        style.timeline.scrollDirections = [.vertical]
        //        style.systemCalendars = ["Calendar"]
        if #available(iOS 13.0, *) {
            style.event.iconFile = UIImage(systemName: "paperclip")
        }
        return style
    }()
    
    private lazy var calendarView: CalendarView = {
        let calendar = CalendarView(frame: self.view.frame, date: selectedDate, style: style)
        calendar.delegate = self
        calendar.dataSource = self
        return calendar
    }()
    
    // OUTLETS
    @IBOutlet weak var calendarListView: UIView!
    //    @IBOutlet weak var calendarView: DayView!
    @IBOutlet weak var dateLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configUI()
        calendarListView.addSubview(calendarView)
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate().sharedDelegate().hideTabBar()
    }
    
    //MARK: - viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var frame = calendarListView.frame
        frame.origin.y = 0
        calendarView.reloadFrame(frame)
    }
    
    //MARK: - configUI
    private func configUI() {
        dateLbl.text = selectedDate.dateString(DATE_FORMATS.format1.rawValue)
        let date = calendar.component(.day, from: selectedDate)
        let month = calendar.component(.month, from: selectedDate)
        let year = calendar.component(.year, from: selectedDate)
        let dateComponents = DateComponents(calendar: calendar,
                                            year: year,
                                            month: month,
                                            day: date, hour: 12, minute: 0, second: 0) // this will create issue in different timezones
        let finalDate = calendar.date(from: dateComponents)!
        let listDate = getDateStringFromDate(date: finalDate, format: DATE_FORMATS.utcFormat.rawValue)
        let request = CalendarListRequest(date: date, dateTime: listDate)
        calendarListVM.fetchCalenderEventList(request: request)
        
        calendarListVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.calendarListVM.success.value {
                self.loadEvents { (createdEvent, bookedEvent)  in
                    DispatchQueue.main.async { [weak self] in
                        self?.createdEvents = createdEvent
                        self?.bookedEvents = bookedEvent
                        self?.calendarView.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - CalendarDelegate CalendarDataSource Methods
extension CalendarListVC : CalendarDelegate, CalendarDataSource {
    func eventsForCalendar(systemEvents: [EKEvent]) -> [Event] {
        return createdEvents
    }
    
    //MARK: - loadEvents
    func loadEvents(completion: ([Event], [Event]) -> Void) {
        createdEvents = [Event]()
        bookedEvents = [Event]()
        for temp in calendarListVM.calendarList.value.myEvents {
            createdEvents.append(getCreatedEvent(temp))
        }
        for temp in calendarListVM.calendarList.value.myBookings {
            createdEvents.append(getBookedEvent(temp))
        }
        completion(createdEvents, bookedEvents)
    }
    
    //MARK: - getCreatedEvent
    func getCreatedEvent(_ dict : MyEvent) -> Event {
        var event = Event(ID: dict.id)
        let startDate = getDateFromDateString(strDate: dict.startTime)//"2021-07-27T06:20:00.000Z")//
        let date = calendar.component(.day, from: selectedDate)
        let month = calendar.component(.month, from: selectedDate)
        let year = calendar.component(.year, from: selectedDate)
        let startHour = calendar.component(.hour, from: startDate)
        let startMin = calendar.component(.minute, from: startDate)
        let dateComponents = DateComponents(calendar: calendar,
                                            year: year,
                                            month: month,
                                            day: date,
                                            hour: startHour,
                                            minute: startMin)
        let finalStartDate = calendar.date(from: dateComponents)!
        
        let endDate = getDateFromDateString(strDate: dict.endTime)//"2021-07-27T07:20:00.000Z")//
        let endHour = calendar.component(.hour, from: endDate)
        let endMin = calendar.component(.minute, from: endDate)
        let dateComponents2 = DateComponents(calendar: calendar,
                                            year: year,
                                            month: month,
                                            day: date,
                                            hour: endHour,
                                            minute: endMin)
        let finalEndDate = calendar.date(from: dateComponents2)!
        
        event.start = finalStartDate
        event.end = finalEndDate
        event.color = Event.Color(UIColor.black.withAlphaComponent(1))
        event.isAllDay = false
        event.isContainsFile = false
        event.title = TextEvent(timeline: dict.name + ": Created \n" + dict.location.address)
        event.textColor = .white
        event.recurringType = .none
        return event
    }
    
    //MARK: - getBookedEvent
    func getBookedEvent(_ dict : MyEvent) -> Event {
        var event = Event(ID: dict.id)
        let startDate = getDateFromDateString(strDate: dict.startTime) //"2021-07-27T02:20:00.000Z")//
        let endDate = getDateFromDateString(strDate: dict.endTime)// "2021-07-27T04:20:00.000Z")//
        event.start = startDate
        event.end = endDate
        event.color = Event.Color(AppColors.themeColor)
        event.isAllDay = false
        event.isContainsFile = false
        event.title =  TextEvent(timeline: dict.name + ": Booked\n" + dict.location.address)
        event.textColor = .black
        event.recurringType = .none
        return event
    }
}
