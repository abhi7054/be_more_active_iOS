//
//  DetailsVC.swift
//  BMA
//
//  Created by MACBOOK on 05/07/21.
//

import UIKit

class DetailsVC: UIViewController {
    
    var detailType: DETAIL_TYPE = .contact
    var contactDetail: ContactDetails = ContactDetails()
    var couponCode: String = String()
    var couponDes: String = String()

    // OUTLETS
    @IBOutlet weak var couponDescriptionLbl: UILabel!
    @IBOutlet weak var couponLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phnNumberLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var contactDetailView: UIView!
    @IBOutlet weak var couponDetailView: UIView!
    @IBOutlet weak var headingLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configUI()
    }
    
    //MARK: - configUI
    private func configUI() {
        switch detailType {
        case .contact:
            headingLbl.text = STATIC_LABELS.contactDetail.rawValue
            couponDetailView.isHidden = true
            contactDetailView.isHidden = false
            renderContactDetails()
        case .coupon:
            headingLbl.text = STATIC_LABELS.couponDetail.rawValue
            couponDetailView.isHidden = false
            contactDetailView.isHidden = true
            renderCouponDetails()
        }
    }
    
    //MARK: - renderContactDetails
    private func renderContactDetails() {
        nameLbl.text = contactDetail.name
        phnNumberLbl.text = STATIC_LABELS.usCode.rawValue + contactDetail.phoneNumber
        emailLbl.text = contactDetail.email
    }
    
    //MARK: - renderContactDetails
    private func renderCouponDetails() {
        couponLbl.text = couponCode
        couponDescriptionLbl.text = couponDes
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
