//
//  ExploreVC.swift
//  BMA
//
//  Created by MACBOOK on 05/07/21.
//

import UIKit
import SainiUtils
import CoreLocation

class ExploreVC: UIViewController {
    
    private var refreshControl : UIRefreshControl = UIRefreshControl.init()
    private var locationManager: CLLocationManager?
    private var eventListVM: EventListViewModel = EventListViewModel()
    private var lat: Double = 0.0
    private var long: Double = 0.0
    private var newUser: Bool = true
    private var hasmore: Bool = Bool()
    private var page: Int = Int()
    
    //OUTLETS
    @IBOutlet weak var bottomConstraintOfTableView: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate().sharedDelegate().showTabBar()
        if SCREEN.HEIGHT >= 812 {
            bottomConstraintOfTableView.constant = 80
        } else {
            bottomConstraintOfTableView.constant = 66
        }
    }
    
    //MARK: - configUI
    private func configUI() {
        tableView.register(UINib.init(nibName: TABLE_VIEW_CELL.EventsLeaguesTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.EventsLeaguesTVC.rawValue)
        
        getUserLocation()
        
        eventListVM.eventList.value.removeAll()
        page = 1
        hasmore = false
        
        eventListVM.hasMore.bind { [weak self](_) in
            guard let `self` = self else { return }
            self.hasmore = self.eventListVM.hasMore.value
        }
        
        eventListVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.eventListVM.success.value {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        eventListVM.eventList.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.eventListVM.eventList.value.count > DocumentDefaultValues.Empty.int {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        refreshControllSetup()
    }
    
    //MARK: - Refresh controll setup
    func refreshControllSetup() {
        refreshControl.tintColor = .systemYellow
        refreshControl.addTarget(self, action: #selector(refreshDataSetUp) , for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    //MARK: - Refresh data
    @objc func refreshDataSetUp() {
        refreshControl.endRefreshing()
        if (lat == 0.0 || lat == 0) && (long == 0.0 || long == 0), let location = UserDefaults.standard.get(CurrentLocation.self, forKey: USER_DEFAULT_KEYS.userLocation.rawValue) {
            updateLocation()
            lat = location.latitude
            long = location.longitude
        }
        let calendar = Calendar.current
        let date = calendar.component(.day, from: Date())
        page = 1
        hasmore = false
        eventListVM.eventList.value.removeAll()
        let request = EventListRequest(longitude: long, latitude: lat, date: date, page: page)
        eventListVM.fetchEventListing(request: request, loader: true)
    }
    
    //MARK: - getUserLocation
    private func getUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.showsBackgroundLocationIndicator = false
        locationManager?.startUpdatingLocation()
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = true
    }
    
    //MARK: - changeLocationBtnIsPressed
    @IBAction func changeLocationBtnIsPressed(_ sender: UIButton) {
        autocompleteClicked()
    }
    
    //MARK: - switchToCalendarViewBtnIsPressed
    @IBAction func switchToCalendarViewBtnIsPressed(_ sender: UIButton) {
        if AppModel.shared.isGuestUser {
            AppModel.shared.guestUserType = .explore
            AppDelegate().sharedDelegate().continueToGuestLogin(isRootVC: false, headingName: DocumentDefaultValues.Empty.string)
        } else {
            let vc: ExploreCalendarVC = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.ExploreCalendarVC.rawValue) as! ExploreCalendarVC
            vc.locationInfo = Location(coordinates: [long, lat], type: "", address: locationLbl.text ?? "Loading...", location: "")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - switchToMapViewBtnIsPressed
    @IBAction func switchToMapViewBtnIsPressed(_ sender: UIButton) {
        if AppModel.shared.isGuestUser {
            AppModel.shared.guestUserType = .explore
            AppDelegate().sharedDelegate().continueToGuestLogin(isRootVC: false, headingName: DocumentDefaultValues.Empty.string)
        } else {
            let vc: ExploreMapVC = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.ExploreMapVC.rawValue) as! ExploreMapVC
            vc.locationInfo = Location(coordinates: [long, lat], type: "", address: locationLbl.text ?? "Loading...", location: "")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - filterBtnIsPressed
    @IBAction func filterBtnIsPressed(_ sender: UIButton) {
        if AppModel.shared.isGuestUser {
            AppModel.shared.guestUserType = .explore
            AppDelegate().sharedDelegate().continueToGuestLogin(isRootVC: false, headingName: DocumentDefaultValues.Empty.string)
        } else {
            let vc: FilterVC = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.FilterVC.rawValue) as! FilterVC
            vc.filterDelegate = self
            vc.lat = self.lat
            vc.long = self.long
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - searchEventsBtnIsPressed
    @IBAction func searchEventsBtnIsPressed(_ sender: UIButton) {
        if AppModel.shared.isGuestUser {
            AppModel.shared.guestUserType = .explore
            AppDelegate().sharedDelegate().continueToGuestLogin(isRootVC: false, headingName: DocumentDefaultValues.Empty.string)
        } else {
            let vc: SearchVC = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.SearchVC.rawValue) as! SearchVC
            vc.lat = lat
            vc.long = long
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - addEventBtnIsPressed
    @IBAction func addEventBtnIsPressed(_ sender: UIButton) {
        if AppModel.shared.isGuestUser {
            AppModel.shared.guestUserType = .explore
            self.createEventSelectedIndex(index: 1)
        }
        else {
            if AppModel.shared.currentUser.subscription {
                let vc: CreateEvent_OneVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.CreateEvent_OneVC.rawValue) as! CreateEvent_OneVC
                vc.userFrom = .explore
                vc.isFromSubscription = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                showAlertWithOption(STATIC_LABELS.eventCreatePopUpHeading.rawValue, message: STATIC_LABELS.eventCreatePopUpMsg.rawValue, btns: [STATIC_LABELS.subscribeNow.rawValue, STATIC_LABELS.cancel.rawValue]) {
                    // action of subscribe btn
                    let vc: SubscriptionVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.SubscriptionVC.rawValue) as! SubscriptionVC
                    vc.userFrom = .explore
                    self.navigationController?.pushViewController(vc, animated: true)
                } completionCancel: {
                    
                    // action of cancel btn
                }
            }
        }
        
    }
    
    func createEventSelectedIndex(index: Int) {
        if AppModel.shared.isGuestUser && index >= 1 {
            switch index {
            case 1:
                AppDelegate().sharedDelegate().continueToGuestLogin(isRootVC: false, headingName: "")
            default:
                break
            }
        }
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension ExploreVC: UITableViewDelegate, UITableViewDataSource {
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if eventListVM.eventList.value.count == DocumentDefaultValues.Empty.int {
            tableView.sainiSetEmptyMessage(STATIC_LABELS.noDataFound.rawValue)
        }else {
            tableView.restore()
            tableView.separatorStyle = .none
        }
        return eventListVM.eventList.value.count
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.EventsLeaguesTVC.rawValue, for: indexPath) as? EventsLeaguesTVC else { return UITableViewCell() }
        
        cell.viewDetailsBtn.isHidden = false
        cell.lineView.isHidden = false
        cell.favBtn.isHidden = true
        let eventlistData = eventListVM.eventList.value
        if eventlistData.count > DocumentDefaultValues.Empty.int {
            if eventlistData[indexPath.row].images?.count ?? 0 > 0 {
                cell.eventImageView.downloadCachedImage(placeholder: GLOBAL_IMAGES.eventPlaceHolder.rawValue, urlString: AppImageUrl.average + eventlistData[indexPath.row].images![0])
            }
            cell.eventNameLbl.text = eventlistData[indexPath.row].name
            cell.addressLbl.text = eventlistData[indexPath.row].location.address
            let startDate = getDateStringFromDateString(strDate: eventlistData[indexPath.row].startDate, format: DATE_FORMATS.ddMMMyyyy.rawValue)
            let endDate = getDateStringFromDateString(strDate: eventlistData[indexPath.row].endDate, format: DATE_FORMATS.ddMMMyyyy.rawValue)
            cell.dateLbl.text = startDate + " - " + endDate
        }
        
        cell.viewDetailsBtn.tag = indexPath.row
        cell.viewDetailsBtn.addTarget(self, action: #selector(viewEventDetailBtnIsPressed), for: .touchUpInside)
        return cell
    }
    
    //MARK: - willDisplay
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == tableView {
            if eventListVM.eventList.value.count - 2 == indexPath.row {
                if hasmore {
                    page = page + 1
//                    updateLocation()
                    let calendar = Calendar.current
                    let date = calendar.component(.day, from: Date())
                    let request = EventListRequest(longitude: long, latitude: lat, date: date, page: page)
                    eventListVM.fetchEventListing(request: request, loader: false)
                }
            }
        }
    }
    
    // didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let vc: EventDetailVC = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.EventDetailVC.rawValue) as! EventDetailVC
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - viewEventDetailBtnIsPressed
    @objc func viewEventDetailBtnIsPressed(_ sender: UIButton) {
        let vc: EventDetailVC = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.EventDetailVC.rawValue) as! EventDetailVC
        vc.eventRef = eventListVM.eventList.value[sender.tag].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - ApplyFilterDelegate
extension ExploreVC: ApplyFilterDelegate {
    func filterEvents(request: EventListRequest) {
        hasmore = false
        eventListVM.eventList.value.removeAll()
        eventListVM.fetchEventListing(request: request, loader: true)
    }
}

//MARK: - CLLocationManagerDelegate
extension ExploreVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //Getting latest location Regular
        if let location = locations.last {
            manager.stopUpdatingLocation()
            lat = location.coordinate.latitude
            long = location.coordinate.longitude
            let currentLocation = CurrentLocation(latitude: lat, longitude: long)
            UserDefaults.standard.set(encodable: currentLocation, forKey: USER_DEFAULT_KEYS.userLocation.rawValue)
            if newUser {
                newUser = false
                updateLocation()
                page = 1
                hasmore = false
                eventListVM.eventList.value.removeAll()
                let calendar = Calendar.current
                let date = calendar.component(.day, from: Date())
                let request = EventListRequest(longitude: long, latitude: lat, date: date, page: page)
                eventListVM.fetchEventListing(request: request, loader: true)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    //MARK: - updateLocation
    func updateLocation() {
        if let SavedLocation = UserDefaults.standard.get(CurrentLocation.self, forKey: USER_DEFAULT_KEYS.userLocation.rawValue){
            let latitude = SavedLocation.latitude // 30.741482
            let longitude = SavedLocation.longitude // 76.768066
            let locationAddress = CLLocation(latitude: latitude , longitude: longitude)
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(locationAddress, completionHandler: { (placemarks, error) -> Void in
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                guard let locality = placeMark.locality else { return }
                guard let subLocality = placeMark.subLocality else { return }
                self.locationLbl.text = subLocality + ", " + locality
            })
        }
    }
}

//MARK: - GMSAutocompleteViewControllerDelegate
extension ExploreVC: GMSAutocompleteViewControllerDelegate {
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
        let calendar = Calendar.current
        let date = calendar.component(.day, from: Date())
        page = 1
        hasmore = false
        eventListVM.eventList.value.removeAll()
        let request = EventListRequest(longitude: long, latitude: lat, date: date)
        eventListVM.fetchEventListing(request: request, loader: true)
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
