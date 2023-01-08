//
//  AlertViewVC.swift
//  Reeveal
//
//  Created by Keyur Akbari on 12/01/21.
//  Copyright © 2021 Keyur Akbari. All rights reserved.
//

import UIKit

class AlertViewVC: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var fullBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configUI()
    }
    
    //MARK: - configUI
    private func configUI() {
        cancelBtn.layer.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 0.15)
        cancelBtn.layer.borderWidth = 1
    }
    
    func setupDetails(_ title : String, _ message : String, _ btns : [String]) {
        fullBtn.isHidden = true
        cancelBtn.isHidden = true
        okBtn.isHidden = true
        delay(0.0) {
            self.titleLbl.text = getTranslate(title)
            self.messageLbl.text = getTranslate(message)
            if btns.count == 2 {
                self.okBtn.setTitle(getTranslate(btns[0]), for: .normal)
                self.cancelBtn.setTitle(getTranslate(btns[1]), for: .normal)
                
                self.cancelBtn.isHidden = false
                self.okBtn.isHidden = false
            }else{
                self.fullBtn.setTitle(getTranslate(btns[0]), for: .normal)
                self.fullBtn.isHidden = false
            }
        }
    }
    
    @IBAction func clickToCancel(_ sender: Any) {
        
    }
    
    @IBAction func clickToOk(_ sender: Any) {
        
    }

}
