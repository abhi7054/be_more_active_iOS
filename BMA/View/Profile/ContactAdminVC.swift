//
//  ContactAdminVC.swift
//  BMA
//
//  Created by iMac on 6/15/21.
//

import UIKit

class ContactAdminVC: UIViewController {
    
    private var contactAdminVM: ContactAdminViewModel = ContactAdminViewModel()
    
    @IBOutlet weak var messageTxt: UITextView!
    @IBOutlet weak var messageTxtUIView: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    
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
        submitBtn.sainiCornerRadius(radius: 10)
        messageTxtUIView.sainiCornerRadius(radius: 10)
        messageTxt.delegate = self
        
        contactAdminVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.contactAdminVM.success.value {
                self.navigationController?.popViewController(animated: true)
                displayToast(STATIC_LABELS.contactAdminSuccessToast.rawValue)
            }
        }
    }
    
    //MARK: - Button Click
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSubmit(_ sender: Any) {
        self.view.endEditing(true)
        guard let message = messageTxt.text else { return }
        if message == STATIC_LABELS.contactAdminPlaceholder.rawValue {
            displayToast(STATIC_LABELS.emptyQuery.rawValue)
        }
        else {
            let request = ContactAdminRequest(message: message)
            contactAdminVM.contactAdmin(request: request)
        }
    }
}

//MARK: - UITextViewDelegate
extension ContactAdminVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        messageTxt.text = DocumentDefaultValues.Empty.string
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if messageTxt.text == DocumentDefaultValues.Empty.string {
            messageTxt.text = STATIC_LABELS.contactAdminPlaceholder.rawValue
        }
    }
}
