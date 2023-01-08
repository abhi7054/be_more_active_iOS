//
//  RegisterVC.swift
//  BMA
//
//  Created by MACBOOK on 29/06/21.
//

import UIKit
import SainiUtils

class RegisterVC: UIViewController {
    
    // OUTLETS
    @IBOutlet weak var termsLbl: UILabel!
    @IBOutlet weak var termsCheckBtn: UIButton!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var selectCategoryView: UIView!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var firstNameTextfield: UITextField!
    
    private var signUpVM : SignUpViewModel = SignUpViewModel()
    private var catList: [CategoryModel] = [CategoryModel]()
    var isFromGuestLogin = false
    private var categoryRef: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(updateCategoryActivity), name: NSNotification.Name.init(NOTIFICATION_NAME.updateCategory.rawValue), object: nil)
        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate().sharedDelegate().hideTabBar()
    }
    
    //MARK: - configUI
    private func configUI() {
        signUpBtn.sainiCornerRadius(radius: 10)
        selectCategoryView.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1), borderWidth: 1, cornerRadius: 5)
        signUpVM.delegate = self
        termsGesture()
    }
    
    @objc func updateCategoryActivity(_ noti: Notification) {
        if let data = noti.object as? [CategoryModel] {
            catList = data
            let arrData = catList.map({$0.name})
            categoryLbl.text = arrData.joined(separator: ", ")
        }
    }
    
    //MARK: - termsGesture
    private func termsGesture(){
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:)))
        termsLbl.isUserInteractionEnabled = true
        termsLbl.addGestureRecognizer(tapAction)
    }
    
    //MARK: - tapLabel
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
         let text = (termsLbl.text)!
         let termsRange = (text as NSString).range(of: "Terms of Service")

         if gesture.didTapAttributedTextInLabel(label: termsLbl, inRange: termsRange) {
            guard let url = URL(string: "https://beemoreactive.wixsite.com/beemoreactive/copy-of-policies") else {
                return
            }
             if #available(iOS 10.0, *) {
                 UIApplication.shared.open(url, options: [:], completionHandler: nil)
             } else {
                 UIApplication.shared.openURL(url)
             }
         } else {
             print("Tapped none")
         }
     }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - termsCheckBtnIsPressed
    @IBAction func termsCheckBtnIsPressed(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    //MARK: - signUpBtnIsPressed
    @IBAction func signUpBtnIsPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let firstName = firstNameTextfield.text  else { return }
        guard let email = emailTextfield.text else { return }
        guard let password = passwordTextfield.text else { return }
        guard let confirmPassword = confirmPasswordTextfield.text else { return }
        var arrActivity = [String]()
        var arrCategory = [String]()
        for temp in catList {
            if temp.isSelected {
                arrCategory.append(temp.id)
                for tempA in temp.activities {
                    if tempA.isSelected {
                        arrActivity.append(tempA.id)
                    }
                }
            }
        }
        if firstName == DocumentDefaultValues.Empty.string {
            displayToast(STATIC_LABELS.emptyUserName.rawValue)
        }
        else if email == DocumentDefaultValues.Empty.string {
            displayToast(STATIC_LABELS.emptyEmail.rawValue)
        }
        else if !email.isValidEmail {
            displayToast(STATIC_LABELS.notValidEmail.rawValue)
        }
        else if password == DocumentDefaultValues.Empty.string {
            displayToast(STATIC_LABELS.emptyPassword.rawValue)
        }
        else if confirmPassword == DocumentDefaultValues.Empty.string {
            displayToast(STATIC_LABELS.emptyConfirmPassword.rawValue)
        }
        else if password != confirmPassword {
            displayToast(STATIC_LABELS.passwordNotMatch.rawValue)
        }
        else if arrActivity.count == 0 {
            displayToast(STATIC_LABELS.emptyCategoryActivity.rawValue)
        }
        else if !termsCheckBtn.isSelected {
            displayToast(STATIC_LABELS.termsCheckToast.rawValue)
        }
        else {
            let signUpRequest = SignupRequest(email: email, name: firstName, password: password, device: AppModel.shared.device, categoryRef: arrCategory, fcmToken: getPushToken(), activities: arrActivity)
            signUpVM.signUpUser(signUpRequest: signUpRequest)
            
        }
        
    }
    
    //MARK: - eyeBtnOfPasswordIsPressed
    @IBAction func eyeBtnOfPasswordIsPressed(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            passwordTextfield.isSecureTextEntry = true
        }
        else {
            sender.isSelected = true
            passwordTextfield.isSecureTextEntry = false
        }
    }
    
    //MARK: - eyeBtnOfConfirmPasswordIsPressed
    @IBAction func eyeBtnOfConfirmPasswordIsPressed(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            confirmPasswordTextfield.isSecureTextEntry = true
        }
        else {
            sender.isSelected = true
            confirmPasswordTextfield.isSecureTextEntry = false
        }
    }
    
    //MARK: - alreadyHaveAccountBtnIsPressed
    @IBAction func alreadyHaveAccountBtnIsPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        log.success("RegisterVC Memory deallocated!")/
    }

    //MARK: - selectCategoryBtnIsPressed
    @IBAction func selectCategoryBtnIsPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let vc : SelectCategoryVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.SelectCategoryVC.rawValue) as! SelectCategoryVC
        vc.selectedCatList = catList
        self.navigationController?.pushViewController(vc, animated: true)
        
//        let list = catList.map({ $0.name })
//        PickerManager.shared.showPicker(title: "", selected: "", strings: list) { [weak self](category, index, success) in
//            guard let `self` = self else { return }
//            if category != nil {
//                self.categoryLbl.text = category
//                self.categoryRef = self.catList[index].id
//            }
//        }
    }
}

//MARK: - SignUpDelegate
extension RegisterVC: SignUpDelegate {
    func didRecieveSignUpResponse(response: SuccessModel) {
        showAlert(DocumentDefaultValues.Empty.string, message: STATIC_LABELS.registerPopUpMsg.rawValue, btn: STATIC_LABELS.okBtn.rawValue) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
