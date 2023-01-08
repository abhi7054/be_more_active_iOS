
//
//  SettingVC.swift
//  BMA
//
//  Created by iMac on 02/07/21.
//

import UIKit

class SettingVC: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }

    func configUI() {
        
        registerTableviewMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate().sharedDelegate().hideTabBar()
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}


//MARK: - TableView Delegate
extension SettingVC : UITableViewDelegate, UITableViewDataSource {
    
    func registerTableviewMethod() {
        tblView.register(UINib.init(nibName: TABLE_VIEW_CELL.SettingsTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.SettingsTVC.rawValue)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SETTING_OPTION_IMG.list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL.SettingsTVC.rawValue, for: indexPath) as! SettingsTVC
        
        cell.settingOptionImg.image = UIImage.init(named: SETTING_OPTION_IMG.list[indexPath.row])
        cell.settingOptionLbl.text = SETTING_OPTION_TITLE.list[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch SETTING_OPTION_TITLE.list[indexPath.row] {
            case SETTING_OPTION_TITLE.ACTIVITY1.rawValue:
                let url = "http://itunes.apple.com/app/id1576812807"
                if let name = URL(string: url), !name.absoluteString.isEmpty {
                    let objectsToShare = [name]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                    self.present(activityVC, animated: true, completion: nil)
                }else  {
                    // show alert for not available
                }
                break
            case SETTING_OPTION_TITLE.ACTIVITY2.rawValue:
                let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
                vc.type = SETUP_ABOUT_REDIRECTION.ABOUT_US
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case SETTING_OPTION_TITLE.ACTIVITY3.rawValue:
                sainiOpenUrlInSafari(strUrl: "https://beemoreactive.wixsite.com/beemoreactive/copy-of-policies")
//                let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
//                vc.type = SETUP_ABOUT_REDIRECTION.TERMS_CONDITION
//                self.navigationController?.pushViewController(vc, animated: true)
                break
            case SETTING_OPTION_TITLE.ACTIVITY4.rawValue:
                sainiOpenUrlInSafari(strUrl: "https://beemoreactive.wixsite.com/beemoreactive/contact-us")
//                let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
//                vc.type = SETUP_ABOUT_REDIRECTION.PRIVACY_POLICY
//                self.navigationController?.pushViewController(vc, animated: true)
                break
            case SETTING_OPTION_TITLE.ACTIVITY5.rawValue:
                let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "ContactAdminVC") as! ContactAdminVC
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case SETTING_OPTION_TITLE.ACTIVITY6.rawValue:
                let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "FaqVC") as! FaqVC
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case SETTING_OPTION_TITLE.ACTIVITY7.rawValue:
                showAlertWithOption("Logout", message: "Are you sure you want to logout?", btns: ["Yes", "No"]) {
                    AppDelegate().sharedDelegate().continueToLogout()
                } completionCancel: {
                    
                }

                break
            default:
                break
        }
    }
}
