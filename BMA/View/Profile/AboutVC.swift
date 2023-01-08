//
//  AboutVC.swift
//  BMA
//
//  Created by iMac on 05/07/21.
//

import UIKit

class AboutVC: UIViewController {
    
    @IBOutlet weak var messageLbl: UITextView!
    @IBOutlet weak var headerLbl: UILabel!
    
    var type : SETUP_ABOUT_REDIRECTION = .ABOUT_US
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate().sharedDelegate().hideTabBar()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
    
    
    func configUI() {
        switch type {
        case .ABOUT_US:
            headerLbl.text = getTranslate("About_Us")
            messageLbl.text = AppModel.shared.appDetail.aboutUs
        case .TERMS_CONDITION:
            headerLbl.text = getTranslate("Terms_conditions")
            messageLbl.text = AppModel.shared.appDetail.termsAndConditions
        case .PRIVACY_POLICY:
            headerLbl.text = getTranslate("Privacy_policy")
            messageLbl.text = AppModel.shared.appDetail.privacyPolicy
        }
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
