//
//  AddCouponVC.swift
//  BMA
//
//  Created by iMac on 02/07/21.
//

import UIKit

class AddCouponVC: UIViewController {
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var discountCouponTxt: UITextField!
    @IBOutlet weak var descTxtview: UITextView!
    
    var DiscountAddVM : DiscountAddViewModel = DiscountAddViewModel()
    var DiscountListVM : DiscountListViewModel = DiscountListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    func configUI() {
        addBtn.sainiCornerRadius(radius: 10)
        DiscountAddVM.delegate = self
    }
    
    //MARK:- Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToAdd(_ sender: Any) {
        self.view.endEditing(true)
        guard let discountCoupon = discountCouponTxt.text else { return }
        guard let descTxt = descTxtview.text else { return }
        if discountCoupon == DocumentDefaultValues.Empty.string {
            displayToast(getTranslate("enter_coupon"))
        }
        else if descTxt == DocumentDefaultValues.Empty.string {
            displayToast(getTranslate("enter_discription"))
        }
        else {
            let request = DiscountAddRequest(discountCode: discountCoupon, description: descTxt)
            DiscountAddVM.DiscountAdd(request: request)
        }
        
    }
}

extension AddCouponVC: DiscountAddDelegate {
    func didRecieveDiscountAddResponse(response: AddDiscountResponse) {
        if let newDiscount = response.data {
            DiscountListVM.discountList.value.append(newDiscount)
        }
        delay(0.1) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
