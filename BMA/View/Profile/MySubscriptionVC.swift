//
//  MySubscriptionVC.swift
//  BMA
//
//  Created by iMac on 02/07/21.
//

import UIKit

class MySubscriptionVC: UIViewController {
    
    private var selectedSub: SELECTED_SUB = .monthly
    private var subscriptionType: SUBSCRIPTION = .monthly
    
    // OUTLETS
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var subscriptionDurationLbl: UILabel!
    @IBOutlet weak var subsciptionTypeLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var cancelSubBtn: UIButton!
    @IBOutlet weak var constraintHeightTblView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    func configUI() {
        
        cancelSubBtn.sainiCornerRadius(radius: 10)
        registerTableviewMethod()
        if let user = AppModel.shared.currentUser {
            if user.subscription {
                noDataLbl.isHidden = true
                scrollView.isHidden = false
                switch user.subscriptionType {
                case .monthly:
                    selectedSub = .monthly
                case .threeMonth:
                    selectedSub = .threeMonth
                case .sixMonth:
                    selectedSub = .sixMonth
                case .annually:
                    selectedSub = .annually
                }
                setData()
            }
            else {
                noDataLbl.isHidden = false
                scrollView.isHidden = true
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate().sharedDelegate().hideTabBar()
    }
    
    //MARK: - setData
    private func setData() {
        switch selectedSub {
        case .monthly:
            cardImage.image = #imageLiteral(resourceName: "ic_subscription_bg")
            priceLbl.text = SUBSCRIPTION_PRICE.monthly.rawValue //"$50/month"
            subsciptionTypeLbl.text = SUBSCRIPTION_TYPE.monthly.rawValue
            subscriptionDurationLbl.text = SUBSCRIPTION_DURATION.monthly.rawValue
        case .threeMonth:
            cardImage.image = #imageLiteral(resourceName: "ic_subscription_bg_gray")
            priceLbl.text = SUBSCRIPTION_PRICE.threeMonth.rawValue// "$100"
            subsciptionTypeLbl.text = SUBSCRIPTION_TYPE.threeMonth.rawValue
            subscriptionDurationLbl.text = SUBSCRIPTION_DURATION.threeMonth.rawValue
        case .sixMonth:
            cardImage.image = #imageLiteral(resourceName: "ic_subscription_bg")
            priceLbl.text = SUBSCRIPTION_PRICE.sixMonth.rawValue// "$300"
            subsciptionTypeLbl.text = SUBSCRIPTION_TYPE.sixMonth.rawValue
            subscriptionDurationLbl.text = SUBSCRIPTION_DURATION.sixMonth.rawValue
        case .annually:
            cardImage.image = #imageLiteral(resourceName: "ic_subscription_bg_gray")
            priceLbl.text = SUBSCRIPTION_PRICE.annually.rawValue // "$500"
            subsciptionTypeLbl.text = SUBSCRIPTION_TYPE.annually.rawValue
            subscriptionDurationLbl.text = SUBSCRIPTION_DURATION.annually.rawValue
        }
        updateTableHeight()
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToCancelSubscription(_ sender: Any) {
        showAlert("Cancel subscription", message: STATIC_LABELS.subscriptionPopUpMsg.rawValue, btn: STATIC_LABELS.okBtn.rawValue) {
            //            self.navigationController?.popViewController(animated: true)
        }
    }
}

//MARK: - TableView Delegate
extension MySubscriptionVC : UITableViewDelegate, UITableViewDataSource {
    
    func registerTableviewMethod() {
        tblView.register(UINib.init(nibName: TABLE_VIEW_CELL.MySubscriptionTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.MySubscriptionTVC.rawValue)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedSub {
        case .monthly:
            return FEATURES_FOR_MONTHLY_SUBSCRIPTION.allCases.count
        case .threeMonth:
            return FEATURES_FOR_THREE_MONTH_SUBSCRIPTION.allCases.count
        case .sixMonth:
            return FEATURES_FOR_SIX_MONTH_SUBSCRIPTION.allCases.count
        case .annually:
            return FEATURES_FOR_ANNUAL_SUBSCRIPTION.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.MySubscriptionTVC.rawValue, for: indexPath) as! MySubscriptionTVC
        
        switch selectedSub {
        case .monthly:
            cell.detailsLbl.text = FEATURES_FOR_MONTHLY_SUBSCRIPTION.allCases[indexPath.row].rawValue
        case .threeMonth:
            cell.detailsLbl.text = FEATURES_FOR_THREE_MONTH_SUBSCRIPTION.allCases[indexPath.row].rawValue
        case .sixMonth:
            cell.detailsLbl.text = FEATURES_FOR_SIX_MONTH_SUBSCRIPTION.allCases[indexPath.row].rawValue
        case .annually:
            cell.detailsLbl.text = FEATURES_FOR_ANNUAL_SUBSCRIPTION.allCases[indexPath.row].rawValue
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func updateTableHeight() {
        constraintHeightTblView.constant = CGFloat.greatestFiniteMagnitude
        tblView.reloadData()
        tblView.layoutIfNeeded()
        constraintHeightTblView.constant = tblView.contentSize.height
    }
}
