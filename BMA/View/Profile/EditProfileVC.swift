import UIKit
import SainiUtils
import GooglePlaces

class EditProfileVC: UploadImageVC {
    
    // OUTLETS
    @IBOutlet weak var changePasswordView: UIView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameTxtBackView: UIView!
    @IBOutlet weak var emailTxtBackView: UIView!
    @IBOutlet weak var passwordTxtBackView: UIView!
    @IBOutlet weak var locationTxtBackView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passWordTxt: UITextField!
    @IBOutlet weak var locationTxt: UITextField!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var selectCategoryView: UIView!
    
    var isNewProfileImg: Bool = false
    private var resetPasswordVM: ResendVerificationViewModel = ResendVerificationViewModel()
    private var UpdateUserVM: UpdateUserViewModel = UpdateUserViewModel()
    private var lat: Double = DocumentDefaultValues.Empty.double
    private var long: Double = DocumentDefaultValues.Empty.double
    private var imageData: [UploadImageInfo] = [UploadImageInfo]()
    private var selectedProfileType: Int = 0
    private var selectedCatList: [CategoryModel] = [CategoryModel]()
    var activityVM = ActivityListViewModel.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCategoryActivity), name: NSNotification.Name.init(NOTIFICATION_NAME.updateCategory.rawValue), object: nil)
        configUI()
    }
    
    func configUI() {
        UpdateUserVM.delegate = self
        resetPasswordVM.delegate = self
        saveBtn.sainiCornerRadius(radius: 10)
        profileImgView.sainiCornerRadius(radius: profileImgView.frame.height / 2)
        nameTxtBackView.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), borderWidth: 1, cornerRadius: 5)
        emailTxtBackView.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), borderWidth: 1, cornerRadius: 5)
        passwordTxtBackView.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), borderWidth: 1, cornerRadius: 5)
        locationTxtBackView.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), borderWidth: 1, cornerRadius: 5)
        selectCategoryView.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), borderWidth: 1, cornerRadius: 5)
        if isSocialUser() {
            changePasswordView.isHidden = true
        }
        else {
            changePasswordView.isHidden = false
        }
        dataRender()
    }
    
    @objc func updateCategoryActivity(_ noti: Notification) {
        if let data = noti.object as? [CategoryModel] {
            selectedCatList = data
            let arrData = selectedCatList.map({$0.name})
            categoryLbl.text = arrData.joined(separator: ", ")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate().sharedDelegate().hideTabBar()
    }
    
    @IBAction func uploadImageBtnPress(_ sender: Any) {
        uploadImage()
    }
    
    func dataRender() {
        if let user = AppModel.shared.currentUser {
            profileImgView.downloadCachedImage(placeholder: PLACEHOLDER.profile_img.getValue(), urlString: AppImageUrl.average + (user.picture))
            nameTxt.text = user.name
            emailTxt.text = user.email
            
            if user.location != nil {
                locationTxt.text = user.location?.address
                if user.location?.coordinates.count == 2 {
                    lat = user.location?.coordinates[1] as! Double
                    long = user.location?.coordinates[0] as! Double
                }
            }
            
            activityVM.getMyActivityList { data in
                var catList = data
                
                for temp in AppModel.shared.currentUser.category {
                    let index = catList.firstIndex { tempCat in
                        tempCat.id == temp
                    }
                    if index != nil {
                        catList[index!].isSelected = true
                        for tempA in AppModel.shared.currentUser.activities {
                            let index1 = catList[index!].activities.firstIndex { tempAct in
                                tempAct.id == tempA
                            }
                            if index1 != nil {
                                catList[index!].activities[index1!].isSelected = true
                            }
                        }
                        self.selectedCatList.append(catList[index!])
                    }
                }
                var arrData = [String]()
                for temp in self.selectedCatList {
                    if temp.isSelected {
                        arrData.append(temp.name)
                    }
                }
                self.categoryLbl.text = arrData.joined(separator: ", ")
            }
        }
    }
    
    //MARK: - selectedImage
    override func selectedImage(choosenImage: UIImage) {
        profileImgView.image = choosenImage
        isNewProfileImg = true
        imageData.removeAll()
        imageData.append(UploadImageInfo(name: "picture", data: compressImage(image: choosenImage), isImagePresent: true))
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSelectLocation(_ sender: Any) {
        autocompleteClicked()
    }
    
    //MARK: - changePasswordBtnIsPressed
    @IBAction func changePasswordBtnIsPressed(_ sender: UIButton) {
        guard let email = emailTxt.text else { return }
        let request = ResendVerificationRequest(email: email, requestType: VERIFICATION_TYPE.password_reset.getValue())
        resetPasswordVM.passwordConfig(request: request)
    }
    
    @IBAction func clickToActivity(_ sender: Any) {
        let vc : SelectCategoryVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.SelectCategoryVC.rawValue) as! SelectCategoryVC
        vc.selectedCatList = selectedCatList
        self.navigationController?.pushViewController(vc, animated: true)
//        let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "SelectActivitiesVC") as! SelectActivitiesVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToSave(_ sender: Any) {
        self.view.endEditing(true)
        guard let name = nameTxt.text else { return }
        var arrActivity = [String]()
        var arrCategory = [String]()
        for temp in selectedCatList {
            if temp.isSelected {
                arrCategory.append(temp.id)
                for tempA in temp.activities {
                    if tempA.isSelected {
                        arrActivity.append(tempA.id)
                    }
                }
            }
        }
        if name == "" {
            displayToast("enter_name")
        }
        else{
            var request = UpdateUserRequest()
            request.name = name
            request.activities = arrActivity
            request.categoryRef = arrCategory
            if locationTxt.text != "" {
                request.location = locationTxt.text
                request.latitude = lat
                request.longitude = long
            }
            UpdateUserVM.updateUser(imageData: imageData, updateRequest: request)
        }
    }
    
}

//MARK: - ResendVerificationDelegate
extension EditProfileVC: ResendVerificationDelegate {
    func didRecieveResendVerificationResponse(response: SuccessModel) {
        log.success(response.message)/
        showAlert(DocumentDefaultValues.Empty.string, message: STATIC_LABELS.forgotPasswordPopUpMsg.rawValue, btn: STATIC_LABELS.okBtn.rawValue) {
//            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension EditProfileVC: UpdateUserDelegate {
    func didRecieveUpdateUserResponse(response: UpdateUserResponse) {
        log.success(response.message)/
        UserDefaults.standard.set(encodable: response.data, forKey: USER_DEFAULT_KEYS.currentUser.rawValue)
        AppModel.shared.currentUser = response.data

        delay(0.1) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension EditProfileVC: GMSAutocompleteViewControllerDelegate {
    func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        autocompleteController.primaryTextColor = .black
        autocompleteController.secondaryTextColor = .gray
        autocompleteController.tableCellSeparatorColor = .gray
        autocompleteController.tableCellBackgroundColor = .white
        // Specify the place data types to return.
        autocompleteController.placeFields = GMSPlaceField(rawValue: GMSPlaceField.all.rawValue)
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if place.formattedAddress != "" {
            locationTxt.text = place.formattedAddress
            lat = place.coordinate.latitude
            long = place.coordinate.longitude
        }
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
