//
//  BookingDetailsVC.swift
//  BMA
//
//  Created by iMac on 01/07/21.
//
import UIKit
import SainiUtils

protocol BookingCancelSuccessDelegate {
    func bookingCancelled()
}

class BookingDetailsVC: UIViewController {
    
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var ratingReviewView: UIView!
    @IBOutlet weak var contactDetailView: UIView!
    @IBOutlet weak var couponDetailView: UIView!
    @IBOutlet weak var viewAllMembersBtn: UIButton!
    @IBOutlet weak var imageCV: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var eventInfoView: UIView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var eventDescriptionLbl: UILabel!
    @IBOutlet weak var dateAndTimeLbl: UILabel!
    @IBOutlet weak var eventLocationLbl: UILabel!
    @IBOutlet weak var eventCategoryLbl: UILabel!
    @IBOutlet weak var eventActivityLbl: UILabel!
    @IBOutlet weak var instagramUrlView: UIView!
    @IBOutlet weak var instagramUrlLbl: UILabel!
    @IBOutlet weak var facebookUrlView: UIView!
    @IBOutlet weak var facebookUrlLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var memberJoinedLbl: UILabel!
    @IBOutlet weak var seatLeftLbl: UILabel!
    @IBOutlet weak var cancelBookingBtn: UIButton!
    
    var eventRef: String = String()
    var userRef: String = String()
    var BookingDetailsVM : MyBookingDetailsViewModel = MyBookingDetailsViewModel()
    var bookingDetails : BookingDetailsModel = BookingDetailsModel()
    var BookingCancelVM : MyBookingCancelViewModel = MyBookingCancelViewModel()
    private var lat: Double = DocumentDefaultValues.Empty.double
    private var long: Double = DocumentDefaultValues.Empty.double
    var notificationRef: String = ""
    var bookingCancelled: BookingCancelSuccessDelegate?
    private var ratingInfo: AddRatingInfo = AddRatingInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate().sharedDelegate().hideTabBar()
    }
    
    func configUI() {
        registerCollectionViewMethod()
        BookingCancelVM.delegate = self
        BookingDetailsVM.delegate = self
        designSetup()
        let request = MyBookingDetailsRequest(eventRef: eventRef, userRef: userRef)
        BookingDetailsVM.MyBookingDetails(request: request)
    }
    
    func designSetup()  {
        statusView.sainiShadow(shadowColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), shadowOpacity: 0.2, shadowRadius: 30)
        statusView.layer.cornerRadius = 30
        statusView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        detailsView.sainiShadowWithCornerRadius(shadowColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), shadowOpacity: 0.2, shadowRadius: 20, cornerRadius: 20)
        eventInfoView.sainiShadowWithCornerRadius(shadowColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), shadowOpacity: 0.2, shadowRadius: 20, cornerRadius: 20)
    }
    
    //MARK: - contactDetailBtnIsPressed
    @IBAction func contactDetailBtnIsPressed(_ sender: UIButton) {
        let vc: DetailsVC = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.DetailsVC.rawValue) as! DetailsVC
        vc.detailType = .contact
        vc.contactDetail = bookingDetails.contactDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - couponDetailBtnIsPressed
    @IBAction func couponDetailBtnIsPressed(_ sender: UIButton) {
        let vc: DetailsVC = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.DetailsVC.rawValue) as! DetailsVC
        vc.detailType = .coupon
        vc.couponCode = bookingDetails.couponCode
        vc.couponDes = bookingDetails.couponDescription
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Button click event
    @IBAction func clickToEventLocation(_ sender: Any) {
        
    }
    
    @IBAction func clickToInstagramUrl(_ sender: Any) {
        openUrlInSafari(strUrl: bookingDetails.instagramURL)
    }
    
    @IBAction func clickToFacebookUrl(_ sender: Any) {
        openUrlInSafari(strUrl: bookingDetails.facebookURL)
    }
    
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToRatingViewAll(_ sender: Any) {
        let vc: RatingListVC = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.RatingListVC.rawValue) as! RatingListVC
        vc.eventRef = self.eventRef
        vc.ratingInfo = self.ratingInfo
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToMemberViewAll(_ sender: Any) {
        let vc: MembersJoinedVC = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.MembersJoinedVC.rawValue) as! MembersJoinedVC
        vc.eventRef = self.eventRef
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToCancelBooking(_ sender: Any) {
        showAlertWithOption("Cancel Booking", message: "Hey, Are you sure you want to cancel this event.", btns: ["Yes", "No"], completionConfirm: {
            self.BookingCancelVM.MyBookingCancel(request: MyBookingaCancelRequest(eventRef: self.eventRef))
        }) {
        }
    }
}

extension BookingDetailsVC : MyBookingCancelDelegate {
    func didRecieveBookingCancelResponse(response: SuccessModel) {
        bookingCancelled?.bookingCancelled()
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - MyBookingDetailsDelegate
extension BookingDetailsVC : MyBookingDetailsDelegate {
    
    func didRecieveMyBookingDetailsResponse(response: BookingDetailsResponse) {
        bookingDetails = response.data ?? BookingDetailsModel()
        renderBookingDetail()
    }
    
    //MARK: - renderBookingDetail
    func renderBookingDetail() {
        eventNameLbl.text = bookingDetails.name
        eventDescriptionLbl.text = bookingDetails.dataDescription
        dateAndTimeLbl.text = getDateStringFromDateString(strDate: bookingDetails.startDate, format: DATE_FORMATS.ddMMMyyyy.rawValue) + " - " + getDateStringFromDateString(strDate: bookingDetails.startTime, format: DATE_FORMATS.time.rawValue)
        eventLocationLbl.text = bookingDetails.location.address
        eventCategoryLbl.text = bookingDetails.categoryName
        eventActivityLbl.text = bookingDetails.activityName
        if bookingDetails.instagramURL.isEmpty {
            instagramUrlView.isHidden = true
        }
        if bookingDetails.facebookURL.isEmpty {
            facebookUrlView.isHidden = true
        }
        instagramUrlLbl.text = bookingDetails.instagramURL
        facebookUrlLbl.text = bookingDetails.facebookURL
        ratingLbl.text = String(bookingDetails.rating)
        memberJoinedLbl.text = String(bookingDetails.memberJoined)
        seatLeftLbl.text = String(bookingDetails.seats - bookingDetails.memberJoined)
        pageControl.numberOfPages = bookingDetails.images.count
        if !bookingDetails.images.isEmpty {
            imageCV.reloadData()
        }
        
        statusLbl.text = "Status - " + getEventStatus(bookingDetails.status).0
        statusImage.image = getEventStatus(bookingDetails.status).2
        if bookingDetails.userRef == AppModel.shared.currentUser.id {
            cancelBookingBtn.isHidden = true
        }
        else {
            switch bookingDetails.status {
            case 2:
                cancelBookingBtn.isHidden = false
                break
            case 1,3,4:
                cancelBookingBtn.isHidden = true
                break
            default:
                break
            }
        }
        
        if AppModel.shared.currentUser.id == bookingDetails.userRef {
            viewAllMembersBtn.isHidden = false
        }
        else {
            viewAllMembersBtn.isHidden = true
        }
        if bookingDetails.coupons {
            couponDetailView.isHidden = false
        } else {
            couponDetailView.isHidden = true
        }
        if bookingDetails.reviews {
            ratingReviewView.isHidden = false
        } else {
            ratingReviewView.isHidden = true
        }
        if bookingDetails.images.count > DocumentDefaultValues.Empty.int {
            ratingInfo = AddRatingInfo(eventName: bookingDetails.name, image: bookingDetails.images[0], location: bookingDetails.location.address)
        }
    }
}

//MARK:- Collection View
extension BookingDetailsVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    func registerCollectionViewMethod() {
        imageCV.register(UINib(nibName: COLLECTION_VIEW_CELL.ImageCVC.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTION_VIEW_CELL.ImageCVC.rawValue)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookingDetails.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = imageCV.dequeueReusableCell(withReuseIdentifier: COLLECTION_VIEW_CELL.ImageCVC.rawValue, for: indexPath) as? ImageCVC else {
            return UICollectionViewCell()
        }
        cell.imgView.downloadCachedImage(placeholder: PLACEHOLDER.profile_img.getValue(), urlString: AppImageUrl.average + (bookingDetails.images[indexPath.row]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        displayFullScreenImage(bookingDetails.images, indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: imageCV.frame.size.width, height: imageCV.frame.size.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.imageCV.contentOffset, size: self.imageCV.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.imageCV.indexPathForItem(at: visiblePoint) {
            self.pageControl.currentPage = visibleIndexPath.row
        }
    }
}
