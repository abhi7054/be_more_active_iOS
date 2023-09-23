//
//  Utility.swift
//  CollectionApp
//
//  Created by MACBOOK on 17/10/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation
import SainiUtils
import SDWebImage
import Toast_Swift
import SafariServices
import Foundation
import EventKit
import MapKit
import Lightbox

extension UIView {
    //MARK: - addBorderColorWithCornerRadius
    func addBorderColorWithCornerRadius(borderColor: CGColor, borderWidth: CGFloat, cornerRadius: CGFloat) {
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
    }
}

//MARK:- toJson
func toJson(_ dict:[String:Any]) -> String{
    let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
    let jsonString = String(data: jsonData!, encoding: .utf8)
    return jsonString!
}

//MARK: - getCurrentTimeStampValue
func getCurrentTimeStampValue() -> String
{
    return String(format: "%0.0f", Date().timeIntervalSince1970*1000)
}

//MARK: - DataExtension
extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }

}

//MARK:- Delay Features
func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

//MARK:- Toast
func displayToast(_ message:String)
{
    UIApplication.topViewController()?.view.makeToast(getTranslate(message))
}


func displayToastWithDelay(_ message:String)
{
    delay(0.2) {
        UIApplication.topViewController()?.view.makeToast(getTranslate(message))
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

//MARK:- Image Function
func compressImageView(_ image: UIImage, to toSize: CGSize) -> UIImage {
    var actualHeight: Float = Float(image.size.height)
    var actualWidth: Float = Float(image.size.width)
    let maxHeight: Float = Float(toSize.height)
    //600.0;
    let maxWidth: Float = Float(toSize.width)
    //800.0;
    var imgRatio: Float = actualWidth / actualHeight
    let maxRatio: Float = maxWidth / maxHeight
    //50 percent compression
    if actualHeight > maxHeight || actualWidth > maxWidth {
        if imgRatio < maxRatio {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight
            actualWidth = imgRatio * actualWidth
            actualHeight = maxHeight
        }
        else if imgRatio > maxRatio {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth
            actualHeight = imgRatio * actualHeight
            actualWidth = maxWidth
        }
        else {
            actualHeight = maxHeight
            actualWidth = maxWidth
        }
    }
    let rect = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(actualWidth), height: CGFloat(actualHeight))
    UIGraphicsBeginImageContext(rect.size)
    image.draw(in: rect)
    let img: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
    let imageData1: Data? = img?.jpegData(compressionQuality: 1.0)//UIImageJPEGRepresentation(img!, CGFloat(1.0))//UIImage.jpegData(img!)
    UIGraphicsEndImageContext()
    return  imageData1 == nil ? image : UIImage(data: imageData1!)!
}

//MARK:- Loader
func showLoader()
{
    AppDelegate().sharedDelegate().showLoader()
}

// MARK: - removeLoader
func removeLoader()
{
    AppDelegate().sharedDelegate().removeLoader()
}

//Image Compression to 10th
func compressImage(image: UIImage) -> Data {
    // Reducing file size to a 10th
    var actualHeight : CGFloat = image.size.height
    var actualWidth : CGFloat = image.size.width
    let maxHeight : CGFloat = 1920.0
    let maxWidth : CGFloat = 1080.0
    var imgRatio : CGFloat = actualWidth/actualHeight
    let maxRatio : CGFloat = maxWidth/maxHeight
    var compressionQuality : CGFloat = 0.5
    if (actualHeight > maxHeight || actualWidth > maxWidth) {
        if (imgRatio < maxRatio) {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        } else if (imgRatio > maxRatio) {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        } else {
            actualHeight = maxHeight
            actualWidth = maxWidth
            compressionQuality = 1
        }
    }
    let rect = CGRect(x: 0.0, y: 0.0, width:actualWidth, height:actualHeight)
    UIGraphicsBeginImageContext(rect.size)
    image.draw(in: rect)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    let imageData = img!.jpegData(compressionQuality: compressionQuality)
    UIGraphicsEndImageContext();
    return imageData!
}

//func showAlert(_ title:String, message:String, completion: @escaping () -> Void) {
//    let myAlert = UIAlertController(title:NSLocalizedString(title, comment: ""), message:NSLocalizedString(message, comment: ""), preferredStyle: UIAlertController.Style.alert)
//    myAlert.view.tintColor = AppColors.LoaderColor
//    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler:{ (action) in
//        completion()
//    })
//    myAlert.addAction(okAction)
//    AppDelegate().sharedDelegate().window?.rootViewController?.present(myAlert, animated: true, completion: nil)
//}
//
//func showAlertWithOption(_ title:String, message:String, btns:[String] ,completionConfirm: @escaping () -> Void,completionCancel: @escaping () -> Void){
//    let myAlert = UIAlertController(title:NSLocalizedString(title, comment: ""), message:NSLocalizedString(message, comment: ""), preferredStyle: UIAlertController.Style.alert)
//    let rightBtn = UIAlertAction(title: NSLocalizedString(btns[0], comment: ""), style: UIAlertAction.Style.default, handler: { (action) in
//        completionCancel()
//    })
//    let leftBtn = UIAlertAction(title: NSLocalizedString(btns[1], comment: ""), style: UIAlertAction.Style.cancel, handler: { (action) in
//        completionConfirm()
//    })
//    myAlert.addAction(rightBtn)
//    myAlert.addAction(leftBtn)
//    AppDelegate().sharedDelegate().window?.rootViewController?.present(myAlert, animated: true, completion: nil)
//}

func openMapForPlace(_ lat : Double, _ long: Double, _ address: String) {
    let latitude: CLLocationDegrees = lat
    let longitude: CLLocationDegrees = long

    let regionDistance:CLLocationDistance = 10000
    let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
    let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
    let options = [
        MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
        MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
    ]
    let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = address
    mapItem.openInMaps(launchOptions: options)
}

//MARK: - downloadCachedImage
extension UIImageView{
    //MARK: - downloadCachedImage
        func downloadCachedImage(placeholder: String,urlString: String){
            //Progressive Download
            //This flag enables progressive download, the image is displayed progressively during download as a browser would do. By default, the image is only displayed once completely downloaded.
            //so this flag provide a better experience to end user
            let options: SDWebImageOptions = [.scaleDownLargeImages, .continueInBackground]
            let placeholder = UIImage(named: placeholder)
            DispatchQueue.global().async {
                print(urlString)
                self.sd_setImage(with: URL(string: urlString), placeholderImage: placeholder, options: options) { (image, _, cacheType,_ ) in
                    guard image != nil else {
                        return
                    }
                    //Loading cache images for better and fast performace
                    guard cacheType != .memory, cacheType != .disk else {
                        DispatchQueue.main.async {
                            self.image = image
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        self.image = image
                    }
                    return
                }
            }
        }
}

//MARK: - setCornerRadius
func setCornerRadius(_ view : UIView, _ addRadius : Bool, _ radius: Int) {
    var newFrame = view.frame
    newFrame.size.width = SCREEN.WIDTH
    view.frame = newFrame
    
    if addRadius {
        view.sainiRoundCorners([.topLeft,.topRight], radius: CGFloat(radius))
    }
}

//MARK:- roundViewCorner
open class roundViewCorner: UIView {
    @IBInspectable var cornerRadius : CGFloat = 5
    @IBInspectable var topLeft: Bool = false
    @IBInspectable var topRight: Bool = false
    @IBInspectable var bottomLeft: Bool = false
    @IBInspectable var bottomRight: Bool = false
    override open func layoutSubviews(){
        var options = UIRectCorner()
        if topLeft {
            options = options.union(.topLeft)
        }
        if topRight {
            options = options.union(.topRight)
        }
        if bottomLeft {
            options = options.union(.bottomLeft)
        }
        if bottomRight {
            options = options.union(.bottomRight)
        }
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: options, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

//MARK: - height of a label
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    //MARK: - isValidEmail
    var isValidEmail: Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    // MARK: - isValidUrl
    var isValidUrl : Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: self)
        return result
    }
}

//MARK: - displaySubViewtoParentView
func displaySubViewtoParentView(_ parentview: UIView! , subview: UIView!)
{
    subview.translatesAutoresizingMaskIntoConstraints = false
    parentview.addSubview(subview);
    parentview.addConstraint(NSLayoutConstraint(item: subview!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0))
    parentview.addConstraint(NSLayoutConstraint(item: subview!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0))
    parentview.addConstraint(NSLayoutConstraint(item: subview!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0))
    parentview.addConstraint(NSLayoutConstraint(item: subview!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0))
    parentview.layoutIfNeeded()
}

func getTranslate(_ str : String) -> String
{
    return NSLocalizedString(str, comment: "")
}

//MARK:- Color function
func colorFromHex(hex : String) -> UIColor
{
    return colorWithHexString(hex, alpha: 1.0)
}

func colorFromHex(hex : String, alpha:CGFloat) -> UIColor
{
    return colorWithHexString(hex, alpha: alpha)
}

func colorWithHexString(_ stringToConvert:String, alpha:CGFloat) -> UIColor {
    
    var cString:String = stringToConvert.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: alpha
    )
}

//MARK:- UICollectionView
extension UICollectionView {
   //MARK:- setEmptyMessage
   public func sainiSetEmptyMessageCV(_ message: String) {
       let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
       messageLabel.text = message
       messageLabel.textColor = .black
       messageLabel.numberOfLines = 0;
       messageLabel.textAlignment = .center;
       messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
       messageLabel.sizeToFit()
       self.backgroundView = messageLabel;
    
   }
   //MARK:- sainiRestore
   public func restore() {
       self.backgroundView = nil
       
   }
}

func getBeforeTimeInMinute(_ index: Int) -> Int {
    switch index {
    case 0:
        return 5
    case 1:
        return 10
    case 2:
        return 15
    case 3:
        return 30
    case 4:
        return 60
    case 5:
        return 1440
    default:
        return 0
    }
}

func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}

//MARK:- Get Json from file
func getJsonFromFile(_ file : String) -> [[String : Any]]
{
    if let filePath = Bundle.main.path(forResource: file, ofType: "json"), let data = NSData(contentsOfFile: filePath) {
        do {
            if let json : [[String : Any]] = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments) as? [[String : Any]] {
                return json
            }
        }
        catch {
            //Handle error
        }
    }
    return [[String : Any]]()
}

// MARK: - getCompleteString
func getCompleteString(strArr: [String]) -> String {
    var str: String = String()
    for i in 0..<strArr.count {
        if i == strArr.count - 1 {
            str += strArr[i]
        }
        else {
            str += (strArr[i]) + ", "
        }
    }
    return str
}

//MARK: - Add event in to default calender
//Give info.plist permission "Privacy - Calendars Usage Description"
//import EventKit
func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, url: String, beforTime: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
    DispatchQueue.global(qos: .background).async { () -> Void in
        let eventStore = EKEventStore()

        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                if url != "" {
                    event.url = URL(string: url)
                }
                event.calendar = eventStore.defaultCalendarForNewEvents
                
//                let maxDate : Date = Calendar.current.date(byAdding: .minute, value: -getBeforeTimeInMinute(beforTime), to: startDate)!
                event.alarms = [EKAlarm.init(absoluteDate: beforTime)]
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    print("failed to save event with error : \(error)")
                    completion?(false, e)
                    return
                }
                print("Saved Event")
                completion?(true, nil)
            } else {
                print("failed to save event with error : \(error) or access not granted")
                completion?(false, error as NSError?)
            }
        })
    }
}


//MARK:- Open Url
func openUrlInSafari(strUrl: String)
{
    if strUrl == "" {
        return
    }
    
    let webUrl = strUrl
    if webUrl.hasPrefix("https://") || webUrl.hasPrefix("http://"){
        guard let url = URL(string: webUrl) else {
            return //be safe
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }else {
        let correctedURL = "http://\(webUrl)"
        let escapedAddress = correctedURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        guard let url = URL(string: escapedAddress ?? "") else {
            return //be safe
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

//MARK:- Email
func redirectToEmail(_ email : String)
{
    if email == "" || !email.isValidEmail {
        displayToast("Invalid email address")
        return
    }
    guard let url = URL(string: "mailto:\(email)") else {
        displayToast("Invalid email address")
        return
    }
    if #available(iOS 10.0, *) {
        UIApplication.shared.open(url)
    } else {
        UIApplication.shared.openURL(url)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIWindow{
    //MARK: - visibleViewController
    var visibleViewController:UIViewController?{
        return UIWindow.visibleVC(vc:self.rootViewController)
    }
    static func visibleVC(vc: UIViewController?) -> UIViewController?{
        if let navigationViewController = vc as? UINavigationController{
            return UIWindow.visibleVC(vc:navigationViewController.visibleViewController)
        }
        else if let tabBarVC = vc as? UITabBarController{
            return UIWindow.visibleVC(vc:tabBarVC.selectedViewController)
        }
        else{
            if let presentedVC = vc?.presentedViewController{
                return UIWindow.visibleVC(vc:presentedVC)
            }
            else{
                return vc
            }
        }
    }
}

public func visibleViewController() -> UIViewController?{
    return UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.visibleViewController
}

//MARK:- Reminder
//func setReminder() {
//    self.SOGetPermissionCalendarAccess()
//}
//
//
//func SOGetPermissionCalendarAccess() {
//    switch EKEventStore.authorizationStatus(for: .event) {
//        case .authorized:
//            printData("Authorised")
//            addReminder()
//            break
//        case .denied:
//            printData("Access denied")
//            break
//        case .notDetermined:
//            eventStore.requestAccess(to: .event, completion:
//                {(granted, error) in
//                    if !granted {
//                        printData("Access to store not granted")
//                        self.addReminder()
//                    }
//            })
//            break
//        default:
//            printData("Case Default")
//    }
//}
//
//func addReminder()
//{
//    if let tempDate = getDateFromDateString(strDate: auction.auction_end, format: "YYYY-MM-dd") {
//        var reminderDate = tempDate
//        if hour24Btn.isSelected {
//            reminderDate = Calendar.current.date(byAdding: .hour, value: -24, to: tempDate)!
//        }
//        else if hour48Btn.isSelected {
//            reminderDate = Calendar.current.date(byAdding: .hour, value: -48, to: tempDate)!
//        }
//        else if hour72Btn.isSelected {
//            reminderDate = Calendar.current.date(byAdding: .hour, value: -72, to: tempDate)!
//        }
//        let event:EKEvent = EKEvent(eventStore: eventStore)
//        event.title = auction.auction_title
//        event.startDate = reminderDate
//        event.endDate = reminderDate
//        event.calendar = eventStore.defaultCalendarForNewEvents
//        do {
//            try eventStore.save(event, span: .thisEvent)
//            setNewReminder(auction.auctionid, event.eventIdentifier)
//            self.hour24Btn.isSelected = false
//            self.hour48Btn.isSelected = false
//            self.hour72Btn.isSelected = false
//        } catch let e as NSError {
//            printData(e.description)
//            return
//        }
//    }
//}
//
//func deleteReminder()
//{
//    let tempData = getReminderData()
//    if tempData[auction.auctionid] == nil {
//        return
//    }
//    if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
//        eventStore.requestAccess(to: .event, completion: { (granted, error) -> Void in
//            self.deleteEvent(eventStore: self.eventStore, eventIdentifier: tempData[self.auction.auctionid] as! String)
//        })
//    } else {
//        self.deleteEvent(eventStore: eventStore, eventIdentifier: tempData[auction.auctionid] as! String)
//    }
//}
//
//func deleteEvent(eventStore: EKEventStore, eventIdentifier: String) {
//    let eventToRemove = eventStore.event(withIdentifier: eventIdentifier)
//    if (eventToRemove != nil) {
//        do {
//            try eventStore.remove(eventToRemove!, span: .thisEvent, commit: true)
//            try eventStore.remove(eventToRemove!, span: .futureEvents, commit: true)
//            printData("Remove")
//        } catch {
//            printData(error.localizedDescription)
//        }
//    }
//}

//MARK:- Attribute string
func attributedStringWithColor(_ mainString : String, _ strings: [String], color: UIColor, font: UIFont? = nil) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: mainString)
    for string in strings {
        let range = (mainString as NSString).range(of: string)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        if font != nil {
            attributedString.addAttribute(NSAttributedString.Key.font, value: font!, range: range)
        }
    }
    return attributedString
}

func attributeStringStrikeThrough(_ mainString : String) -> NSAttributedString
{
    let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: mainString)
    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
    return attributeString
}

func getAttributeStringWithColor(_ main_string : String, _ substring : [String], color : UIColor?, font : UIFont?, isUnderLine : Bool) -> NSMutableAttributedString
{
    let attribute = NSMutableAttributedString.init(string: main_string)
    for sub_string in substring{
        let range = (main_string as NSString).range(of: sub_string)
        if let newColor = color{
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: newColor , range: range)
        }
        if let newFont = font {
            attribute.addAttribute(NSAttributedString.Key.font, value: newFont , range: range)
        }
        if isUnderLine{
            attribute.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range)
            if let newColor = color{
                attribute.addAttribute(NSAttributedString.Key.underlineColor , value: newColor, range: range)
            }
        }
    }
    return attribute
}

func attributedStringWithBackgroundColor(_ mainString : String, _ strings: [String], bgcolor: UIColor, font: UIFont? = nil) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: mainString)
    for string in strings {
        let range = (mainString as NSString).range(of: string)
        attributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: bgcolor, range: range)
        if font != nil {
            attributedString.addAttribute(NSAttributedString.Key.font, value: font!, range: range)
        }
    }
    return attributedString
}



//MARK:- Alert
func showAlertWithOption(_ title:String, message:String, btns:[String] ,completionConfirm: @escaping () -> Void,completionCancel: @escaping () -> Void){

    let vc : AlertViewVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "AlertViewVC") as! AlertViewVC
    displaySubViewtoParentView(AppDelegate().sharedDelegate().window, subview: vc.view)
    vc.setupDetails(title, message, btns)

    vc.cancelBtn.addAction {
        vc.view.removeFromSuperview()
        completionCancel()
    }
    vc.okBtn.addAction {
        vc.view.removeFromSuperview()
        completionConfirm()
    }
}

func showAlert(_ title:String, message:String, btn : String = "OK", completion: @escaping () -> Void) {

    let vc : AlertViewVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "AlertViewVC") as! AlertViewVC
    displaySubViewtoParentView(AppDelegate().sharedDelegate().window, subview: vc.view)
    vc.setupDetails(title, message, [btn])

    vc.fullBtn.addAction {
        vc.view.removeFromSuperview()
        completion()
    }
}

//MARK:- Date Picker
func showDatePicker(title : String, selected: Date?,  minDate : Date?, maxDate : Date?, completionDone: @escaping (_ date : Date) -> Void, completionClose: @escaping () -> Void){

    let vc : DatePickerViewVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "DatePickerViewVC") as! DatePickerViewVC
    displaySubViewtoParentView(AppDelegate().sharedDelegate().window, subview: vc.view)
    vc.setupDatePickerDetails(title: title, selected: selected, minDate: minDate, maxDate: maxDate)

    vc.closeBtn.addAction {
        vc.view.removeFromSuperview()
        completionClose()
    }
    vc.doneBtn.addAction {
        vc.view.removeFromSuperview()
        completionDone(vc.datePicker.date)
    }
}

//MARK:- Time Picker
func showTimePicker(title : String, selected: Date?, completionDone: @escaping (_ date : Date) -> Void, completionClose: @escaping () -> Void){

    let vc : DatePickerViewVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "DatePickerViewVC") as! DatePickerViewVC
    displaySubViewtoParentView(AppDelegate().sharedDelegate().window, subview: vc.view)
    vc.setupTimePickerDetails(title: title, selected: selected)

    vc.closeBtn.addAction {
        vc.view.removeFromSuperview()
        completionClose()
    }
    vc.doneBtn.addAction {
        vc.view.removeFromSuperview()
        completionDone(vc.datePicker.date)
    }
}

//MARK: - getTimestampFromDate
func getTimestampFromDate(date : Date) -> Double
{
    return date.timeIntervalSince1970
}

//MARK: - getDateFromDateString
func getDateFromDateString(strDate : String) -> Date    // Today, 09:56 AM
{
    print(strDate)
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let dt = dateFormatter.date(from: strDate)
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let date1 : String = dateFormatter.string(from: dt ?? Date())
    return dateFormatter.date(from: date1)!
}

//MARK: - getDateStringFromDateString
func getDateStringFromDateString(strDate : String, format: String) -> String    // Today, 09:56 AM
{
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let dt = dateFormatter.date(from: strDate)
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = format
    let date1 : String = dateFormatter.string(from: dt ?? Date())
    return date1
}

//MARK: - getDateStringFromDate
func getDateStringFromDate(date : Date, format : String) -> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC") //Set timezone that you want
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

extension Date {
    
    func dateString(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    var _24Format: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.string(from: self)
    }
    
    var getEventStartDate: String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = .current
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'00:00:00Z"
//        return dateFormatter.string(from: self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var strDate =  dateFormatter.string(from: self)
        strDate = strDate + " 00:00:00"
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date1 =  dateFormatter1.date(from: strDate)!
        dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter1.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let finalDate = dateFormatter1.string(from: date1)
        return finalDate
    }
    
    var getEventEndDate: String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = .current
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'23:59:59Z"
//        return dateFormatter.string(from: self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var strDate =  dateFormatter.string(from: self)
        strDate = strDate + " 23:59:59"
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date1 =  dateFormatter1.date(from: strDate)!
        dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter1.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let finalDate = dateFormatter1.string(from: date1)
        return finalDate
        
    }
}

func getEventStatus(_ status: Int) -> (String, UIColor, UIImage) {
    switch status {
    case 1:
        return ("Ongoing", .orange, UIImage(named: "ic_status_ongoing")!)
    case 2:
        return ("Upcoming", .black, UIImage(named: "ic_status_upcoming")!)
    case 3:
        return ("Cancelled", .red, UIImage(named: "ic_status_cancelled")!)
    case 4:
        return ("Completed", .systemGreen, UIImage(named: "ic_status_completed")!)
    default:
        return ("", UIColor(), UIImage())
    }
}

//MARK:- Display full image
func displayFullScreenImage(_ arrImg : [String], _ index : Int) {
    var arrLightImage = [LightboxImage]()
    for temp in arrImg {
        var strUrl = ""
        if temp.contains("https://") || temp.contains("http://") {
            strUrl = temp
        }else{
            strUrl = AppImageUrl.average + temp
        }
        arrLightImage.append(LightboxImage(imageURL: URL(string: strUrl)!))
    }
    // Create an instance of LightboxController.
    let controller = LightboxController(images: arrLightImage, startIndex: index)

    // Use dynamic background.
    controller.dynamicBackground = true

    // Present your controller.
    UIApplication.topViewController()!.present(controller, animated: true, completion: nil)
}

//MARK: - datesRange
func datesRange(from: Date, to: Date) -> [Date] {
    // in case of the "from" date is more than "to" date,
    // it should returns an empty array:
    if from > to { return [Date]() }
    
    var tempDate = from
    var array = [tempDate]
    
    while tempDate < to {
        tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
        array.append(tempDate)
    }
    
    return array
}

extension UITapGestureRecognizer {
    //MARK: - didTapAttributedTextInLabel
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y:
                                                        locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
