//
//  UIInt+.swift
//  WeatherApp
//
//  Created by admin on 30.01.2024.
//

import Foundation

extension Int {
    func toDate() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yy"
            let date = Date(timeIntervalSince1970: TimeInterval(self))
            return dateFormatter.string(from: date)
        }
}
