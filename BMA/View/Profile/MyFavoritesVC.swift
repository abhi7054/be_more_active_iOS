//
//  MyFavoritesVC.swift
//  BMA
//
//  Created by iMac on 02/07/21.
//

import UIKit
import SainiUtils

class MyFavoritesVC: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var noDataLbl: UILabel!
    
    private var updateFavouriteVM: AddFavouriteViewModel = AddFavouriteViewModel()
    private var refreshControl : UIRefreshControl = UIRefreshControl.init()
    var  FavoriteVM : FavoriteListViewModel = FavoriteListViewModel()
    private var currentPage : Int = VALUE.ONE.getValue()
    private var isHasMore : Bool = false
    private var eventRef: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       configUI()
    }
    
    func configUI() {
        registerTableviewMethod()
        
        refreshControllSetup()
        refreshDataSetUp()
        noDataLbl.isHidden = true
        
        FavoriteVM.favoriteList.bind { [weak self](_) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
            self.noDataLbl.isHidden = self.FavoriteVM.favoriteList.value.isEmpty ? false : true
        }
        
        FavoriteVM.hasMore.bind { [weak self](_) in
            guard let `self` = self else { return }
            self.isHasMore = self.FavoriteVM.hasMore.value
        }
        
        updateFavouriteVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.updateFavouriteVM.success.value {
                self.FavoriteVM.removeFav(removeAt: self.eventRef)
                displayToast(STATIC_LABELS.unfavToast.rawValue)
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
        FavoriteVM.favoriteList.value.removeAll()
        isHasMore = false
        refreshControl.endRefreshing()
        currentPage = VALUE.ONE.getValue()
        FavoriteVM.FavoriteList(request: MorePageRequest(page: currentPage))
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - TableView Delegate
extension MyFavoritesVC : UITableViewDelegate, UITableViewDataSource {
    
    func registerTableviewMethod() {
        tblView.register(UINib.init(nibName: TABLE_VIEW_CELL.EventsLeaguesTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.EventsLeaguesTVC.rawValue)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoriteVM.favoriteList.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.EventsLeaguesTVC.rawValue, for: indexPath) as! EventsLeaguesTVC
        
        cell.viewDetailsBtn.isHidden = true
        cell.lineView.isHidden = false
        cell.favBtn.isHidden = false
        
        cell.eventNameLbl.text = FavoriteVM.favoriteList.value[indexPath.row].name
        cell.addressLbl.text = FavoriteVM.favoriteList.value[indexPath.row].location?.address
        cell.dateLbl.text = FavoriteVM.favoriteList.value[indexPath.row].startDateText + " - " + FavoriteVM.favoriteList.value[indexPath.row].endDateText
        cell.eventImageView.downloadCachedImage(placeholder: PLACEHOLDER.profile_img.getValue(), urlString: AppImageUrl.average + (FavoriteVM.favoriteList.value[indexPath.row].images.first ?? ""))
        
        cell.favBtn.tag = indexPath.row
        cell.favBtn.addTarget(self, action: #selector(updateFavStatusBtnIsPressed), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: EventDetailVC = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.EventDetailVC.rawValue) as! EventDetailVC
        vc.eventRef = FavoriteVM.favoriteList.value[indexPath.row].id
        vc.FavoriteVM = self.FavoriteVM
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - updateFavStatusBtnIsPressed
    @objc func updateFavStatusBtnIsPressed(_ sender: UIButton) {
        eventRef = FavoriteVM.favoriteList.value[sender.tag].id
        let request = AddFavoriteRequest(eventRef: eventRef, status: false)
        updateFavouriteVM.updateFavourite(request: request)
    }
}
