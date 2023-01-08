//
//  SelectActivitiesVC.swift
//  BMA
//
//  Created by iMac on 02/07/21.
//

import UIKit

class SelectActivitiesVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    
    private var activityListVM : ActivityListViewModel = ActivityListViewModel()
    private var selectActivitiesVM : UpdateUserViewModel = UpdateUserViewModel()
    private var activityArr : [CategoryListModel] = [CategoryListModel]()
    private var imageData: [UploadImageInfo] = [UploadImageInfo]()
    var selecteUserArr: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    func configUI() {
        saveBtn.sainiCornerRadius(radius: 10)
        registerTableviewMethod()
        selectActivitiesVM.delegate = self
        activityListVM.delegate = self
        
        if getActivityListData().count != 0 {
            activityArr = getActivityListData()
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
        }
        else {
            let categoryRef = AppModel.shared.currentUser.category
            let request = ActivityListRequest(categoryRef: categoryRef, page: 1, limit: 100)
            self.activityListVM.ActivityList(request: request)
        }
        
        if let userData = AppModel.shared.currentUser {
            selecteUserArr = userData.activities
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
        }
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToSave(_ sender: Any) {
        selectActivitiesVM.updateUser(imageData: imageData, updateRequest: UpdateUserRequest(activities: selecteUserArr))
    }
}

//MARK: - TableView Delegate
extension SelectActivitiesVC : UITableViewDelegate, UITableViewDataSource {
    
    func registerTableviewMethod() {
        tblView.register(UINib.init(nibName: TABLE_VIEW_CELL.SelectActivityTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.SelectActivityTVC.rawValue)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.SelectActivityTVC.rawValue, for: indexPath) as! SelectActivityTVC
        
        cell.statusBtn.setTitle(activityArr[indexPath.row].name, for: UIControl.State.normal)
        cell.statusBtn.isUserInteractionEnabled = false
        
        let index = selecteUserArr.firstIndex { (temp) -> Bool in
            temp == activityArr[indexPath.row].id
        }
        if index == nil {
            cell.statusBtn.isSelected = false
        }else{
            cell.statusBtn.isSelected = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = selecteUserArr.firstIndex { (data) -> Bool in
            data == activityArr[indexPath.row].id
        }
        if index != nil {
            selecteUserArr.remove(at: index!)
        }
        else{
            selecteUserArr.append(activityArr[indexPath.row].id)
        }
        tableView.reloadData()
    }
}

extension SelectActivitiesVC: UpdateUserDelegate {
    
    func didRecieveUpdateUserResponse(response: UpdateUserResponse) {
        log.success(response.message)/
        UserDefaults.standard.set(encodable: response.data, forKey: USER_DEFAULT_KEYS.currentUser.rawValue)
        AppModel.shared.currentUser = response.data
        
        delay(0.1) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

//MARK: - ActivityListDelegate
extension SelectActivitiesVC: ActivityListDelegate {
    func didRecieveActivityListResponse(response: CategoryListResponse) {
        activityArr = response.data
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
}
