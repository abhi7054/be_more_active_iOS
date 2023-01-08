//
//  FaqVC.swift
//  BMA
//
//  Created by iMac on 12/30/20.


import UIKit

class FaqVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    private var faqVM: FaqListingViewModel = FaqListingViewModel()
    private var expandDict = [String : Bool]()
    private var isHasMore : Bool = Bool()
    private var currentPage: Int = Int()
    private var refreshControl : UIRefreshControl = UIRefreshControl.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate().sharedDelegate().hideTabBar()
    }
    
    //MARK: - configUI
    func configUI() {
        tblView.register(UINib.init(nibName: TABLE_VIEW_CELL.CustomQuestionTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.CustomQuestionTVC.rawValue)
        
        currentPage = 1
        isHasMore = false
        faqVM.fetchFaqListing(request: MorePageRequest(page: currentPage))
        
        faqVM.hasMore.bind { [weak self](_) in
            guard let `self` = self else { return }
            self.isHasMore = self.faqVM.hasMore.value
        }
        
        faqVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.faqVM.success.value {
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }
        
        refreshControllSetup()
    }
    
    //MARK: - Refresh controll setup
    func refreshControllSetup() {
        refreshControl.addTarget(self, action: #selector(refreshDataSetUp) , for: .valueChanged)
        tblView.refreshControl = refreshControl
    }
    
    //MARK: - Refresh data
    @objc func refreshDataSetUp() {
        refreshControl.endRefreshing()
        currentPage = 1
        isHasMore = false
        faqVM.fetchFaqListing(request: MorePageRequest(page: currentPage))
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension FaqVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqVM.list.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.CustomQuestionTVC.rawValue, for: indexPath) as? CustomQuestionTVC
        else {
            return UITableViewCell()
        }
        cell.questionLbl.text = faqVM.list.value[indexPath.row].question
        cell.answerLbl.text = faqVM.list.value[indexPath.row].answer
        cell.questionBtn.tag = indexPath.row
        cell.questionBtn.addTarget(self, action: #selector(self.clickToExpandCell), for: .touchUpInside)
        if let value = expandDict[String(indexPath.row)], value == true {
            cell.questionBtn.isSelected = true
            cell.answerView.isHidden = false
        }
        else {
            cell.questionBtn.isSelected = false
            cell.answerView.isHidden = true
        }
        
        cell.bottomBorderView.backgroundColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == faqVM.list.value.count - 2 && isHasMore {
            currentPage += 1
            faqVM.fetchFaqListing(request: MorePageRequest(page: currentPage))
        }
    }
    
    @objc func clickToExpandCell(_ sender : UIButton) {
        if let value = expandDict[String(sender.tag)] {
            expandDict[String(sender.tag)] = !value
        }
        else {
            expandDict[String(sender.tag)] = true
        }
        DispatchQueue.main.async { [weak self] in
            self?.tblView.reloadData()
        }
    }
}
