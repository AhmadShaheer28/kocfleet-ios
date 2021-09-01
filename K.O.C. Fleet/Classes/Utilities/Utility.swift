//
//  Utility.swift
//  Copyright © 2020 codesrbit. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import CoreLocation
import SkeletonView




struct NetworkingConnection {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}


@objc class Utility: NSObject {
    
    var window: UIWindow?
    static let gradient = SkeletonGradient(baseColor: #colorLiteral(red: 0.6588235294, green: 0.6549019608, blue: 0.6549019608, alpha: 1))
    static let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
    
    
    class func getAppDelegate() -> AppDelegate? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate
    }
    
    
    class func setHomeControllerAsRootViewController () {
        let vc = HomeViewController()
        let navigationController = UINavigationController()
        navigationController.viewControllers = [vc]
        navigationController.navigationBar.isHidden = true
        kApplicationWindow = UIWindow(frame: UIScreen.main.bounds)
        kApplicationWindow?.rootViewController = navigationController
        kApplicationWindow?.makeKeyAndVisible()
    }
    
    class func setAuthAsRootViewController() {
        let vc = AuthViewController()
        let navigationController = UINavigationController()
        navigationController.viewControllers = [vc]
        navigationController.navigationBar.isHidden = true
        kApplicationWindow = UIWindow(frame: UIScreen.main.bounds)
        kApplicationWindow?.rootViewController = navigationController
        kApplicationWindow?.makeKeyAndVisible()
    }
    
    class func logoutAppication() {
    }
    
    
    class func takeScreenShot (view: UIView) {

        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        screenImage = image!
        
    }
    
    
    class func setPlaceHolderTextColor (_ textField: UITextField, _ text: String, _ color: UIColor) {
        textField.attributedPlaceholder = NSAttributedString(string: text,
                                                             attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    class func cornerRadiusPostioned (corners: CACornerMask, view: UIView, cornerRadius: CGFloat) {
        view.layer.cornerRadius = cornerRadius
        view.layer.maskedCorners = corners
        view.clipsToBounds = true
        view.layoutIfNeeded()
    }
    
    class func changeFontSizeRange (mainString: String, stringToChange: String) ->  NSMutableAttributedString {
        let font = UIFont.systemFont(ofSize: 11)
        let range = (mainString as NSString).range(of: stringToChange)
        
        let attribute = NSMutableAttributedString.init(string: mainString)
        attribute.addAttribute(NSAttributedString.Key.font, value: font , range: range)
        return attribute
    }
    
    class func changeFontStyleToBold (mainString: String, stringToChange: String) ->  NSMutableAttributedString {
        let font = UIFont(name: "SFProText-Bold", size: 15)!
        let range = (mainString as NSString).range(of: stringToChange)
        
        let attribute = NSMutableAttributedString.init(string: mainString)
        attribute.addAttribute(NSAttributedString.Key.font, value: font , range: range)
        return attribute
    }
    
    class func addTextFieldLeftViewImage(_ textField: UITextField, image: UIImage, width: Int, height: Int, leftPadding: Int, topPadding: Int) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width + leftPadding + 5, height: height + topPadding))
        let imageView = UIImageView(frame: CGRect(x: leftPadding, y: topPadding, width: width, height: height))
        imageView.image = image
        view.addSubview(imageView)
        
        textField.leftViewMode = .always
        textField.leftView = view
    }
    
    class  func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    static func isValidPhoneNumber(_ testStr:String) -> Bool {
        let emailRegEx = "^(\\d){10}$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func getScreenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    class func getScreenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    class func hasTopNotch() -> Bool {
        
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        
        return false
    }
    
    class func makeBlurImage(targetImageView:UIImageView?, alpha: CGFloat = 1) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = targetImageView!.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        blurEffectView.alpha = alpha
        targetImageView?.addSubview(blurEffectView)
    }
    
    class func removeBlurFromImage(targetImageView: UIImageView?) {
        
        let blurViews = targetImageView?.subviews.filter({ (view) -> Bool in
            view.isKind(of: UIVisualEffectView.self)
        })
        
        blurViews?.forEach({ (view) in
            view.removeFromSuperview()
        })
    }
    
        @objc class func showLoading(offSet: CGFloat = 0, isVisible: Bool = true) {
    
            if let _ = kApplicationWindow?.viewWithTag(9000) {
                return
            }
    
            let superView = UIView(frame: CGRect(x: 0, y: 0 - offSet, width: kApplicationWindow?.frame.width ?? 0.0, height: kApplicationWindow?.frame.height ?? 0.0))
            let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: superView.frame.width/2 - 32.5, y: superView.frame.height/2 - 32.5, width: 65, height: 65))
            let iconImageView = UIImageView(frame: CGRect(x: superView.frame.width/2 - 32.5, y: superView.frame.height/2 - 32.5, width: 65, height: 65))
            //iconImageView.image = #imageLiteral(resourceName: "loaderLogo")
    
            if isVisible {
                superView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                activityIndicator.color = #colorLiteral(red: 0.08270116895, green: 0.1508052945, blue: 0.2132219672, alpha: 1)
    
            } else {
                superView.backgroundColor = .clear
                activityIndicator.color = .clear
            }
    
            superView.tag = 9000
            activityIndicator.type = .ballSpinFadeLoader
            activityIndicator.startAnimating()
            superView.addSubview(iconImageView)
            superView.addSubview(activityIndicator)
            superView.bringSubviewToFront(activityIndicator)
            superView.bringSubviewToFront(iconImageView)
            kApplicationWindow?.addSubview(superView)
        }
    
        @objc class func hideLoading() {
            if let activityView = kApplicationWindow?.viewWithTag(9000) {
                activityView.removeFromSuperview()
            }
        }
    
    class func simpleDate (date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
    
    
    
    class func matchDates(dataInString : String) -> Int {
        
        let calendar = Calendar.current
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"
        
        guard let startDate = dateFormatter.date(from: dataInString) else {
            return 0
        }
        let endDate = Date()
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: startDate)
        let date2 = calendar.startOfDay(for: endDate)
        
        let components = calendar.dateComponents([.month], from: date2, to: date1)
        
        return components.month ?? 0
    }
    
    class func changeTimeFormate (dataInString : String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let localDate = dateFormatter.date(from: dataInString)
        
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "hh:mm a"
        if localDate != nil {
            return dateFormatter.string(from: localDate!)
            
        } else {
            return ""
        }
    }
    
    class func dateInEnglish (_ dataInString : String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        let localDate = dateFormatter.date(from: dataInString)
        
        let calendar = Calendar.current
        
        if localDate != nil {
            
            if calendar.isDateInYesterday(localDate!) {
                return "Yesterday"
            } else if calendar.isDateInToday(localDate!) {
                return "Today"
            } else {
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                dateFormatter.dateFormat = "MMM dd, yyyy"
                if localDate != nil {
                    return dateFormatter.string(from: localDate!)
                    
                } else {
                    return ""
                }
            }
        }
        return ""
    }
    
    class func getAddressFromLatLon(lat: Double, long: Double) -> String{
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        var addressString : String = ""
        center.latitude = lat
        center.longitude = long
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
                                        
                                        if (error != nil)
                                        {
                                            print("reverse geodcode fail: \(error!.localizedDescription)")
                                        }
                                        
                                        if let pm = placemarks {
                                            
                                            if pm.count > 0 {
                                                
                                                let pm = placemarks![0]
                                                
                                                if pm.subLocality != nil {
                                                    addressString = addressString + pm.subLocality! + ", "
                                                }
                                                
                                                if pm.thoroughfare != nil {
                                                    addressString = addressString + pm.thoroughfare! + ", "
                                                }
                                                
                                                if pm.locality != nil {
                                                    addressString = addressString + pm.locality! + ", "
                                                }
                                                
                                                if pm.country != nil {
                                                    addressString = addressString + pm.country! + ", "
                                                }
                                                
                                                if pm.postalCode != nil {
                                                    addressString = addressString + pm.postalCode! + " "
                                                }
                                                
                                                if addressString == "" {
                                                    print("No address found")
                                                    
                                                } else {
                                                    print(addressString)
                                                }
                                            }
                                        }
                                    })
        return addressString
    }
}
