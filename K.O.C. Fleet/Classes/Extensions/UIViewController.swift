//
//  UIViewController.swift
//

import Foundation
import UIKit

extension UIViewController {
    
    var isModal: Bool {
        
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertAction(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertAndPopToDestination(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: HomeViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func popToRootViewController() {

        for controller in (self.navigationController!.viewControllers) as Array {
            if controller.isKind(of: HomeViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func showOkAlertWithOKCompletionHandler(_ msg: String, completion: @escaping (UIAlertAction) -> Void){
        let alert = UIAlertController(title:"", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: completion)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func topMostViewController() -> UIViewController {

           if let navigation = self as? UINavigationController {
               return navigation.visibleViewController!.topMostViewController()
           }

           if self.presentedViewController == nil {
               return self
           }

           if let navigation = self.presentedViewController as? UINavigationController {
               return navigation.visibleViewController!.topMostViewController()
           }

           if let tab = self.presentedViewController as? UITabBarController {

               if let selectedTab = tab.selectedViewController {
                   return selectedTab.topMostViewController()
               }
               return tab.topMostViewController()
           }

           return self.presentedViewController!.topMostViewController()
    }
}
