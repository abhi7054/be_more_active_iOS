//
//  NotificationVC.swift
//  BMA
//
//  Created by iMac on 02/07/21.
//

import UIKit

class NotificationVC: UIViewController {
    
    @IBOutlet weak var bottomConstraintOfTableView: NSLayoutConstraint!
    @IBOutlet weak var tblView: UITableView!
    
    private var notificationSeenVM: NotificationSeenViewModel = NotificationSeenViewModel()
    private var refreshControl : UIRefreshControl = UIRefreshControl.init()
    private var NotificationListVM : NotificationListViewModel = NotificationListViewModel()
    private var notificationArr : [NotificationListModel] = [NotificationListModel]()
    private var userImgArr: User?
    private var currentPage : Int = VALUE.ONE.getValue()
    private var isHasMore : Bool = false
    private var notificationSeenIndex: Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    //MARK: - configUI
    private func configUI() {
        NotificationListVM.delegate = self
        NotificationListVM.NotificationList(request: MorePageRequest(page: currentPage))
        refreshControllSetup()
        registerTableviewMethod()
        
        notificationSeenVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.notificationSeenVM.success.value {
                self.notificationArr[self.notificationSeenIndex].seen = true
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate().sharedDelegate().showTabBar()
        if SCREEN.HEIGHT >= 812 {
            bottomConstraintOfTableView.constant = 80
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
        currentPage = VALUE.ONE.getValue()
        NotificationListVM.NotificationList(request: MorePageRequest(page: currentPage))
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension NotificationVC : NotificationDelegate {
    
    func didRecieveNotificationResponse(response: NotificationListResponse) {
        isHasMore = response.hasMore
        if currentPage == VALUE.ONE.getValue() {
            notificationArr = [NotificationListModel]()
            userImgArr = User()
        }
        notificationArr += response.data
//        userImgArr += response.data.
        
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
}

//MARK: - TableView Delegate
extension NotificationVC : UITableViewDelegate, UITableViewDataSource {
    
    func registerTableviewMethod() {
        tblView.register(UINib.init(nibName: TABLE_VIEW_CELL.NotificationTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.NotificationTVC.rawValue)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notificationArr.isEmpty {
            tableView.sainiSetEmptyMessage(STATIC_LABELS.noDataFound.rawValue)
        } else {
            tableView.restore()
            tableView.separatorStyle = .none
        }
        return notificationArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.NotificationTVC.rawValue, for: indexPath) as? NotificationTVC else { return UITableViewCell() }
        
        if let userDetail = notificationArr[indexPath.row].user {
            cell.titleLbl.text = userDetail.name + " " + notificationArr[indexPath.row].text
            cell.userImage.downloadCachedImage(placeholder: GLOBAL_IMAGES.profilePlaceHolder.rawValue, urlString: AppImageUrl.average + userDetail.picture)
//            if notificationArr[indexPath.row].type == .ADMIN {
//                cell.userImage.image = UIImage.init(named: GLOBAL_IMAGES.adminImage.rawValue)
//            }
//            else{
//                cell.userImage.downloadCachedImage(placeholder: GLOBAL_IMAGES.profilePlaceHolder.rawValue, urlString: AppImageUrl.average + userDetail.picture)
//            }
        }
        
        cell.dateTimeLbl.text = getDateStringFromDateString(strDate: notificationArr[indexPath.row].createdOn, format: DATE_FORMATS.ddMMMyyyy.rawValue)
        
        if notificationArr[indexPath.row].seen {
            cell.notiBadgeImg.isHidden = true
        } else {
            cell.notiBadgeImg.isHidden = false
        }
        
        cell.userImage.sainiCornerRadius(radius: 20)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if notificationArr.count - 2 == indexPath.row {
            if isHasMore {
                currentPage = currentPage + 1
                NotificationListVM.NotificationList(request: MorePageRequest(page: currentPage))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !notificationArr[indexPath.row].seen {
            notificationSeenIndex = indexPath.row
            let request = NotificationSeenRequest(notificationId: notificationArr[indexPath.row].id)
            notificationSeenVM.markNotificationSeen(request: request)
        }
        if notificationArr[indexPath.row].type == .ADMIN {
            return
        } else {
            let vc = STORYBOARD.BOOKING.instantiateViewController(withIdentifier: "BookingDetailsVC") as! BookingDetailsVC
            vc.eventRef = notificationArr[indexPath.row].additionalRef
            vc.userRef = notificationArr[indexPath.row].user?.id ?? DocumentDefaultValues.Empty.string
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
