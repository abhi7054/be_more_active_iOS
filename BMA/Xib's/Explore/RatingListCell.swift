//
//  RatingListCell.swift
//  BMA
//
//  Created by MACBOOK on 06/07/21.
//

import UIKit
import SainiUtils

class RatingListCell: UITableViewCell {

    @IBOutlet weak var reviewLbl: UILabel!
    @IBOutlet weak var starRatingView: FloatRatingView!
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
