//
//  RatingListVC.swift
//  BMA
//
//  Created by MACBOOK on 06/07/21.
//

import UIKit

class RatingListVC: UIViewController {
    
    private var ratingListVM: RatingListViewModel = RatingListViewModel()
    var eventRef: String = String()
    private var page: Int = Int()
    private var hasmore: Bool = Bool()
    var ratingInfo: AddRatingInfo = AddRatingInfo()

    // OUTLETS
    @IBOutlet weak var oneStarProgressiveView: UIProgressView!
    @IBOutlet weak var twoStarProgressiveView: UIProgressView!
    @IBOutlet weak var threeStarProgressiveView: UIProgressView!
    @IBOutlet weak var fourStarProgressiveView: UIProgressView!
    @IBOutlet weak var fiveStarProgressiveView: UIProgressView!
    @IBOutlet weak var leaveReviewBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var oneStarCountLbl: UILabel!
    @IBOutlet weak var twoStarCountLbl: UILabel!
    @IBOutlet weak var threeStarCountLbl: UILabel!
    @IBOutlet weak var fourStarCountLbl: UILabel!
    @IBOutlet weak var fiveStarCountLbl: UILabel!
    @IBOutlet weak var totalRatingCountLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configUI()
    }
    
    //MARK: - configUI
    private func configUI() {
        leaveReviewBtn.sainiCornerRadius(radius: 10)
        tableView.register(UINib.init(nibName: TABLE_VIEW_CELL.RatingListCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.RatingListCell.rawValue)
        
        page = 1
        hasmore = false
        let request = ListRequest(eventRef: eventRef, page: page)
        ratingListVM.fetchRatingList(request: request)
        
        ratingListVM.ratingData.bind { [weak self](_) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.renderData(info: self.ratingListVM.ratingData.value.rating)
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - renderData
    private func renderData(info: Rating) {
        totalRatingCountLbl.text = "\(String(format: "%.1f", Float(info.averageRating)))"
        fiveStarCountLbl.text = "\(info.excellent.rounded())"
        fourStarCountLbl.text = "\(info.good.rounded())"
        threeStarCountLbl.text = "\(info.average.rounded())"
        twoStarCountLbl.text = "\(info.poor.rounded())"
        oneStarCountLbl.text = "\(info.terrible.rounded())"
        
        fiveStarProgressiveView.progress = Float(info.excellent)
        fourStarProgressiveView.progress = Float(info.good)
        threeStarProgressiveView.progress = Float(info.average)
        twoStarProgressiveView.progress = Float(info.poor)
        oneStarProgressiveView.progress = Float(info.terrible)
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - leaveReviewBtnIsPressed
    @IBAction func leaveReviewBtnIsPressed(_ sender: UIButton) {
        let vc: AddRatingVC = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.AddRatingVC.rawValue) as! AddRatingVC
        vc.ratingListVM = self.ratingListVM
        vc.eventRef = self.eventRef
        vc.ratingInfo = self.ratingInfo
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension RatingListVC: UITableViewDelegate, UITableViewDataSource {
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ratingListVM.ratingData.value.list.count == DocumentDefaultValues.Empty.int {
            tableView.sainiSetEmptyMessage(STATIC_LABELS.noDataFound.rawValue)
        }
        else {
            tableView.restore()
            tableView.separatorStyle = .none
        }
        return ratingListVM.ratingData.value.list.count
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.RatingListCell.rawValue, for: indexPath) as? RatingListCell else { return UITableViewCell() }
        let ratingInfo = ratingListVM.ratingData.value.list
        cell.nameLbl.text = ratingInfo[indexPath.row].addedBy.name
        cell.starRatingView.rating = Double(ratingInfo[indexPath.row].rating)
        cell.profileImage.downloadCachedImage(placeholder: GLOBAL_IMAGES.profilePlaceHolder.rawValue, urlString: AppImageUrl.average + ratingInfo[indexPath.row].addedBy.profilePicture)
        cell.reviewLbl.text = ratingInfo[indexPath.row].review
        return cell
    }
}
