//
//  EventsLeaguesPostedVC.swift
//  BMA
//
//  Created by iMac on 02/07/21.
//

import UIKit
import SainiUtils

class EventsLeaguesPostedVC: UIViewController {
    
    
    @IBOutlet weak var tblView: UITableView!
    
    
    private var refreshControl : UIRefreshControl = UIRefreshControl.init()
    private var eventListVM: EventsLeaguesViewModel = EventsLeaguesViewModel()
    var currentPage : Int = VALUE.ONE.getValue()
    var isHasMore : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    func configUI() {
        registerTableviewMethod()
        registerTableviewMethod()
        refreshControllSetup()
        
        eventListVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.eventListVM.success.value {
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }
        
        eventListVM.eventList.bind { [weak self](_) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
        }
        eventListVM.EventsLeagues(page: currentPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate().sharedDelegate().hideTabBar()
    }
    
    //MARK: - Refresh controll setup
    func refreshControllSetup() {
        refreshControl.tintColor = .systemYellow
        refreshControl.addTarget(self, action: #selector(refreshDataSetUp) , for: .valueChanged)
        tblView.refreshControl = refreshControl
    }
    
    //MARK: - Refresh data
    @objc func refreshDataSetUp() {
        refreshControl.endRefreshing()
        isHasMore = false
        currentPage = VALUE.ONE.getValue()
        eventListVM.EventsLeagues(page: currentPage)
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToAdd(_ sender: Any) {
        if AppModel.shared.currentUser.subscription {
            let vc: CreateEvent_OneVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.CreateEvent_OneVC.rawValue) as! CreateEvent_OneVC
            vc.userFrom = .profile
            vc.eventListVM = self.eventListVM
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            showAlertWithOption(STATIC_LABELS.eventCreatePopUpHeading.rawValue, message: STATIC_LABELS.eventCreatePopUpMsg.rawValue, btns: [STATIC_LABELS.subscribeNow.rawValue, STATIC_LABELS.cancel.rawValue]) {
                // action of subscribe btn
                let vc: SubscriptionVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.SubscriptionVC.rawValue) as! SubscriptionVC
                vc.userFrom = .profile
                self.navigationController?.pushViewController(vc, animated: true)
            } completionCancel: {
                // action of cancel btn
            }
        }
    }
}

//MARK: - TableView Delegate
extension EventsLeaguesPostedVC : UITableViewDelegate, UITableViewDataSource {
    
    func registerTableviewMethod() {
        tblView.register(UINib.init(nibName: TABLE_VIEW_CELL.EventsLeaguesTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.EventsLeaguesTVC.rawValue)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if eventListVM.eventList.value.count == DocumentDefaultValues.Empty.int {
            tableView.sainiSetEmptyMessage(STATIC_LABELS.noDataFound.rawValue)
        } else {
            tableView.restore()
            tableView.separatorStyle = .none
        }
        return eventListVM.eventList.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.EventsLeaguesTVC.rawValue, for: indexPath) as! EventsLeaguesTVC
        
        cell.lineView.isHidden = true
        cell.favBtn.isHidden = true
        
        let eventlistData = eventListVM.eventList.value
        if eventlistData[indexPath.row].images != nil {
            cell.eventImageView.downloadCachedImage(placeholder: GLOBAL_IMAGES.eventPlaceHolder.rawValue, urlString: AppImageUrl.average + eventlistData[indexPath.row].images![0])
        }
        cell.eventNameLbl.text = eventlistData[indexPath.row].name
        cell.addressLbl.text = eventlistData[indexPath.row].location.address
        cell.dateLbl.text = getDateStringFromDateString(strDate: eventlistData[indexPath.row].startDate, format: DATE_FORMATS.ddMMMyyyy.rawValue) + " - " + getDateStringFromDateString(strDate: eventlistData[indexPath.row].endDate, format: DATE_FORMATS.ddMMMyyyy.rawValue)
        
        cell.viewDetailsBtn.tag = indexPath.row
        cell.viewDetailsBtn.addTarget(self, action: #selector(viewEventDetailBtnIsPressed), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: - viewEventDetailBtnIsPressed
    @objc func viewEventDetailBtnIsPressed(_ sender: UIButton) {
        let vc: EventDetailVC = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.EventDetailVC.rawValue) as! EventDetailVC
        vc.eventRef = eventListVM.eventList.value[sender.tag].id
        vc.eventListVM = self.eventListVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
