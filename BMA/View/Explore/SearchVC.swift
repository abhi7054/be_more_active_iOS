//
//  SearchVC.swift
//  BMA
//
//  Created by MACBOOK on 05/07/21.
//

import UIKit

class SearchVC: UIViewController {
    
    private var eventSearchVM: EventSearchViewModel = EventSearchViewModel()
    private var workItemReferance: DispatchWorkItem?
    private var searchedText: String = ""
    private var currentPage : Int = 1
    private var isHasMore : Bool = false
    var lat: Double = 0.0
    var long: Double = 0.0
    
    //OUTLETS
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
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
        tableView.register(UINib.init(nibName: TABLE_VIEW_CELL.EventsLeaguesTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.EventsLeaguesTVC.rawValue)
        searchTextfield.delegate = self
        searchTextfield.becomeFirstResponder()
        if Int(lat) != 0 && Int(long) != 0 {
            let request = EventSearchRequest(longitude: long, latitude: lat, text: searchedText)
            eventSearchVM.fetchSearchedListing(request: request)
        }
        
        eventSearchVM.hasMore.bind { [weak self](_) in
            guard let `self` = self else { return }
            self.isHasMore = self.eventSearchVM.hasMore.value
        }
        
        eventSearchVM.success.bind { [weak self](_) in
            guard let `self` = self else { return }
            if self.eventSearchVM.success.value {
                if !self.eventSearchVM.eventList.value.isEmpty {
                    self.noDataLbl.isHidden = true
                }
                else {
                    self.noDataLbl.isHidden = false
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - backBtnIsPressed
    @IBAction func backBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - deleteSearchedTextBtnIsPressed
    @IBAction func deleteSearchedTextBtnIsPressed(_ sender: UIButton) {
        searchTextfield.text = DocumentDefaultValues.Empty.string
        searchedText = DocumentDefaultValues.Empty.string
        if Int(lat) != 0 && Int(long) != 0 {
            let request = EventSearchRequest(longitude: long, latitude: lat, text: searchedText)
            eventSearchVM.fetchSearchedListing(request: request)
        }
    }
}

//MARK: - TableView DataSource and Delegate Methods
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventSearchVM.eventList.value.count
    }
    
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.EventsLeaguesTVC.rawValue, for: indexPath) as? EventsLeaguesTVC else { return UITableViewCell() }
        cell.viewDetailsBtn.isHidden = false
        cell.lineView.isHidden = true
        cell.favBtn.isHidden = true
        
        let eventlistData = eventSearchVM.eventList.value
        if eventlistData[indexPath.row].images?.count ?? 0 > 0 {
            cell.eventImageView.downloadCachedImage(placeholder: GLOBAL_IMAGES.eventPlaceHolder.rawValue, urlString: AppImageUrl.average + eventlistData[indexPath.row].images![0])
        }
        cell.eventNameLbl.text = eventlistData[indexPath.row].name
        cell.addressLbl.text = eventlistData[indexPath.row].location.address
        let startDate = getDateStringFromDateString(strDate: eventlistData[indexPath.row].startDate, format: DATE_FORMATS.ddMMMyyyy.rawValue)
        let endDate = getDateStringFromDateString(strDate: eventlistData[indexPath.row].endDate, format: DATE_FORMATS.ddMMMyyyy.rawValue)
        cell.dateLbl.text = startDate + " - " + endDate
        
        cell.viewDetailsBtn.tag = indexPath.row
        cell.viewDetailsBtn.addTarget(self, action: #selector(viewEventDetailBtnIsPressed), for: .touchUpInside)
        return cell
    }
    
    // willDisplay
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if eventSearchVM.eventList.value.count - 2 == indexPath.row {
            if isHasMore {
                currentPage = currentPage + 1
                if Int(lat) != 0 && Int(long) != 0 {
                    let request = EventSearchRequest(longitude: long, latitude: lat, text: searchedText)
                    eventSearchVM.fetchSearchedListing(request: request)
                }
            }
        }
    }
    
    //MARK: - viewEventDetailBtnIsPressed
    @objc func viewEventDetailBtnIsPressed(_ sender: UIButton) {
        let vc: EventDetailVC = STORYBOARD.EXPLORE.instantiateViewController(withIdentifier: EXPLORE_STORYBOARD.EventDetailVC.rawValue) as! EventDetailVC
        vc.eventRef = eventSearchVM.eventList.value[sender.tag].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UITextFieldDelegate
extension SearchVC: UITextFieldDelegate {
    // shouldChangeCharactersIn
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if updatedText != DocumentDefaultValues.Empty.string {
                workItemReferance?.cancel()
                let workItem = DispatchWorkItem {
                    self.searchedText = updatedText
                    self.view.endEditing(true)
                    self.isHasMore = false
                    self.currentPage = 1
                    self.eventSearchVM.eventList.value.removeAll()
                    
                    if Int(self.lat) != 0 && Int(self.long) != 0 {
                        let request = EventSearchRequest(longitude: self.long, latitude: self.lat, text: self.searchedText)
                        self.eventSearchVM.fetchSearchedListing(request: request)
                    }
                }
                workItemReferance = workItem
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1),execute: workItem)
            }
        }
        return true
    }
}
