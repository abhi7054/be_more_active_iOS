//
//  MembersJoinedCell.swift
//  BMA
//
//  Created by MACBOOK on 05/07/21.
//

import UIKit
import SainiUtils

class MembersJoinedCell: UITableViewCell {

    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var createrView: sainiCardView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - configUI
    private func configUI() {
        profileImage.sainiCircle()
    }
    
}
