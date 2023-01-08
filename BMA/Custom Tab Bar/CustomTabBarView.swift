//
//  CustomTabBarView.swift
//  UrbanKiddie
//
//  Created by Rohit Saini on 10/08/18.
//  Copyright © 2018 Appknit. All rights reserved.
//

import UIKit
//MARK:- Custom Delegate Method for Selecting Tab Bar Button
protocol CustomTabBarViewDelegate
{
    func tabSelectedAtIndex(index:Int)
}

class CustomTabBarView: UIView {
    
    @IBOutlet weak var backView4: UIView!
    @IBOutlet weak var backView3: UIView!
    @IBOutlet weak var backView2: UIView!
    @IBOutlet weak var backView1: UIView!
    
    @IBOutlet weak var Btn1: UIButton!
    @IBOutlet weak var Btn2: UIButton!
    @IBOutlet weak var Btn3: UIButton!
    @IBOutlet weak var Btn4: UIButton!
    
    @IBOutlet weak var Lbl1: UILabel!
    @IBOutlet weak var Lbl2: UILabel!
    @IBOutlet weak var Lbl3: UILabel!
    @IBOutlet weak var Lbl4: UILabel!
    
    @IBOutlet weak var tabBackView: UIView!
    
    var lastIndex : NSInteger!
    var delegate:CustomTabBarViewDelegate? // delegate variable
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    convenience init(frame: CGRect, title: String) {
        self.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
        tabBackView.layer.masksToBounds = false
        tabBackView.addBorderColorWithCornerRadius(borderColor: #colorLiteral(red: 0.8980392157, green: 0.8941176471, blue: 0.8941176471, alpha: 1), borderWidth: 1, cornerRadius: 0)
    }
    
    func initialize() {
        lastIndex = 0
    }
    
    //MARK: - tabBtnClicked
    @IBAction func tabBtnClicked(_ sender: Any)
      {
        let btn: UIButton? = (sender as? UIButton)
        lastIndex = (btn?.tag)!-1

          resetAllButton()
          selectTabButton()
        
      }
    
    //MARK:- Reset All Button
    func resetAllButton()
    {
        Btn1.isSelected = false
        Btn2.isSelected = false
        Btn3.isSelected = false
        Btn4.isSelected = false
        
        backView1.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        backView2.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        backView3.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        backView4.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        Lbl1.isHidden = true
        Lbl2.isHidden = true
        Lbl3.isHidden = true
        Lbl4.isHidden = true
    }
    
    
    //MARK:- Select Tab Button
    func selectTabButton()
    {
        switch lastIndex {
        case 0:
            Btn1.isSelected = true
            Lbl1.isHidden = false
            backView1.backgroundColor = AppColors.themeColor
            break
        case 1:
            Btn2.isSelected = true
            Lbl2.isHidden = false
            backView2.backgroundColor = AppColors.themeColor
           
            break
        case 2:
            Btn3.isSelected = true
            Lbl3.isHidden = false
            backView3.backgroundColor = AppColors.themeColor
            
            break
        case 3:
            Btn4.isSelected = true
            Lbl4.isHidden = false
            backView4.backgroundColor = AppColors.themeColor
            
            break
        default:
            break
            
        }
        delegate?.tabSelectedAtIndex(index: lastIndex)//Delegate Method
    }
    
    //MARK:- Select Tab Button
    func selectNotificatoinTabButton(index: Int)
    {
        switch index {
        case 0:
            Btn1.isSelected = true
            Lbl1.isHidden = false
            backView1.backgroundColor = AppColors.themeColor
            break
        case 1:
            Btn2.isSelected = true
            Lbl2.isHidden = false
            backView2.backgroundColor = AppColors.themeColor
           
            break
        case 2:
            Btn3.isSelected = true
            Lbl3.isHidden = false
            backView3.backgroundColor = AppColors.themeColor
            
            break
        case 3:
            Btn4.isSelected = true
            Lbl4.isHidden = false
            backView4.backgroundColor = AppColors.themeColor
            
            break
        default:
            break
            
        }
        delegate?.tabSelectedAtIndex(index: index)//Delegate Method
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
