//
//  SubscriptionVC.swift
//  BMA
//
//  Created by MACBOOK on 02/07/21.
//

import UIKit

class SubscriptionVC: UIViewController {
    
    private var subscriptionVM: SubscriptionViewModel = SubscriptionViewModel()
    private var selectedSub: SELECTED_SUB = .monthly
    var userFrom: USER_FROM = .login
    
    var calendarEventsVM: CalendarEventsViewModel = CalendarEventsViewModel()
    var myEventListVM: EventsLeaguesViewModel = EventsLeaguesViewModel()
    
    //MARK: - OUTLETS
    @IBOutlet weak var subscriptionDurationLbl: UILabel!
    @IBOutlet weak var cardBtn: UIButton!
    @IBOutlet weak var subsciptionTypeLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var featuresTableView: UITableView!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var headingCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate().sharedDelegate().hideTabBar()
    }
    
    //MARK: - configUI
    private func configUI() {
        headingCollectionView.register(UINib(nibName: COLLECTION_VIEW_CELL.SubscriptionHeaderCVC.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.SubscriptionHeaderCVC.rawValue)
        featuresTableView.register(UINib(nibName: TABLE_VIEW_CELL.SubscriptionFeatureCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.SubscriptionFeatureCell.rawValue)
        setData()
        for sub in 0..<SUBSCIPTION_HEADING.headingList.count {
            SUBSCIPTION_HEADING.headingList[sub].isSelected = false
        }
        SUBSCIPTION_HEADING.headingList[0].isSelected = true
        headingCollectionView.reloadData()
        IAPService.shared.getProducts()
        IAPService.shared.delegate = self
        subscriptionVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.subscriptionVM.success.value {
                AppModel.shared.currentUser.subscription = true
                switch self.selectedSub {
                case .monthly:
                    AppModel.shared.currentUser.subscriptionType = .monthly
                case .threeMonth:
                    AppModel.shared.currentUser.subscriptionType = .threeMonth
                case .sixMonth:
                    AppModel.shared.currentUser.subscriptionType = .sixMonth
                case .annually:
                    AppModel.shared.currentUser.subscriptionType = .annually
                }
                if self.userFrom == .login {
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: CreateEvent_OneVC.self) {
                            let vc = controller as! CreateEvent_OneVC
                            vc.isFromSubscription = true
                            self.navigationController?.popToViewController(controller, animated: true)
                            break
                        }
                    }
                }
                else {
                    let vc: CreateEvent_OneVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.CreateEvent_OneVC.rawValue) as! CreateEvent_OneVC
                    vc.userFrom = self.userFrom
                    vc.isFromSubscription = true
                    vc.calendarEventsVM = self.calendarEventsVM
                    vc.eventListVM = self.myEventListVM
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
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
    }
    
    //MARK: - skipBtnIsPressed
    @IBAction func skipBtnIsPressed(_ sender: UIButton) {
        if userFrom == .login {
            AppDelegate().sharedDelegate().navigateToDashboard()
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - restoreSubscriptionBtnIsPressed
    @IBAction func restoreSubscriptionBtnIsPressed(_ sender: UIButton) {
        IAPService.shared.restorePurchases()
    }
    
    //MARK: - cardBtnPressedToPurchase
    @IBAction func cardBtnPressedToPurchase(_ sender: UIButton) {
        switch selectedSub {
        case .monthly:
            print("Monthly")
            IAPService.shared.purchase(product: .essential)
        case .threeMonth:
            print("Three months")
            IAPService.shared.purchase(product: .team)
        case .sixMonth:
            print("Six months")
            IAPService.shared.purchase(product: .corporate)
        case .annually:
            print("Annually")
            IAPService.shared.purchase(product: .enterprise)
        }
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension SubscriptionVC: UITableViewDelegate, UITableViewDataSource {
    // numberOfRowsInSection
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
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = featuresTableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.SubscriptionFeatureCell.rawValue, for: indexPath) as? SubscriptionFeatureCell else { return UITableViewCell() }
        switch selectedSub {
        case .monthly:
            cell.featureLbl.text = FEATURES_FOR_MONTHLY_SUBSCRIPTION.allCases[indexPath.row].rawValue
        case .threeMonth:
            cell.featureLbl.text = FEATURES_FOR_THREE_MONTH_SUBSCRIPTION.allCases[indexPath.row].rawValue
        case .sixMonth:
            cell.featureLbl.text = FEATURES_FOR_SIX_MONTH_SUBSCRIPTION.allCases[indexPath.row].rawValue
        case .annually:
            cell.featureLbl.text = FEATURES_FOR_ANNUAL_SUBSCRIPTION.allCases[indexPath.row].rawValue
        }
        return cell
    }
}

//MARK: - Collection View DataSource and Delegate MEthods
extension SubscriptionVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    // numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SUBSCIPTION_HEADING.headingList.count
    }
    
    // cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = headingCollectionView.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.SubscriptionHeaderCVC.rawValue, for: indexPath) as? SubscriptionHeaderCVC else {
            return UICollectionViewCell()
        }
        cell.headingLbl.text = SUBSCIPTION_HEADING.headingList[indexPath.item].name
        if SUBSCIPTION_HEADING.headingList[indexPath.item].isSelected {
            cell.selectedDotView.isHidden = false
        }
        else {
            cell.selectedDotView.isHidden = true
        }
        
        return cell
    }
    
    // didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for sub in 0..<SUBSCIPTION_HEADING.headingList.count{
            SUBSCIPTION_HEADING.headingList[sub].isSelected = false
        }
        SUBSCIPTION_HEADING.headingList[indexPath.item].isSelected = true
        switch indexPath.item {
        case 0:
            selectedSub = .monthly
        case 1:
            selectedSub = .threeMonth
        case 2:
            selectedSub = .sixMonth
        case 3:
            selectedSub = .annually
        default:
            break
        }
        DispatchQueue.main.async {
            self.featuresTableView.reloadData()
            self.headingCollectionView.reloadData()
            self.setData()
        }
    }
    
    // sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = headingCollectionView.bounds.height
        let label = UILabel(frame: CGRect.zero)
        label.text = SUBSCIPTION_HEADING.headingList[indexPath.item].name
        label.sizeToFit()
        return CGSize(width: label.frame.width + 30, height: itemHeight)
    }
     
}

//MARK: - SubscriptionSuccessDelegate
extension SubscriptionVC: SubscriptionSuccessDelegate {
    func implementApi() {
        let receiptData = IAPService.localReceiptData
        guard let receiptId = receiptData?.base64EncodedString() else { return }
        let request = SubscriptionRequest(receiptId: receiptId)
        subscriptionVM.purchasePlan(request: request)
    }
}
