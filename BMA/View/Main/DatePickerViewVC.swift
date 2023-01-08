//
//  DatePickerViewVC.swift
//  Reeveal
//
//  Created by Keyur on 30/06/21.
//  Copyright © 2021 Keyur Akbari. All rights reserved.
//

import UIKit

class DatePickerViewVC: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setupDatePickerDetails(title : String, selected : Date?, minDate : Date?, maxDate : Date?) {
        self.datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            self.datePicker.preferredDatePickerStyle = .inline
        } else {
            
        }
        delay(0.0) {
            self.titleLbl.text = getTranslate(title)
            self.datePicker.minimumDate = minDate
            self.datePicker.maximumDate = maxDate
            if selected != nil {
                self.datePicker.date = selected!
            }
            
        }
    }
    
    func setupTimePickerDetails(title : String, selected : Date?) {
        self.datePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            self.datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        delay(0.0) {
            self.titleLbl.text = getTranslate(title)
            if selected != nil {
                self.datePicker.date = selected!
            }
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
