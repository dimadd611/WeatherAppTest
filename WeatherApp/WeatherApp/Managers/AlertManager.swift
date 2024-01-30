//
//  AlertManager.swift
//  WeatherApp
//
//  Created by admin on 30.01.2024.
//

import Foundation
import UIKit

class AlertManager {
    
    // Singleton instance
    static let shared = AlertManager()
    
    private init() {}
    
    func showAlert(title: String?, message: String?, actions: [UIAlertAction] = [], preferredStyle: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        // Add custom actions
        for action in actions {
            alertController.addAction(action)
        }
        
        // If there are no custom actions, add a default "OK" action
        if actions.isEmpty {
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
        }
        
        // Get the topmost view controller
        if let topViewController = UIApplication.topViewController() {
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
