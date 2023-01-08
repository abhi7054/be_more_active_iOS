//
//  MyBookingVC.swift
//  BMA
//
//  Created by iMac on 01/07/21.
//

import UIKit

class MyBookingVC: UIViewController {
    
    @IBOutlet weak var bottomConstraintOfTableView: NSLayoutConstraint!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var upcomingBtn: UIButton!
    @IBOutlet weak var pastBtn: UIButton!
    @IBOutlet weak var upcomingLineView: UIView!
    @IBOutlet weak var pastLineView: UIView!
    @IBOutlet weak var filterBtn: UIButton!
    
    private var refreshControl : UIRefreshControl = UIRefreshControl.init()
    private var MyBookingListVM : MyBookingListViewModel = MyBookingListViewModel()
    private var upComingListArr : [BookingListModel] = [BookingListModel]()
    var pastListArr : [BookingListModel] = [BookingListModel]()
    private var selectedTab: Int = Int()
    private var upComingCurrentPage : Int = VALUE.ONE.getValue()
    private var upComingIsHasMore : Bool = false
    private var pastCurrentPage : Int = VALUE.ONE.getValue()
    private var pastIsHasMore : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    func configUI() {
        registerTableviewMethod()
        refreshControllSetup()
        MyBookingListVM.delegate = self
        clickToUpcomingPast(upcomingBtn)
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate().sharedDelegate().showTabBar()
        if SCREEN.HEIGHT >= 812 {
            bottomConstraintOfTableView.constant = 76
        } else {
            bottomConstraintOfTableView.constant = 66
        }
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
        if selectedTab == 1 {
            upComingIsHasMore = false
            upComingCurrentPage = VALUE.ONE.getValue()
            let request = MyBookingListRequest(bookingType: .UPCOMING_ONGOING, page: upComingCurrentPage)
            MyBookingListVM.MyBookingList(request: request, loader: true)
        }else {
            pastIsHasMore = false
            pastCurrentPage = VALUE.ONE.getValue()
            let request = MyBookingListRequest(bookingType: .PAST_CANCELLED, page: pastCurrentPage)
            MyBookingListVM.MyBookingList(request: request, loader: true)
        }
    }
    
    
    @IBAction func clickToFilter(_ sender: Any) {
        let vc = STORYBOARD.BOOKING.instantiateViewController(withIdentifier: "BookingFilterVC") as! BookingFilterVC
        vc.isUpcoming = upcomingBtn.isSelected
        vc.filterDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func clickToUpcomingPast(_ sender: UIButton) {
        selectedTab = sender.tag
        if sender.tag == 1 {
            upcomingLineView.isHidden = false
            pastLineView.isHidden = true
            upcomingBtn.isSelected = true
            pastBtn.isSelected = false
            upcomingBtn.alpha = 1
            pastBtn.alpha = 0.6
            if upComingListArr.count == 0 {
                let request = MyBookingListRequest(bookingType: .UPCOMING_ONGOING, page: upComingCurrentPage)
                MyBookingListVM.MyBookingList(request: request, loader: true)
            }
        }
        else {
            upcomingLineView.isHidden = true
            pastLineView.isHidden = false
            upcomingBtn.isSelected = false
            pastBtn.isSelected = true
            upcomingBtn.alpha = 0.6
            pastBtn.alpha = 1
            if pastListArr.count == 0 {
                let request = MyBookingListRequest(bookingType: .PAST_CANCELLED, page: pastCurrentPage)
                MyBookingListVM.MyBookingList(request: request, loader: true)
            }
        }
        tblView.reloadData()
    }
}

extension MyBookingVC: MyBookingListDelegate {
    func didRecieveMyBookingListResponse(response: BookingListResposne) {
        if selectedTab == 1 {
            upComingIsHasMore = response.hasMore
            if upComingCurrentPage == VALUE.ONE.getValue() {
                upComingListArr = [BookingListModel]()
            }
            upComingListArr += response.data
        }else {
            pastIsHasMore = response.hasMore
            if pastCurrentPage == VALUE.ONE.getValue() {
                pastListArr = [BookingListModel]()
            }
            pastListArr += response.data
        }
        tblView.reloadData()
    }
}

//MARK: - TableView Delegate
extension MyBookingVC : UITableViewDelegate, UITableViewDataSource {
    func registerTableviewMethod() {
        tblView.register(UINib.init(nibName: TABLE_VIEW_CELL.MyBookingTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.MyBookingTVC.rawValue)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedTab == 1 {
            if upComingListArr.isEmpty {
                tableView.sainiSetEmptyMessage(STATIC_LABELS.noDataFound.rawValue)
            }else {
                tableView.restore()
                tableView.separatorStyle = .none
            }
            return upComingListArr.count
        }else {
            if pastListArr.isEmpty {
                tableView.sainiSetEmptyMessage(STATIC_LABELS.noDataFound.rawValue)
            }else {
                tableView.restore()
                tableView.separatorStyle = .none
            }
            return pastListArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedTab == 1 {
            let cell = tblView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.MyBookingTVC.rawValue, for: indexPath) as! MyBookingTVC
            
            cell.setupDetails(upComingListArr[indexPath.row])
            
            return cell
        }
            
        else {
            let cell = tblView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.MyBookingTVC.rawValue, for: indexPath) as! MyBookingTVC
                        
            cell.setupDetails(pastListArr[indexPath.row])
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if selectedTab == 1 {
            if upComingListArr.count - 2 == indexPath.row {
                if upComingIsHasMore {
                    upComingCurrentPage = upComingCurrentPage + 1
                    let request = MyBookingListRequest(bookingType: .UPCOMING_ONGOING, page: upComingCurrentPage)
                    MyBookingListVM.MyBookingList(request: request, loader: false)
                }
            }
        }
        else {
            if pastListArr.count - 2 == indexPath.row {
                if pastIsHasMore {
                    pastCurrentPage = pastCurrentPage + 1
                    let request = MyBookingListRequest(bookingType: .PAST_CANCELLED, page: pastCurrentPage)
                    MyBookingListVM.MyBookingList(request: request, loader: false)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = STORYBOARD.BOOKING.instantiateViewController(withIdentifier: "BookingDetailsVC") as! BookingDetailsVC
        if selectedTab == 1 {
            vc.eventRef = upComingListArr[indexPath.row].eventRef
        }else {
             vc.eventRef = pastListArr[indexPath.row].eventRef
        }
        vc.bookingCancelled = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - BookingCancelSuccessDelegate
extension MyBookingVC: BookingCancelSuccessDelegate {
    func bookingCancelled() {
        if selectedTab == 1 {
            upComingIsHasMore = false
            upComingCurrentPage = VALUE.ONE.getValue()
            let request = MyBookingListRequest(bookingType: .UPCOMING_ONGOING, page: upComingCurrentPage)
            MyBookingListVM.MyBookingList(request: request, loader: true)
        }else {
            pastIsHasMore = false
            pastCurrentPage = VALUE.ONE.getValue()
            let request = MyBookingListRequest(bookingType: .PAST_CANCELLED, page: pastCurrentPage)
            MyBookingListVM.MyBookingList(request: request, loader: true)
        }
    }
}

//MARK: - ApplyBookingFilterDelegate
extension MyBookingVC: ApplyBookingFilterDelegate {
    func filterEvents(request: MyBookingListRequest) {
        if selectedTab == 1 {
            upComingCurrentPage = 1
            upComingIsHasMore = false
        }
        else {
            pastIsHasMore = false
            pastCurrentPage = 1
        }
        MyBookingListVM.MyBookingList(request: request, loader: true)
    }
}
