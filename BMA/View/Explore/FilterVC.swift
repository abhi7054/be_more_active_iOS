//
//  FilterVC.swift
//  BMA
//
//  Created by MACBOOK on 06/07/21.
//

import UIKit
import GooglePlaces
import RangeSeekSlider

protocol ApplyFilterDelegate {
    func filterEvents(request: EventListRequest)
}

class FilterVC: UIViewController {
    
    var filterDelegate: ApplyFilterDelegate?
    var lat: Double = 0.0
    var long: Double = 0.0
    private var fromDate: String = String()
    private var toDate: String = String()
    private let calendar = Calendar.current
    private var day: Int = Int()
    private var month: Int = Int()
    private var year: Int = Int()
    private var selectedFromDate: Date = Date()
    private var selectedToDate: Date = Date()

    //OUTLETS
    @IBOutlet weak var rangeSlider: RangeSeekSlider!
    @IBOutlet weak var toDateView: UIView!
    @IBOutlet weak var fromDateView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var toDateLbl: UILabel!
    @IBOutlet weak var fromDateLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
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
        locationView.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1), borderWidth: 1, cornerRadius: 5)
        fromDateView.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1), borderWidth: 1, cornerRadius: 5)
        toDateView.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1), borderWidth: 1, cornerRadius: 5)
        applyBtn.sainiCornerRadius(radius: 10)
    }
    
    //MARK: - selectLocationBtnIsPressed
    @IBAction func selectLocationBtnIsPressed(_ sender: UIButton) {
        autocompleteClicked()
    }
    
    //MARK: - fromDateSelectBtnIsPressed
    @IBAction func fromDateSelectBtnIsPressed(_ sender: UIButton) {
        showDatePicker(title: "", selected: Date(), minDate: nil, maxDate: nil) { (date) in
            let selectedDate = getDateStringFromDate(date: date, format: DATE_FORMATS.ddMMMyyyy.rawValue)
            self.fromDateLbl.text = selectedDate
            self.day = self.calendar.component(.day, from: date)
            self.month = self.calendar.component(.month, from: date)
            self.year = self.calendar.component(.year, from: date)
            let dateComponents = DateComponents(calendar: self.calendar,
                                                year: self.year,
                                                month: self.month,
                                                day: self.day, hour: 12, minute: 0, second: 0)
            let finalDate = self.calendar.date(from: dateComponents)!
            self.selectedFromDate = finalDate
            self.fromDate = getDateStringFromDate(date: finalDate, format: DATE_FORMATS.utcFormat.rawValue)
        } completionClose: {
        }
    }
    
    //MARK: - toDateSelectBtnIsPressed
    @IBAction func toDateSelectBtnIsPressed(_ sender: UIButton) {
        showDatePicker(title: "", selected: selectedFromDate, minDate: selectedFromDate, maxDate: nil) { (date) in
            let selectedDate = getDateStringFromDate(date: date, format: DATE_FORMATS.ddMMMyyyy.rawValue)
            self.toDateLbl.text = selectedDate
            self.day = self.calendar.component(.day, from: date)
            self.month = self.calendar.component(.month, from: date)
            self.year = self.calendar.component(.year, from: date)
            let dateComponents = DateComponents(calendar: self.calendar,
                                                year: self.year,
                                                month: self.month,
                                                day: self.day, hour: 23, minute: 59, second: 59)
            let finalDate = self.calendar.date(from: dateComponents)!
            self.selectedToDate = finalDate
            self.toDate = getDateStringFromDate(date: finalDate, format: DATE_FORMATS.utcFormat.rawValue)
        } completionClose: {
        }
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - applyBtnIsPressed
    @IBAction func applyBtnIsPressed(_ sender: UIButton) {
        if fromDate.isEmpty && !toDate.isEmpty {
            displayToast("Kindly add from data")
        }
        else if !fromDate.isEmpty && toDate.isEmpty {
            displayToast("Kindly add to data")
        }
        else if selectedToDate < selectedFromDate {
            displayToast(STATIC_LABELS.dateCompareToast.rawValue)
        }
        else {
            let minDistance = Int(rangeSlider.selectedMinValue)
            let maxDistance = Int(rangeSlider.selectedMaxValue)
            let calendar = Calendar.current
            let date = calendar.component(.day, from: Date())
            let request = EventListRequest(longitude: long, latitude: lat, startDate: fromDate, endDate: toDate, minDistance: minDistance, maxDistance: maxDistance, date: date, page: 1)
            filterDelegate?.filterEvents(request: request)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

//MARK: - GMSAutocompleteViewControllerDelegate
extension FilterVC: GMSAutocompleteViewControllerDelegate {
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
