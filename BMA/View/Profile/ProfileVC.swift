//
//  ProfileVC.swift
//  BMA
//
//  Created by iMac on 02/07/21.
//

import UIKit

class ProfileVC: UIViewController {
    
    //OUTLETS
    @IBOutlet weak var bottomConstraintOfTableView: NSLayoutConstraint!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var constraintHeightProfileTableView: NSLayoutConstraint!
    @IBOutlet weak var profileUserImage: UIImageView!
    @IBOutlet weak var profileUserNameLbl: UILabel!
    @IBOutlet weak var profileUserEmailLbl: UILabel!
    @IBOutlet weak var profileUserAddressLbl: UILabel!
    @IBOutlet weak var profileOptionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate().sharedDelegate().showTabBar()
        if SCREEN.HEIGHT >= 812 {
            bottomConstraintOfTableView.constant = 76
        } else {
            bottomConstraintOfTableView.constant = 56
        }
        
        dataRender()
    }
    
    func configUI() {
        registerTableviewMethod()
        profileOptionView.sainiCornerRadius(radius: 20)
        delay(0.5) {
            self.profileTableView.reloadData()
        }
        
    }
    
    func dataRender() {
        if let userData = AppModel.shared.currentUser {
            profileUserImage.downloadCachedImage(placeholder: PLACEHOLDER.profile_img.getValue(), urlString: AppImageUrl.average + (userData.picture ))
            profileUserNameLbl.text = userData.name
            profileUserEmailLbl.text = userData.email
            profileUserAddressLbl.text = userData.location?.location
        }
    }
    
    @IBAction func clickToEditProfile(_ sender: Any) {
        let vc = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


//MARK: - TableView Delegate
extension ProfileVC : UITableViewDelegate, UITableViewDataSource {
    
    func registerTableviewMethod() {
        profileTableView.register(UINib.init(nibName: TABLE_VIEW_CELL.ProfileTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLE_VIEW_CELL.ProfileTVC.rawValue)
        updateProfileTableHeight()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return USER_PROFILE_OPTIONS.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "ProfileTVC", for: indexPath) as! ProfileTVC
        
        cell.userOptionLbl.text = getTranslate(USER_PROFILE_OPTIONS.list[indexPath.row])
        cell.userOptionImage.image = UIImage.init(named: USER_PROFILE_OPTION_IMG.list[indexPath.row])
        cell.cellView.sainiShadowWithCornerRadius(shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), shadowOpacity: 0.2, shadowRadius: 2, cornerRadius: 5)
    
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch USER_PROFILE_OPTIONS.list[indexPath.row] {
            case USER_PROFILE_OPTIONS.OPTIONS1.rawValue:
                let vc: EventsLeaguesPostedVC = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "EventsLeaguesPostedVC") as! EventsLeaguesPostedVC
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case USER_PROFILE_OPTIONS.OPTIONS2.rawValue:
                let vc: MyFavoritesVC = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "MyFavoritesVC") as! MyFavoritesVC
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case USER_PROFILE_OPTIONS.OPTIONS3.rawValue:
                let vc: MySubscriptionVC = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "MySubscriptionVC") as! MySubscriptionVC
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case USER_PROFILE_OPTIONS.OPTIONS4.rawValue:
                let vc: MyCouponVC = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "MyCouponVC") as! MyCouponVC
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case USER_PROFILE_OPTIONS.OPTIONS5.rawValue:
                let vc: SettingVC = STORYBOARD.PROFILE.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
                self.navigationController?.pushViewController(vc, animated: true)
                break
            default:
                break
        }
    }
    
    func updateProfileTableHeight() {
      constraintHeightProfileTableView.constant = CGFloat.greatestFiniteMagnitude
      profileTableView.reloadData()
      profileTableView.layoutIfNeeded()
      constraintHeightProfileTableView.constant = profileTableView.contentSize.height
    }
}
