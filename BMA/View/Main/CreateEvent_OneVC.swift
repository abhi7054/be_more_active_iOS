//
//  CreateEvent_OneVC.swift
//  BMA
//
//  Created by MACBOOK on 30/06/21.
//

import UIKit
import SainiUtils
import GooglePlaces

class CreateEvent_OneVC: UploadImageVC {
    
    private var uploadImageVM: UploadImageViewModel = UploadImageViewModel()
    private var deleteImageVM: DeleteImageViewModel = DeleteImageViewModel()
    var activityListVM : ActivityListViewModel = ActivityListViewModel()
    var userFrom: USER_FROM = .login
    private var imagePosition: Int = Int()
    private var imageArr: [UploadImageInfo] = [UploadImageInfo]()
    private var selectedImages: [String] = [String]()
    private var addEventRequest: AddEventRequest?
    private var catList: [CategoryListModel] = [CategoryListModel]()
    private var activityList: [CategoryListModel] = [CategoryListModel]()
    private var categoryRef: String = String()
    private var activityRef: String = String()
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0
    private var deletedImage: String = String()
    
    var calendarEventsVM: CalendarEventsViewModel = CalendarEventsViewModel()
    var eventDetailVM: EventDetailViewModel = EventDetailViewModel()
    var eventListVM: EventsLeaguesViewModel?
    var isFromSubscription: Bool = Bool()
    
    //OUTLETS
    @IBOutlet weak var imageBtn4: UIButton!
    @IBOutlet weak var imageBtn3: UIButton!
    @IBOutlet weak var imageBtn2: UIButton!
    @IBOutlet weak var imageBtn1: UIButton!
    
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var memberRequiredTextfield: UITextField!
    @IBOutlet weak var selectCategoryView: UIView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var selectActivityView: UIView!
    @IBOutlet weak var activityLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var descriptionTextview: UITextView!
    @IBOutlet weak var eventNameTextfield: UITextField!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image4Btn: UIImageView!
    @IBOutlet weak var image3Btn: UIImageView!
    @IBOutlet weak var image2Btn: UIImageView!
    @IBOutlet weak var image1Btn: UIImageView!
    
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
        descriptionTextview.delegate = self
        image1.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1), borderWidth: 1, cornerRadius: 15)
        image2.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1), borderWidth: 1, cornerRadius: 15)
        image3.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1), borderWidth: 1, cornerRadius: 15)
        image4.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1), borderWidth: 1, cornerRadius: 15)
        locationView.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1), borderWidth: 1, cornerRadius: 5)
        descriptionTextview.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1), borderWidth: 1, cornerRadius: 5)
        selectCategoryView.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1), borderWidth: 1, cornerRadius: 5)
        selectActivityView.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1), borderWidth: 1, cornerRadius: 5)
        nextBtn.sainiCornerRadius(radius: 10)
        skipBtn.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.4941176471, green: 0.4941176471, blue: 0.4941176471, alpha: 1), borderWidth: 1, cornerRadius: 10)
        
        activityListVM.delegate = self
        if isFromSubscription {
            headerLbl.text = STATIC_LABELS.createEvent.rawValue
            skipBtn.isHidden = true
            backBtn.isHidden = false
        }
        else {
            switch userFrom {
            case .login:
                headerLbl.text = STATIC_LABELS.createEvent.rawValue
                backBtn.isHidden = true
                skipBtn.isHidden = false
                showAlertWithOption(STATIC_LABELS.eventCreatePopUpHeading.rawValue, message: STATIC_LABELS.eventCreatePopUpMsg.rawValue, btns: [STATIC_LABELS.subscribeNow.rawValue, STATIC_LABELS.cancel.rawValue]) {
                    // action of subscribe btn
                    let vc: SubscriptionVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.SubscriptionVC.rawValue) as! SubscriptionVC
                    vc.userFrom = self.userFrom
                    self.navigationController?.pushViewController(vc, animated: true)
                } completionCancel: {
                    AppDelegate().sharedDelegate().navigateToDashboard()
                }
            case .explore:
                backBtn.isHidden = false
                skipBtn.isHidden = true
                headerLbl.text = STATIC_LABELS.createEvent.rawValue
            case .eventDetail:
                backBtn.isHidden = false
                skipBtn.isHidden = true
                renderData(data: eventDetailVM.eventDetail.value)
                headerLbl.text = STATIC_LABELS.editEvent.rawValue
            case .calendar:
                backBtn.isHidden = false
                skipBtn.isHidden = true
                headerLbl.text = STATIC_LABELS.createEvent.rawValue
            case .profile:
                backBtn.isHidden = false
                skipBtn.isHidden = true
                headerLbl.text = STATIC_LABELS.createEvent.rawValue
            }
        }
        getCategoryList()
        
        uploadImageVM.success.bind { (_) in
            if self.uploadImageVM.success.value {
                self.selectedImages.append(self.uploadImageVM.data.value)
                self.renderImages(imageCount: self.selectedImages.count, imageArray: self.selectedImages)
            }
        }
        
        deleteImageVM.success.bind { (_) in
            if self.deleteImageVM.success.value {
                self.selectedImages = self.selectedImages.filter({ $0 != self.deletedImage })
                self.renderImages(imageCount: self.selectedImages.count, imageArray: self.selectedImages)
            }
        }
        
    }
    
    func getCategoryList() {
        if let categoryList = getCategoryListData() {
            catList = categoryList
        }
        else{
            AppDelegate().sharedDelegate().getCategoryList()
        }
    }
    
    //MARK: - renderData
    private func renderData(data: EventDetail) {
        renderImages(imageCount: data.images.count, imageArray: data.images)
        selectedImages = data.images
        eventNameTextfield.text = data.name
        descriptionTextview.text = data.datumDescription
        locationLbl.text = data.location.address
        latitude = data.location.coordinates[1]
        longitude = data.location.coordinates[0]
        categoryLbl.text = data.categoryName
        activityLbl.text = data.activityName
        activityRef = data.activity
        categoryRef = data.category
        memberRequiredTextfield.text = "\(data.seats)"
    }
    
    //MARK: - renderImages
    private func renderImages(imageCount: Int, imageArray: [String]) {
        switch imageCount {
        case 0:
            image1Btn.image = #imageLiteral(resourceName: "ic_camera")
            image2Btn.image = #imageLiteral(resourceName: "ic_camera")
            image3Btn.image = #imageLiteral(resourceName: "ic_camera")
            image4Btn.image = #imageLiteral(resourceName: "ic_camera")
            image1.image = #imageLiteral(resourceName: "ic_upload_image")
            image2.image = #imageLiteral(resourceName: "ic_upload_image")
            image3.image = #imageLiteral(resourceName: "ic_upload_image")
            image4.image = #imageLiteral(resourceName: "ic_upload_image")
            imageBtn1.isSelected = false
            imageBtn2.isSelected = false
            imageBtn3.isSelected = false
            imageBtn4.isSelected = false
        case 1:
            image1Btn.image = #imageLiteral(resourceName: "ic_cross")
            image2Btn.image = #imageLiteral(resourceName: "ic_camera")
            image3Btn.image = #imageLiteral(resourceName: "ic_camera")
            image4Btn.image = #imageLiteral(resourceName: "ic_camera")
            image1.downloadCachedImage(placeholder: GLOBAL_IMAGES.uploadPlaceholder.rawValue, urlString: AppImageUrl.average + imageArray[0])
            image2.image = #imageLiteral(resourceName: "ic_upload_image")
            image3.image = #imageLiteral(resourceName: "ic_upload_image")
            image4.image = #imageLiteral(resourceName: "ic_upload_image")
            imageBtn1.isSelected = true
            imageBtn2.isSelected = false
            imageBtn3.isSelected = false
            imageBtn4.isSelected = false
        case 2:
            image1Btn.image = #imageLiteral(resourceName: "ic_cross")
            image2Btn.image = #imageLiteral(resourceName: "ic_cross")
            image3Btn.image = #imageLiteral(resourceName: "ic_camera")
            image4Btn.image = #imageLiteral(resourceName: "ic_camera")
            image1.downloadCachedImage(placeholder: GLOBAL_IMAGES.uploadPlaceholder.rawValue, urlString: AppImageUrl.average + imageArray[0])
            image2.downloadCachedImage(placeholder: GLOBAL_IMAGES.uploadPlaceholder.rawValue, urlString: AppImageUrl.average + imageArray[1])
            image3.image = #imageLiteral(resourceName: "ic_upload_image")
            image4.image = #imageLiteral(resourceName: "ic_upload_image")
            imageBtn1.isSelected = true
            imageBtn2.isSelected = true
            imageBtn3.isSelected = false
            imageBtn4.isSelected = false
        case 3:
            image1Btn.image = #imageLiteral(resourceName: "ic_cross")
            image2Btn.image = #imageLiteral(resourceName: "ic_cross")
            image3Btn.image = #imageLiteral(resourceName: "ic_cross")
            image4Btn.image = #imageLiteral(resourceName: "ic_camera")
            image1.downloadCachedImage(placeholder: GLOBAL_IMAGES.uploadPlaceholder.rawValue, urlString: AppImageUrl.average + imageArray[0])
            image2.downloadCachedImage(placeholder: GLOBAL_IMAGES.uploadPlaceholder.rawValue, urlString: AppImageUrl.average + imageArray[1])
            image3.downloadCachedImage(placeholder: GLOBAL_IMAGES.uploadPlaceholder.rawValue, urlString: AppImageUrl.average + imageArray[2])
            image4.image = #imageLiteral(resourceName: "ic_upload_image")
            imageBtn1.isSelected = true
            imageBtn2.isSelected = true
            imageBtn3.isSelected = true
            imageBtn4.isSelected = false
        case 4:
            image1Btn.image = #imageLiteral(resourceName: "ic_cross")
            image2Btn.image = #imageLiteral(resourceName: "ic_cross")
            image3Btn.image = #imageLiteral(resourceName: "ic_cross")
            image4Btn.image = #imageLiteral(resourceName: "ic_cross")
            image1.downloadCachedImage(placeholder: GLOBAL_IMAGES.uploadPlaceholder.rawValue, urlString: AppImageUrl.average + imageArray[0])
            image2.downloadCachedImage(placeholder: GLOBAL_IMAGES.uploadPlaceholder.rawValue, urlString: AppImageUrl.average + imageArray[1])
            image3.downloadCachedImage(placeholder: GLOBAL_IMAGES.uploadPlaceholder.rawValue, urlString: AppImageUrl.average + imageArray[2])
            image4.downloadCachedImage(placeholder: GLOBAL_IMAGES.uploadPlaceholder.rawValue, urlString: AppImageUrl.average + imageArray[3])
            imageBtn1.isSelected = true
            imageBtn2.isSelected = true
            imageBtn3.isSelected = true
            imageBtn4.isSelected = true
        default:
            log.error("Cannot add more than four images")/
        }
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        if isFromSubscription {
            switch userFrom {
            case .login:
                break
            case .explore:
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: ExploreVC.self) {
                        self.navigationController?.popToViewController(controller, animated: true)
                        break
                    }
                }
            case .eventDetail:
                self.navigationController?.popViewController(animated: true)
            case .calendar:
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: ExploreCalendarVC.self) {
                        self.navigationController?.popToViewController(controller, animated: true)
                        break
                    }
                }
            case .profile:
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: EventsLeaguesPostedVC.self) {
                        self.navigationController?.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    //MARK: - uploadImageBtnIsPressed
    @IBAction func uploadImageBtnIsPressed(_ sender: UIButton) {
        imagePosition = sender.tag
        switch imagePosition {
        case 0:
            if imageBtn1.isSelected {
                deletedImage = selectedImages[sender.tag]
                let request = DeleteImageRequest(image: deletedImage)
                deleteImageVM.removeImage(request: request)
            }
            else {
                uploadImage()
            }
        case 1:
            if imageBtn2.isSelected {
                deletedImage = selectedImages[sender.tag]
                let request = DeleteImageRequest(image: deletedImage)
                deleteImageVM.removeImage(request: request)
            }
            else {
                uploadImage()
            }
        case 2:
            if imageBtn3.isSelected {
                deletedImage = selectedImages[sender.tag]
                let request = DeleteImageRequest(image: deletedImage)
                deleteImageVM.removeImage(request: request)
            }
            else {
                uploadImage()
            }
        case 3:
            if imageBtn4.isSelected {
                deletedImage = selectedImages[sender.tag]
                let request = DeleteImageRequest(image: deletedImage)
                deleteImageVM.removeImage(request: request)
            }
            else {
                uploadImage()
            }
        default:
            break
        }
    }
    
    //MARK: - selectedImage
    override func selectedImage(choosenImage: UIImage) {
        switch imagePosition {
        case 0:
            image1.image = choosenImage
            imageBtn1.isSelected = true
        case 1:
            image2.image = choosenImage
            imageBtn2.isSelected = true
        case 2:
            image3.image = choosenImage
            imageBtn3.isSelected = true
        case 3:
            image4.image = choosenImage
            imageBtn4.isSelected = true
        default:
            break
        }
        imageArr.append(UploadImageInfo(name: STATIC_LABELS.image.rawValue, data: compressImage(image: choosenImage), isImagePresent: true))
        uploadImageVM.uploadImage(iamageData: imageArr)
    }
    
    //MARK: - cancelBtnPressed
    override func cancelBtnPressed() {
        switch imagePosition {
        case 0:
            imageBtn1.isSelected = false
        case 1:
            imageBtn2.isSelected = false
        case 2:
            imageBtn3.isSelected = false
        case 3:
            imageBtn4.isSelected = false
        default:
            break
        }
    }
    
    //MARK: - selectLocationBtnIsPressed
    @IBAction func selectLocationBtnIsPressed(_ sender: UIButton) {
        autocompleteClicked()
    }
    
    //MARK: - selectCategoryBtnIsPressed
    @IBAction func selectCategoryBtnIsPressed(_ sender: UIButton) {
        if catList.count == 0 {
            AppDelegate().sharedDelegate().getCategoryList()
            return
        }
        let list = catList.map({ $0.name })
        PickerManager.shared.showPicker(title: "", selected: "", strings: list) { [weak self](category, index, success) in
            guard let `self` = self else { return }
            if category != nil {
                self.categoryLbl.text = category
                self.categoryRef = self.catList[index].id
                self.activityLbl.text = ""
                self.activityRef = ""
                let request = ActivityListRequest(categoryRef: [self.categoryRef], page: 1, limit: 100)
                self.activityListVM.ActivityList(request: request)
            }
        }
    }
    
    //MARK: - selectActivityBtnIsPressed
    @IBAction func selectActivityBtnIsPressed(_ sender: UIButton) {
        let list = activityList.map({ $0.name })
        PickerManager.shared.showPicker(title: "", selected: "", strings: list) { [weak self](activity, index, success) in
            guard let `self` = self else { return }
            if activity != nil {
                self.activityLbl.text = activity
                self.activityRef = self.activityList[index].id
            }
        }
    }
    
    //MARK: - nextBtnIsPressed
    @IBAction func nextBtnIsPressed(_ sender: UIButton) {
        guard let name = eventNameTextfield.text else { return }
        guard let description = descriptionTextview.text else { return }
        guard let location = locationLbl.text else { return }
        guard let seats = memberRequiredTextfield.text else { return }
        
        if selectedImages.count == DocumentDefaultValues.Empty.int {
            displayToast(STATIC_LABELS.noImageAdded.rawValue)
        }
        else if name == DocumentDefaultValues.Empty.string {
            displayToast(STATIC_LABELS.emptyName.rawValue)
        }
        else if description == STATIC_LABELS.emptyDescriptionPlaceholder.rawValue {
            displayToast(STATIC_LABELS.emptyDescription.rawValue)
        }
        else if location == STATIC_LABELS.emptyLocPlaceholder.rawValue {
            displayToast(STATIC_LABELS.emptyLocation.rawValue)
        }
        else if categoryRef == DocumentDefaultValues.Empty.string{
            displayToast(STATIC_LABELS.emptyCategory.rawValue)
        }
        else if activityRef == DocumentDefaultValues.Empty.string {
            displayToast(STATIC_LABELS.emptyActivity.rawValue)
        }
        else if seats == DocumentDefaultValues.Empty.string {
            displayToast(STATIC_LABELS.emptyseats.rawValue)
        }
        else {
            self.addEventRequest = AddEventRequest(name: name, images: selectedImages, description: description, address: location, longitude: longitude, latitude: latitude, categoryRef: categoryRef, activityRef: activityRef, seats: Int(seats))
            
            if userFrom == .eventDetail {
                self.addEventRequest?.eventRef = eventDetailVM.eventDetail.value.id
            }
            
            let vc: CreateEvent_TwoVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.CreateEvent_TwoVC.rawValue) as! CreateEvent_TwoVC
            vc.addEventRequest = self.addEventRequest
            vc.userFrom = userFrom
            vc.eventDetailVM = eventDetailVM
            vc.eventListVM = self.eventListVM
            vc.calendarEventsVM = self.calendarEventsVM
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - skipBtnIsPressed
    @IBAction func skipBtnIsPressed(_ sender: UIButton) {
        AppDelegate().sharedDelegate().navigateToDashboard()
    }
    
    deinit {
        log.success("CreateEvent_OneVC Memory deallocated!")/
    }
}

//MARK: - ActivityListDelegate
extension CreateEvent_OneVC: ActivityListDelegate {
    func didRecieveActivityListResponse(response: CategoryListResponse) {
        activityList = response.data
    }
}

//MARK: - UITextViewDelegate
extension CreateEvent_OneVC: UITextViewDelegate {
    // textViewDidBeginEditing
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextview.text == STATIC_LABELS.emptyDescriptionPlaceholder.rawValue {
            descriptionTextview.text = DocumentDefaultValues.Empty.string
        }
    }
    
    // shouldChangeTextIn
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if newText.count > 300 {
            textView.resignFirstResponder()
            self.view.sainiShowToast(message: STATIC_LABELS.descriptionLimitToast.rawValue)
        }
        return newText.count <= 300
    }
    
    // textViewDidEndEditing
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextview.text == DocumentDefaultValues.Empty.string {
            descriptionTextview.text = STATIC_LABELS.emptyDescriptionPlaceholder.rawValue
        }
    }
}

//MARK: - GMSAutocompleteViewControllerDelegate
extension CreateEvent_OneVC: GMSAutocompleteViewControllerDelegate {
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
            locationLbl.text = place.formattedAddress
            latitude = place.coordinate.latitude
            longitude = place.coordinate.longitude
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
