//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by admin on 30.01.2024.
//

import Foundation
enum WeatherIcon: String {
    case cloud = "cloud.fill"
    case sun = "sun.max.fill"
    case rain = "cloud.rain"
}

extension WeatherIcon {
    init(iconText: String) {
        switch iconText.lowercased() {
        case "clouds":
            self = .cloud
        case "sun":
            self = .sun
        case "rain":
            self = .rain
        case "clear":
            self = .sun
        default:
            self = .cloud
        }
    }
}
