//
//  NotificationCell.swift
//  Event App
//
//  Created by MACBOOK on 08/12/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit

class NotificationTVC: UITableViewCell {
    
    // OUTLETS
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var notiBadgeImg: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    //MARK: - configUI
    private func configUI() {
        userImage.sainiCornerRadius(radius: userImage.frame.size.width/2)
    }
    
}
