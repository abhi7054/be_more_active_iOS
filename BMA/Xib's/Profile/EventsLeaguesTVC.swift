//
//  EventsLeaguesTVC.swift
//  BMA
//
//  Created by iMac on 02/07/21.
//

import UIKit

class EventsLeaguesTVC: UITableViewCell {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var viewDetailsBtn: UIButton!
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var favBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        eventImageView.sainiCornerRadius(radius: 12)
        viewDetailsBtn.sainiCornerRadius(radius: 21)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}
