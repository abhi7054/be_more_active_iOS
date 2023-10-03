//
//  EventDetailVC.swift
//  BMA
//
//  Created by MACBOOK on 05/07/21.
//

import UIKit
import SainiUtils

class EventDetailVC: UIViewController {
    
    private var eventDetailVM: EventDetailViewModel = EventDetailViewModel()
    private var bookEventVM: BookEventViewModel = BookEventViewModel()
    private var updateFavouriteVM: AddFavouriteViewModel = AddFavouriteViewModel()
    private var deleteEventVM: DeleteEventViewModel = DeleteEventViewModel()
    var eventListVM: EventsLeaguesViewModel = EventsLeaguesViewModel()
    var  FavoriteVM : FavoriteListViewModel = FavoriteListViewModel()
    
    var eventRef: String = String()
    private var ratingInfo: AddRatingInfo = AddRatingInfo()
    
    //OUTLETS
    @IBOutlet weak var heightConstraintOfLocView: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintOfDesView: NSLayoutConstraint!
    @IBOutlet weak var fbUrlView: UIView!
    @IBOutlet weak var instaUrlView: UIView!
    @IBOutlet weak var viewAllMemberListBtn: UIButton!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var favBtnLbl: UILabel!
    @IBOutlet weak var bookEventBtn: UIButton!
    @IBOutlet weak var bookBtnEventView: UIView!
    @IBOutlet weak var couponView: UIView!
    @IBOutlet weak var ratingReviewView: UIView!
    @IBOutlet weak var reviewCountLbl: UILabel!
    @IBOutlet weak var vacantSeatsLbl: UILabel!
    @IBOutlet weak var membersJoinedLbl: UILabel!
    @IBOutlet weak var fbUrlLbl: UILabel!
    @IBOutlet weak var instaUrlLbl: UILabel!
    @IBOutlet weak var eventActivityLbl: UILabel!
    @IBOutlet weak var eventCategoryLbl: UILabel!
    @IBOutlet weak var eventLocationLbl: UILabel!
    @IBOutlet weak var eventTimeLbl: UILabel!
    @IBOutlet weak var eventDateLbl: UILabel!
    @IBOutlet weak var heightConstraintOfEventDesView: NSLayoutConstraint!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        bookEventBtn.sainiCornerRadius(radius: 10)
        collectionView.register(UINib(nibName: COLLECTION_VIEW_CELL.ImageCVC.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.ImageCVC.rawValue)
        
        let request = EventDetailRequest(eventRef: eventRef)
        eventDetailVM.fetchEventDetail(request: request)
        
        eventDetailVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.eventDetailVM.success.value {
                self.renderEventDetail(data: self.eventDetailVM.eventDetail.value)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        
        eventDetailVM.eventDetail.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.eventDetailVM.eventDetail.value.id != DocumentDefaultValues.Empty.string {
                self.renderEventDetail(data: self.eventDetailVM.eventDetail.value)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        
        bookEventVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.bookEventVM.success.value {
                showAlert(STATIC_LABELS.eventBookPopUpHeading.rawValue, message: STATIC_LABELS.eventBookPopUpMsg.rawValue, btn: STATIC_LABELS.okBtn.rawValue) {
                openUrlInSafari(strUrl: self.eventDetailVM.eventDetail.value.websiteURL)
                self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        updateFavouriteVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.updateFavouriteVM.success.value {
                self.eventDetailVM.eventDetail.value.isFav = !self.favouriteBtn.isSelected
                self.favouriteBtn.isSelected = self.eventDetailVM.eventDetail.value.isFav
                if self.eventDetailVM.eventDetail.value.isFav {
                    self.favBtnLbl.text = STATIC_LABELS.unFavourite.rawValue
                    displayToast(STATIC_LABELS.favToast.rawValue)
                }
                else {
                    self.FavoriteVM.removeFav(removeAt: self.eventRef)
                    self.favBtnLbl.text = STATIC_LABELS.favourite.rawValue
                    displayToast(STATIC_LABELS.unfavToast.rawValue)
                }
            }
        }
        
        deleteEventVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.deleteEventVM.success.value {
                self.eventListVM.deleteEventLocally(eventRef: self.eventRef)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    //MARK: - renderEventDetail
    private func renderEventDetail(data: EventDetail) {
        if AppModel.shared.isGuestUser {
            AppModel.shared.guestUserType = .eventDetails
            bookBtnEventView.isHidden = false
            viewAllMemberListBtn.isHidden = true
        } else {
            if AppModel.shared.currentUser.id == data.userRef {
                bookBtnEventView.isHidden = true
                viewAllMemberListBtn.isHidden = false
            }
            else {
                bookBtnEventView.isHidden = false
                viewAllMemberListBtn.isHidden = true
            }
        }
        if data.coupons {
            couponView.isHidden = false
        } else {
            couponView.isHidden = true
        }
        if data.reviews {
            ratingReviewView.isHidden = false
        } else {
            ratingReviewView.isHidden = true
        }
        pageControl.numberOfPages = data.images.count
        favouriteBtn.isSelected = data.isFav
        if self.eventDetailVM.eventDetail.value.isFav {
            self.favBtnLbl.text = STATIC_LABELS.unFavourite.rawValue
        }
        else {
            self.favBtnLbl.text = STATIC_LABELS.favourite.rawValue
        }
        eventNameLbl.text = data.name
        descriptionLbl.text = data.datumDescription
        eventLocationLbl.text = data.location.address
        let heightOfdesView = (descriptionLbl.text?.height(withConstrainedWidth: descriptionLbl.frame.width, font: UIFont(name: APP_FONT.regular.rawValue, size: 14)!))
        heightConstraintOfDesView.constant = 52 + CGFloat(heightOfdesView ?? 0)
        
        let heightOfLocView = (eventLocationLbl.text?.height(withConstrainedWidth: eventLocationLbl.frame.width, font: UIFont(name: APP_FONT.regular.rawValue, size: 14)!))
        heightConstraintOfLocView.constant = 52 + CGFloat(heightOfLocView ?? 0)
        
        let startDate = getDateStringFromDateString(strDate: data.startDate, format: DATE_FORMATS.ddMMMyyyy.rawValue)
        let endDate = getDateStringFromDateString(strDate: data.endDate, format: DATE_FORMATS.ddMMMyyyy.rawValue)
        eventDateLbl.text = startDate + " - " + endDate
        let startTime = getDateStringFromDateString(strDate: data.startTime, format: DATE_FORMATS.time.rawValue)
        let endTime = getDateStringFromDateString(strDate: data.endTime, format: DATE_FORMATS.time.rawValue)
        eventTimeLbl.text = startTime + " - " + endTime
        eventCategoryLbl.text = data.categoryName
        eventActivityLbl.text = data.activityName
        if data.instagramURL == DocumentDefaultValues.Empty.string {
            instaUrlView.isHidden = true
        } else {
            instaUrlView.isHidden = false
            instaUrlLbl.text = data.instagramURL
        }
        if data.instagramURL == DocumentDefaultValues.Empty.string {
            fbUrlView.isHidden = true
        } else {
            fbUrlView.isHidden = false
            fbUrlLbl.text = data.facebookURL
        }
        
        reviewCountLbl.text = "\(data.rating)"
        membersJoinedLbl.text = "\(data.memberJoined)"
        vacantSeatsLbl.text = "\(data.seats - data.memberJoined)"
        if data.images.count > DocumentDefaultValues.Empty.int {
            ratingInfo = AddRatingInfo(eventName: data.name, image: data.images[0], location: data.location.address)
        }
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - threeDotBtnIsPressed
    @IBAction func threeDotBtnIsPressed(_ sender: UIButton) {
        if AppModel.shared.isGuestUser {
            AppModel.shared.guestUserType = .explore
            AppDelegate().sharedDelegate().continueToGuestLogin(isRootVC: false, headingName: "Event Detail")
        } else {
            let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cancelButton = UIAlertAction(title: STATIC_LABELS.cancel.rawValue, style: .cancel) { _ in
                log.result(STATIC_LABELS.cancel.rawValue)/
            }
            actionSheet.addAction(cancelButton)
            
            if AppModel.shared.currentUser.id == eventDetailVM.eventDetail.value.userRef {
                let editBtn = UIAlertAction(title: STATIC_LABELS.edit.rawValue, style: .default)
                { _ in
                    log.result(STATIC_LABELS.edit.rawValue)/
                    let vc: CreateEvent_OneVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.CreateEvent_OneVC.rawValue) as! CreateEvent_OneVC
                    vc.userFrom = .eventDetail
                    vc.eventListVM = self.eventListVM
                    vc.eventDetailVM = self.eventDetailVM
                    vc.isFromSubscription = false
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                actionSheet.addAction(editBtn)
                let deleteBtn = UIAlertAction(title: STATIC_LABELS.delete.rawValue, style: .default)
                { _ in
                    log.result(STATIC_LABELS.delete.rawValue)/
                    showAlertWithOption(STATIC_LABELS.eventDeletePopUpHeading.rawValue, message: STATIC_LABELS.eventDeletePopUpMsg.rawValue, btns: [STATIC_LABELS.yesBtn.rawValue, STATIC_LABELS.noBtn.rawValue]) {
                        let request = EventDetailRequest(eventRef: self.eventRef)
                        self.deleteEventVM.deleteEvent(request: request)
                    } completionCancel: {
                    }
                }
                actionSheet.addAction(deleteBtn)
            }
            else {
                let reportBtn = UIAlertAction(title: STATIC_LABELS.report.rawValue, style: .default)
                { _ in
                    log.result(STATIC_LABELS.report.rawValue)/
                    let vc: ReportVC = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.ReportVC.rawValue) as! ReportVC
                    vc.eventRef = self.eventRef
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                actionSheet.addAction(reportBtn)
            }
            
            actionSheet.popoverPresentationController?.sourceView = self.view
            actionSheet.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            actionSheet.popoverPresentationController?.permittedArrowDirections = []
            actionSheet.view.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    //MARK: - contactDetailBtnIsPressed
    @IBAction func contactDetailBtnIsPressed(_ sender: UIButton) {
        if AppModel.shared.isGuestUser {
            AppModel.shared.guestUserType = .explore
            AppDelegate().sharedDelegate().continueToGuestLogin(isRootVC: false, headingName: "Event Detail")
        } else {
            let vc: DetailsVC = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.DetailsVC.rawValue) as! DetailsVC
            vc.detailType = .contact
            vc.contactDetail = eventDetailVM.eventDetail.value.contactDetails
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - favouriteBtnIsPressed
    @IBAction func favouriteBtnIsPressed(_ sender: UIButton) {
        if AppModel.shared.isGuestUser {
            AppModel.shared.guestUserType = .explore
            AppDelegate().sharedDelegate().continueToGuestLogin(isRootVC: false, headingName: "Event Detail")
        } else {
            let request = AddFavoriteRequest(eventRef: eventRef, status: !favouriteBtn.isSelected)
            updateFavouriteVM.updateFavourite(request: request)
        }
    }
    
    //MARK: - couponDetailBtnIsPressed
    @IBAction func couponDetailBtnIsPressed(_ sender: UIButton) {
        if AppModel.shared.isGuestUser {
            AppModel.shared.guestUserType = .explore
            AppDelegate().sharedDelegate().continueToGuestLogin(isRootVC: false, headingName: "Event Detail")
        } else {
            let vc: DetailsVC = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.DetailsVC.rawValue) as! DetailsVC
            vc.detailType = .coupon
            vc.couponCode = eventDetailVM.eventDetail.value.couponCode
            vc.couponDes = eventDetailVM.eventDetail.value.couponDescription
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - viewAllRatingsAndReviewsBtnIsPressed
    @IBAction func viewAllRatingsAndReviewsBtnIsPressed(_ sender: UIButton) {
        if AppModel.shared.isGuestUser {
            AppModel.shared.guestUserType = .explore
            AppDelegate().sharedDelegate().continueToGuestLogin(isRootVC: false, headingName: "Event Detail")
        } else {
            let vc: RatingListVC = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.RatingListVC.rawValue) as! RatingListVC
            vc.eventRef = self.eventRef
            vc.ratingInfo = self.ratingInfo
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - viewAllJoinedMembersBtnIsPressed
    @IBAction func viewAllJoinedMembersBtnIsPressed(_ sender: UIButton) {
        let vc: MembersJoinedVC = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.MembersJoinedVC.rawValue) as! MembersJoinedVC
        vc.eventRef = self.eventRef
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - bookOrJoinEventBtnIsPressed
    @IBAction func bookOrJoinEventBtnIsPressed(_ sender: UIButton) {
        if AppModel.shared.isGuestUser {
            AppModel.shared.guestUserType = .explore
            AppDelegate().sharedDelegate().continueToGuestLogin(isRootVC: false, headingName: "Event Detail")
        } else {
            let request = BookEventRequest(eventRef: eventRef)
            bookEventVM.bookEvent(request: request)
        }
    }
}

//MARK:- Collection View DataSource and Delegate MEthods
extension EventDetailVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    // numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventDetailVM.eventDetail.value.images.count
    }
    
    // cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.ImageCVC.rawValue, for: indexPath) as? ImageCVC else {
            return UICollectionViewCell()
        }
        print(AppImageUrl.average + eventDetailVM.eventDetail.value.images[indexPath.row])
        cell.imgView.downloadCachedImage(placeholder: GLOBAL_IMAGES.eventPlaceHolder.rawValue, urlString: AppImageUrl.average + eventDetailVM.eventDetail.value.images[indexPath.row])
        return cell
    }
    
    // sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        return CGSize(width: width, height: height)
    }
}

//MARK: - scrollViewDidScroll
extension EventDetailVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.collectionView.contentOffset, size: self.collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.collectionView.indexPathForItem(at: visiblePoint) {
            self.pageControl.currentPage = visibleIndexPath.row
        }
    }
}
