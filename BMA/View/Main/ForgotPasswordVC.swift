//
//  ForgotPasswordVC.swift
//  BMA
//
//  Created by MACBOOK on 29/06/21.
//

import UIKit
import SainiUtils

class ForgotPasswordVC: UIViewController {

    // OUTLETS
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var emailTextfield: UITextField!
    
    private var forgotPasswordVM: ResendVerificationViewModel = ResendVerificationViewModel()
    
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
        submitBtn.sainiCornerRadius(radius: 10)
        forgotPasswordVM.delegate = self
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - submitBtnIsPressed
    @IBAction func submitBtnIsPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let email = emailTextfield.text else { return }
        if email == DocumentDefaultValues.Empty.string {
            displayToast(STATIC_LABELS.emptyEmail.rawValue)
        }
        else if !email.isValidEmail {
            displayToast(STATIC_LABELS.notValidEmail.rawValue)
        }
        else {
            let request = ResendVerificationRequest(email: email, requestType: VERIFICATION_TYPE.password_reset.getValue())
            forgotPasswordVM.passwordConfig(request: request)
        }
        
    }

    deinit {
        log.success("ForgotPasswordVC Memory deallocated!")/
    }
}

//MARK: - ResendVerificationDelegate
extension ForgotPasswordVC: ResendVerificationDelegate {
    func didRecieveResendVerificationResponse(response: SuccessModel) {
        log.success(response.message)/
        showAlert(DocumentDefaultValues.Empty.string, message: STATIC_LABELS.forgotPasswordPopUpMsg.rawValue, btn: STATIC_LABELS.okBtn.rawValue) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
