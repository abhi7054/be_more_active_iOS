//
//  SetUpProfileVC.swift
//  BMA
//
//  Created by MACBOOK on 30/06/21.
//

import UIKit
import SainiUtils
import GooglePlaces

class SetUpProfileVC: UploadImageVC {
    
    //OUTLETS
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var selectCategoryView: UIView!
    @IBOutlet weak var heightConstraintOfTableView: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var setUpProfileVM : UpdateUserViewModel = UpdateUserViewModel()
    var activityListVM : ActivityListViewModel = ActivityListViewModel()
    private var imageData: UploadImageInfo = UploadImageInfo(name: "", data: Data(), isImagePresent: false)
    private var lat: Double = 0.0
    private var long: Double = 0.0
    private var isProfileImg : Bool = false
    private var profileImg : UIImage = UIImage()
    private var activityArr : [CategoryListModel] = [CategoryListModel]()
    private var selectedActivityArr : [CategoryListModel] = [CategoryListModel]()
    private var isProfileSelect : Bool = false
    private var catList: [CategoryListModel] = [CategoryListModel]()
    private var categoryRef: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configUI()
    }
    
    //MARK: - configUI
    private func configUI() {
        setUpProfileVM.delegate = self
        submitBtn.sainiCornerRadius(radius: 10)
        profileImageView.sainiCornerRadius(radius: profileImageView.frame.height / 2)
        locationView.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1), borderWidth: 1, cornerRadius: 5)
        selectCategoryView.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1), borderWidth: 1, cornerRadius: 5)
        
        tableView.register(UINib(nibName: TABLE_VIEW_CELL.SelectActivityCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.SelectActivityCell.rawValue)
        activityListVM.delegate = self
//        if isSocialUser() {
            categoryView.isHidden = true
//            if let categoryList = getCategoryListData() {
//                catList = categoryList
//                categoryLbl.text = categoryList.first?.name
//                categoryRef = categoryList.first?.id ?? DocumentDefaultValues.Empty.string
//                let request = ActivityListRequest(categoryRef: [categoryRef], page: 1, limit: 100)
//                self.activityListVM.ActivityList(request: request)
//            }
//        }
//        else {
//            categoryView.isHidden = true
//            delay(0.2) { [weak self] in
//                guard let `self` = self else { return }
//                if !AppModel.shared.currentUser.category.isEmpty {
//                    let categoryRef = AppModel.shared.currentUser.category
//                    let request = ActivityListRequest(categoryRef: categoryRef, page: 1, limit: 100)
//                    self.activityListVM.ActivityList(request: request)
//                }
//            }
//        }
        
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - uploadImageBtnIsPressed
    @IBAction func uploadImageBtnIsPressed(_ sender: UIButton) {
        uploadImage()
    }
    
    //MARK: - selectedImage
    override func selectedImage(choosenImage: UIImage) {
        profileImageView.image = choosenImage
        imageData.data = compressImage(image: choosenImage)
        imageData.name = "picture"
        profileImg = choosenImage
        isProfileSelect = true
    }
    
    //MARK: - setLocationBtnIsPressed
    @IBAction func setLocationBtnIsPressed(_ sender: UIButton) {
        autocompleteClicked()
    }
    
    //MARK: - selectCategoryBtnIsPressed
    @IBAction func selectCategoryBtnIsPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        let list = catList.map({ $0.name })
        PickerManager.shared.showPicker(title: "", selected: "", strings: list) { [weak self](category, index, success) in
            guard let `self` = self else { return }
            if category != nil {
                self.categoryLbl.text = category
                self.categoryRef = self.catList[index].id
                let request = ActivityListRequest(categoryRef: [self.categoryRef], page: 1, limit: 100)
                self.activityListVM.ActivityList(request: request)
            }
        }
    }
    
    //MARK: - submitBtnIsPressed
    @IBAction func submitBtnIsPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let location = locationLbl.text else { return }
        
//        if !isProfileSelect {
//            displayToast("Kindly add profile Image")
//        }
        if location == STATIC_LABELS.emptyLocPlaceholder.rawValue {
            displayToast("enter location")
        }
//        else if isSocialUser() && categoryRef.isEmpty {
//            displayToast(STATIC_LABELS.emptyCategory.rawValue)
//        }
//        else if selectedActivityArr.isEmpty {
//            displayToast("Please select atleast one activity")
//        }
        else {
            setUpProfileVM.updateUser(imageData: [imageData], updateRequest: UpdateUserRequest(location: location, latitude: lat, longitude: long))
        }
    }
    
    deinit {
        log.success("SetUpProfileVC Memory deallocated!")/
    }
}

//MARK: - TableView Data Source and Delegate Methods
extension SetUpProfileVC: UITableViewDelegate, UITableViewDataSource {
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityArr.count
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.SelectActivityCell.rawValue, for: indexPath) as? SelectActivityCell else { return UITableViewCell() }
        
        cell.activityNameLbl.text = activityArr[indexPath.row].name
        
        
        cell.checkboxImage.tag = indexPath.row
        let index = selectedActivityArr.firstIndex { (data) -> Bool in
            data.id == activityArr[indexPath.row].id
        }
        if index == nil {
            cell.checkboxImage.isSelected = false
        }
        else{
            cell.checkboxImage.isSelected = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = selectedActivityArr.firstIndex { (data) -> Bool in
            data.id == activityArr[indexPath.row].id
        }
        if index != nil {
            selectedActivityArr.remove(at: index!)
        }
        else{
            selectedActivityArr.append(activityArr[indexPath.row])
        }
        tableView.reloadData()
    }
    
    
}

extension SetUpProfileVC: UpdateUserDelegate {
    func didRecieveUpdateUserResponse(response: UpdateUserResponse) {
        UserDefaults.standard.set(encodable: response.data, forKey: USER_DEFAULT_KEYS.currentUser.rawValue)
        AppModel.shared.currentUser = response.data
        
        let vc: CreateEvent_OneVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.CreateEvent_OneVC.rawValue) as! CreateEvent_OneVC
        vc.userFrom = .login
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - ActivityListDelegate
extension SetUpProfileVC: ActivityListDelegate {
    func didRecieveActivityListResponse(response: CategoryListResponse) {
        activityArr = response.data
        setActivityListData(activityArr)
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.heightConstraintOfTableView.constant = self.tableView.contentSize.height
        }
    }
}

//MARK: - GMSAutocompleteViewControllerDelegate
extension SetUpProfileVC: GMSAutocompleteViewControllerDelegate {
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
