//
//  AddRatingVC.swift
//  BMA
//
//  Created by MACBOOK on 06/07/21.
//

import UIKit
import SainiUtils

class AddRatingVC: UIViewController {
    
    private var addRatingVM: AddRatingViewModel = AddRatingViewModel()
    var ratingListVM: RatingListViewModel = RatingListViewModel()
    var eventRef: String = String()
    var ratingInfo: AddRatingInfo = AddRatingInfo()
    
    // OUTLETS
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var starRatingView: FloatRatingView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configUI()
    }
    
    //MARK: - configUI
    private func configUI() {
        submitBtn.sainiCornerRadius(radius: 10)
        reviewTextView.delegate = self
        starRatingView.rating = DocumentDefaultValues.Empty.double
        renderData()
        
        addRatingVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.addRatingVM.success.value {
                let request = ListRequest(eventRef: self.eventRef, page: 1)
                self.ratingListVM.fetchRatingList(request: request)
                showAlert(STATIC_LABELS.reviewPopUpHeading.rawValue, message: STATIC_LABELS.reviewPopUpMsg.rawValue) {
                    // action of ok btn
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    //MARK: - renderData
    private func renderData() {
        eventImage.downloadCachedImage(placeholder: GLOBAL_IMAGES.eventPlaceHolder.rawValue, urlString: AppImageUrl.average + ratingInfo.image)
        eventNameLbl.text = ratingInfo.eventName
        locationLbl.text = ratingInfo.location
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - submitBtnIsPressed
    @IBAction func submitBtnIsPressed(_ sender: UIButton) {
        let rating = Int(starRatingView.rating)
        guard let review = reviewTextView.text else { return }
        if rating == DocumentDefaultValues.Empty.int {
            displayToast(STATIC_LABELS.emptyStarToast.rawValue)
        }
        else if review == STATIC_LABELS.reviewPlaceholder.rawValue {
            displayToast(STATIC_LABELS.emptyReview.rawValue)
        }
        else {
            let request = AddRatingRequest(eventRef: eventRef, rating: rating, review: review)
            addRatingVM.addRating(request: request)
        }
    }

}

//MARK: - UITextViewDelegate
extension AddRatingVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        reviewTextView.text = DocumentDefaultValues.Empty.string
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if reviewTextView.text == DocumentDefaultValues.Empty.string {
            reviewTextView.text = STATIC_LABELS.reviewPlaceholder.rawValue
        }
    }
}
