//
//  SelectCategoryVC.swift
//  BMA
//
//  Created by Keyur on 15/02/22.
//

import UIKit

class SelectCategoryVC: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var nextBtn: UIButton!
    
    var selectedCatList = [CategoryModel]()
    var catList = [CategoryModel]()
    var activityVM = ActivityListViewModel.init()
    
    var totalCategory = 0
    var oldDict = [CategoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerTableViewMethod()
        configUI()
    }
    
    //MARK: - configUI
    private func configUI() {
        nextBtn.sainiCornerRadius(radius: 10)
        oldDict = catList
        activityVM.getMyActivityList { data in
            self.catList = data
            for temp in self.selectedCatList {
                let index = self.catList.firstIndex { tempCat in
                    tempCat.id == temp.id
                }
                if index != nil {
                    self.catList[index!] = temp
                    self.totalCategory += 1
                }
            }
            self.tblView.reloadData()
        }
    }
        
    //MARK: - Button Click
    @IBAction func clicKToBack(_ sender: UIButton) {
        catList = oldDict
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clicKToNext(_ sender: UIButton) {
        var arrData = [CategoryModel]()
        for temp in catList {
            if temp.isSelected {
                arrData.append(temp)
            }
        }
        if arrData.count == 0 {
            displayToast("Please select category")
        }else{
            let vc : SelectActivityVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: MAIN_STORYBOARD.SelectActivityVC.rawValue) as! SelectActivityVC
            vc.catList = arrData
            self.navigationController?.pushViewController(vc, animated: true)
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
extension SelectCategoryVC : UITableViewDelegate, UITableViewDataSource {
    
    func registerTableViewMethod() {
        tblView.register(UINib.init(nibName: TABLE_VIEW_CELL.SelectActivityCell.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.SelectActivityCell.rawValue)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SelectActivityCell = tblView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.SelectActivityCell.rawValue) as! SelectActivityCell
        cell.activityNameLbl.text = catList[indexPath.row].name
        cell.checkboxImage.isSelected = catList[indexPath.row].isSelected
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if catList[indexPath.row].isSelected {
            catList[indexPath.row].isSelected = false
            totalCategory -= 1
        }else{
            
            if totalCategory < 4 {
                totalCategory += 1
                catList[indexPath.row].isSelected = true
            }else{
                displayToast(STATIC_LABELS.maxCategoryToast.rawValue)
            }
        }
        tblView.reloadRows(at: [indexPath], with: .automatic)
    }
}
