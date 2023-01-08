//
//  MyBookingTVC.swift
//  BMA
//
//  Created by iMac on 01/07/21.
//

import UIKit

class MyBookingTVC: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configUI()
    }
 
    func setupDetails(_ dict : BookingListModel) {
        profileImg.downloadCachedImage(placeholder: PLACEHOLDER.profile_img.getValue(), urlString: AppImageUrl.average + (dict.images.first ?? ""))
        nameLbl.text = dict.name
        dateLbl.text = getDateStringFromDateString(strDate: dict.startDate, format: "dd-MMM-yyyy") + " - " + getDateStringFromDateString(strDate: dict.endDate, format: "dd-MMM-yyyy")
        timeLbl.text = getDateStringFromDateString(strDate: dict.startTime, format: "hh:mm a") //+ "-" + getDateStringFromDateString(strDate: dict.endTime, format: "hh:mm a")
        statusLbl.text = getEventStatus(dict.status).0
        statusLbl.textColor = getEventStatus(dict.status).1
    }
    
    func configUI() {
        profileImg.sainiCornerRadius(radius: 33)
        cellView.sainiShadowWithCornerRadius(shadowColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), shadowOpacity: 0.2, shadowRadius: 4, cornerRadius: 10)
        cellView.layoutIfNeeded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    
}
