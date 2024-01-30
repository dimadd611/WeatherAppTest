//
//  UIStoryboard+.swift
//  WeatherApp
//
//  Created by Slava Golomoz on 30.01.2024.
//

import Foundation
import UIKit

extension UIStoryboard {
    static func instantiateViewController<T: UIViewController>(_ type: T.Type, from storyboard: String) -> T {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        guard
            let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: type)) as? T
        else {
            fatalError("Could not instantiate view controller with identifier \(String(describing: type)) from storyboard \(storyboard)")
        }
        return viewController
    }
}
