//
//  SelectActivityVC.swift
//  BMA
//
//  Created by Keyur on 15/02/22.
//

import UIKit

class SelectActivityVC: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var saveBtn: UIButton!
    
    var catList = [CategoryModel]()
    var oldDict = [CategoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerTableViewMethod()
        configUI()
    }
    
    //MARK: - configUI
    private func configUI() {
        saveBtn.sainiCornerRadius(radius: 10)
        oldDict = [CategoryModel]()
        oldDict = catList
        for i in 0..<catList.count {
            for tempA in catList[i].activities {
                if tempA.isSelected {
                    catList[i].selectedActivity += 1
                }
            }
        }
    }
     
    //MARK: - Button Click
    @IBAction func clicKToBack(_ sender: UIButton) {
        catList = oldDict
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clicKToSave(_ sender: UIButton) {
        self.view.endEditing(true)
        var totalActivity = 0
        for i in 0..<catList.count {
            for tempA in catList[i].activities {
                if tempA.isSelected {
                    totalActivity += 1
                }
            }
        }
        
        if totalActivity == 0 {
            displayToast("Please select activity")
            return
        }
        
        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION_NAME.updateCategory.rawValue), object: catList)
        var isRedirect = false
        for controller in self.navigationController!.viewControllers as Array {
            if UserDefaults.standard.value(forKey: USER_DEFAULT_KEYS.token.rawValue) as? String != nil {
                if controller.isKind(of: EditProfileVC.self) {
                    isRedirect = true
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }else{
                if controller.isKind(of: RegisterVC.self) {
                    isRedirect = true
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
        if !isRedirect {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK:- Tableview Method
extension SelectActivityVC : UITableViewDelegate, UITableViewDataSource {
    
    func registerTableViewMethod() {
        tblView.register(UINib.init(nibName: TABLE_VIEW_CELL.CategorySectionTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.CategorySectionTVC.rawValue)
        tblView.register(UINib.init(nibName: TABLE_VIEW_CELL.SelectActivityCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.SelectActivityCell.rawValue)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return catList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell : CategorySectionTVC = tblView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.CategorySectionTVC.rawValue) as! CategorySectionTVC
        cell.titleLbl.text = catList[section].name
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catList[section].activities.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SelectActivityCell = tblView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.SelectActivityCell.rawValue) as! SelectActivityCell
        cell.activityNameLbl.text = catList[indexPath.section].activities[indexPath.row].name
        cell.checkboxImage.isSelected = catList[indexPath.section].activities[indexPath.row].isSelected
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if catList[indexPath.section].activities[indexPath.row].isSelected {
            catList[indexPath.section].selectedActivity -= 1
            catList[indexPath.section].activities[indexPath.row].isSelected = false
        }else{
            if catList[indexPath.section].selectedActivity < 5 {
                catList[indexPath.section].selectedActivity += 1
                catList[indexPath.section].activities[indexPath.row].isSelected = true
            }else{
                displayToast(STATIC_LABELS.maxActivityToast.rawValue)
            }
        }
        tblView.reloadData()
    }
}
