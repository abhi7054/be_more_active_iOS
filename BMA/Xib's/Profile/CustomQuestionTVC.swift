//
//  CustomQuestionTVC.swift
//  BMA
//
//  Created by iMac on 04/08/20.
//  Copyright © 2020 AppKnit. All rights reserved.
//

import UIKit

class CustomQuestionTVC: UITableViewCell {

    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var questionBtn: UIButton!
    @IBOutlet weak var answerLbl: UILabel!
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var bottomBorderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
}
