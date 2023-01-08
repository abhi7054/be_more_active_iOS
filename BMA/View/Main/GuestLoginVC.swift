//
//  GuestLoginVC.swift
//  BMA
//
//  Created by iMac on 19/07/21.
//

import UIKit

class GuestLoginVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var loginGuestBtn: UIButton!
    @IBOutlet weak var signupGuestBtn: UIButton!
    
    var isRootVC: Bool = Bool()
    var headerName: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isRootVC {
            AppDelegate().sharedDelegate().showTabBar()
        }
        else {
            AppDelegate().sharedDelegate().hideTabBar()
        }
    }
    
    //MARK: - configUI
    private func configUI() {
        loginGuestBtn.sainiCornerRadius(radius: 10)
        signupGuestBtn.sainiCornerRadius(radius: 10)
        
        if isRootVC {
            backBtn.isHidden = true
            headerLbl.isHidden = false
            headerLbl.text = headerName
        }
        else {
            backBtn.isHidden = false
            headerLbl.isHidden = true
        }
        
    }
    
    
    @IBAction func clickToGuestLogin(_ sender: Any) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        vc.isFromGuestLogin = true
        vc.isSignUp = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func clickToGuestSignup(_ sender: Any) {
        let vc = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        vc.isFromGuestLogin = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
