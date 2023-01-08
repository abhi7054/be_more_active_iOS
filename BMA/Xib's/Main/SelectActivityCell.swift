//
//  SelectActivityCell.swift
//  BMA
//
//  Created by MACBOOK on 30/06/21.
//

import UIKit

class SelectActivityCell: UITableViewCell {

    @IBOutlet weak var activityNameLbl: UILabel!
    @IBOutlet weak var checkboxImage: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
