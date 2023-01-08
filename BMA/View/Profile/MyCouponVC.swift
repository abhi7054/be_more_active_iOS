//
//  MyCouponVC.swift
//  BMA
//
//  Created by iMac on 02/07/21.
//

import UIKit

class MyCouponVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    private var refreshControl : UIRefreshControl = UIRefreshControl.init()
    var couponListVM : CouponListViewModel = CouponListViewModel()
    private var currentPage : Int = Int()
    private var isHasMore : Bool = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }
    
    private func configUI() {
        refreshControllSetup()
        refreshDataSetUp()
        registerTableviewMethod()
        
        couponListVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.couponListVM.success.value {
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }
        
        couponListVM.hasMore.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.couponListVM.hasMore.value {
                self.isHasMore = self.couponListVM.hasMore.value
            }
        }
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
        isHasMore = false
        refreshControl.endRefreshing()
        couponListVM.list.value.removeAll()
        currentPage = 1
        couponListVM.fetchCouponListing(request: MorePageRequest(page: currentPage))
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToAdd(_ sender: Any) {
    }
    
}

//MARK: - TableView Delegate
extension MyCouponVC : UITableViewDelegate, UITableViewDataSource {
    func registerTableviewMethod() {
        tblView.register(UINib.init(nibName: TABLE_VIEW_CELL.MyCouponTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.MyCouponTVC.rawValue)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if couponListVM.list.value.isEmpty {
            tableView.sainiSetEmptyMessage(STATIC_LABELS.noDataFound.rawValue)
        } else {
            tableView.restore()
            tableView.separatorStyle = .none
        }
        return couponListVM.list.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.MyCouponTVC.rawValue, for: indexPath) as? MyCouponTVC else { return UITableViewCell() }
        cell.discountCouponLbl.text = couponListVM.list.value[indexPath.row].couponCode
        cell.descriptionLbl.text = couponListVM.list.value[indexPath.row].couponDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == couponListVM.list.value.count - 2 && isHasMore {
            currentPage += 1
            couponListVM.fetchCouponListing(request: MorePageRequest(page: currentPage))
        }
    }
}

