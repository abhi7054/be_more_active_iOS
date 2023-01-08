//
//  ExploreMapVC.swift
//  BMA
//
//  Created by MACBOOK on 07/07/21.
//

import UIKit
import GoogleMaps

class ExploreMapVC: UIViewController {
    
    private var eventListVM: EventListViewModel = EventListViewModel()
    private var eventRef: String = String()
    var locationInfo: Location = Location()
    
    //OUTLETS
    @IBOutlet weak var bottomConstraintOfMapView: NSLayoutConstraint!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var viewDetailsBtn: UIButton!
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var selectedEventView: UIView!
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
            bottomConstraintOfMapView.constant = 76
        } else {
            bottomConstraintOfMapView.constant = 56
        }
    }
    
    //MARK: - configUI
    private func configUI() {
        eventImageView.sainiCornerRadius(radius: 10)
        viewDetailsBtn.sainiCornerRadius(radius: 19)
        
        
        if !locationInfo.coordinates.isEmpty {
            mapView.isMyLocationEnabled = true
            locationLbl.text = locationInfo.address
                let calendar = Calendar.current
                let date = calendar.component(.day, from: Date())
            let request = EventListRequest(longitude: locationInfo.coordinates[0], latitude: locationInfo.coordinates[1], date: date)
            eventListVM.fetchEventListing(request: request, loader: true)
        } else {
            displayToast("No Events available for this location")
        }
        
        mapView.camera = GMSCameraPosition(latitude: locationInfo.coordinates[1], longitude: locationInfo.coordinates[0], zoom: 10)
        eventListVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.eventListVM.success.value {
                if self.eventListVM.eventList.value.count > 0 {
                    self.markerSetUp()
                }
                else {
                    displayToast("No Events available for this location")
                }
            }
        }
    }
    
    //MARK: -  markerSetUp
    func markerSetUp() {
        self.mapView.clear()
        eventListVM.eventList.value.forEach { (event) in
            addMarkersOnMap(lat: event.location.coordinates[1], long: event.location.coordinates[0], data: event)
        }
    }
    
    //MARK:- addMarkersOnMap
    private func addMarkersOnMap(lat:Double,long:Double, data: EventList){
        let marker = GMSMarker()
        if data.isSelected {
            marker.icon = #imageLiteral(resourceName: "ic_pin_selected")
        }
        else {
            marker.icon = #imageLiteral(resourceName: "ic_pin")
        }
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.userData = data
        marker.map = mapView
    }
    
    
    //MARK: - switchToListViewBtnIsPressed
    @IBAction func switchToListViewBtnIsPressed(_ sender: UIButton) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: ExploreVC.self) {
                self.navigationController?.popToViewController(controller, animated: false)
                break
            }
        }
    }
    
    //MARK: - gotoFilterBtnIsPressed
    @IBAction func gotoFilterBtnIsPressed(_ sender: UIButton) {
        let vc: FilterVC = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.FilterVC.rawValue) as! FilterVC
        vc.filterDelegate = self
        vc.lat = self.locationInfo.coordinates[1]
        vc.long = self.locationInfo.coordinates[0]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - viewEventDetailBtnIsPressed
    @IBAction func viewEventDetailBtnIsPressed(_ sender: UIButton) {
        let vc: EventDetailVC = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.EventDetailVC.rawValue) as! EventDetailVC
        vc.eventRef = self.eventRef
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - GMSMapViewDelegate
extension ExploreMapVC: GMSMapViewDelegate {
    
    // didTap
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        selectedEventView.isHidden = false
        for (index,_) in eventListVM.eventList.value.enumerated(){
            eventListVM.eventList.value[index].isSelected = false
            let eventData = marker.userData as! EventList
            if eventData.id == eventListVM.eventList.value[index].id{
                eventListVM.eventList.value[index].isSelected = true
            }
        }
        renderDataToSelectedPin(info: marker.userData as! EventList)
        return false
    }
    
    // didTapMyLocationButton
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        mapView.selectedMarker = nil
        return false
    }
    
    //MARK: - renderDataToSelectedPin
    private func renderDataToSelectedPin(info: EventList) {
        eventRef = info.id
        if info.images != nil {
            eventImageView.downloadCachedImage(placeholder: GLOBAL_IMAGES.eventPlaceHolder.rawValue, urlString: AppImageUrl.average + info.images![0])
        }
        
        eventNameLbl.text = info.name
        locationLbl.text = info.location.address
        let startDate = getDateStringFromDateString(strDate: info.startDate, format: DATE_FORMATS.ddMMMyyyy.rawValue)
        let endDate = getDateStringFromDateString(strDate: info.endDate, format: DATE_FORMATS.ddMMMyyyy.rawValue)
        dateLbl.text = startDate + " - " + endDate
        markerSetUp()
    }
}

//MARK: - ApplyFilterDelegate
extension ExploreMapVC: ApplyFilterDelegate {
    func filterEvents(request: EventListRequest) {
        eventListVM.eventList.value.removeAll()
        selectedEventView.isHidden = true
        guard let lat = request.latitude else { return }
        guard let long = request.longitude else { return }
        mapView.camera = GMSCameraPosition(latitude: lat, longitude: long, zoom: 10)
        eventListVM.fetchEventListing(request: request, loader: true)
    }
}
