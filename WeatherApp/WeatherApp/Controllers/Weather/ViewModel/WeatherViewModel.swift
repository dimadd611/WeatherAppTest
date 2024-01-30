//
//  ViewModel.swift
//  WeatherApp
//
//  Created by Slava Golomoz on 30.01.2024.
//

import Foundation
import CoreLocation

protocol WeatherViewModel {
    var coordinator: Coordinator { get set }
    
    var weather3Days: [ListOfParams] { get set }
    var weatherDay: Welcome { get set }
    
    var lat: CLLocationDegrees { get set }
    var log: CLLocationDegrees { get set }
    
    var isLocated: Bool { get set }
    
    func filterArray()
    func getDataDay(completion: @escaping (Bool) -> Void)
    func getData3Days(completion: @escaping (Bool) -> Void)
}

class WeatherViewModelImp: WeatherViewModel {
    var lat: CLLocationDegrees = 0
    
    var log: CLLocationDegrees = 0
    
    var isLocated: Bool = false {
        didSet {
            
        }
    }
    
    var weatherDay: Welcome = Welcome.defaultData
    var weather3Days: [ListOfParams] = []
    
    var coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    
    func getDataDay(completion: @escaping (Bool) -> Void)  {
        
        APICaller.shared.fetchWeatherData(latitude: lat, longitude: log) { result in
            switch result {
            case .success(let weatherData):
                self.weatherDay = weatherData
                completion(true)
            case .failure( _):
                completion(false)
                AlertManager.shared.showAlert(title: "Error", message: "Something went wrong")
            }
        }
    }
    
    func getData3Days(completion: @escaping (Bool) -> Void)  {
        APICaller.shared.fetchWeatherDaysData(latitude: lat, longitude: log) { result in
            switch result {
            case .success(let weatherData):
                self.weather3Days = weatherData.list ?? []
                completion(true)
            case .failure( _):
                completion(false)
                AlertManager.shared.showAlert(title: "Error", message: "Something went wrong")
            }
        }
    }
    
    func filterArray() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        // Фильтрация массива
        let filteredArray = weather3Days.filter { date in
            
            let normDate = dateFormatter.date(from: date.dtTxt ?? "")
            
            let components = calendar.dateComponents([.day, .hour], from: normDate ?? Date())
            
            // Проверка на завтрашнюю дату и 12:00
            let isTomorrowAt12 = components.day == calendar.component(.day, from: currentDate.addingTimeInterval(24 * 60 * 60)) &&
            components.hour == 12
            
            // Проверка на послезавтрашнюю дату и 12:00
            let isDayAfterTomorrowAt12 = components.day == calendar.component(.day, from: currentDate.addingTimeInterval(2 * 24 * 60 * 60)) &&
            components.hour == 12
            
            let isTwoDaysLaterAt12 = components.day == calendar.component(.day, from: currentDate.addingTimeInterval(3 * 24 * 60 * 60)) &&
            components.hour == 12
            
            return isTomorrowAt12 || isDayAfterTomorrowAt12 || isTwoDaysLaterAt12
        }
        weather3Days = filteredArray
    }
}
