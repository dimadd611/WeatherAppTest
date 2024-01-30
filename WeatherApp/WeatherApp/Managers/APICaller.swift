//
//  APICaller.swift
//  WeatherApp
//
//  Created by Slava Golomoz on 30.01.2024.
//

import Foundation
import UIKit
import Alamofire

class APICaller {
    static let shared = APICaller()
    
    let apiKey = "d7ea18a9e47cf9b0d986ffcf99d17711"
    
    enum APIError: Error {
        case reachlimit
        case apikeywrong
        case requestFailed
        case invalidData
    }
    
    func downloadWeatherIcon(icon: String, completion: @escaping (UIImage?) -> Void) {
        let iconURL = URL(string: "http://openweathermap.org/img/w/\(icon).png")!
        
        URLSession.shared.dataTask(with: iconURL) { (iconData, _, _) in
            if let data = iconData {
                DispatchQueue.main.async {
                    let weatherIcon = UIImage(data: data)
                    completion(weatherIcon)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (Result<Welcome, Error>) -> Void) {
        let baseURL = "https://api.openweathermap.org/data/2.5/weather"
        let urlString = "\(baseURL)?lat=47.0264&lon=28.8404&appid=\(apiKey)"
        
        AF.request(urlString).responseDecodable(of: Welcome.self) { response in
            switch response.result {
            case .success(let weatherResponse):
                switch weatherResponse.cod {
                case 200:
                    completion(.success(weatherResponse))
                case 401:
                    completion(.failure(APIError.apikeywrong))
                    AlertManager.shared.showAlert(title: "API key", message: "Something wrong with your api key")
                case 404:
                    completion(.failure(APIError.requestFailed))
                    AlertManager.shared.showAlert(title: "API reques", message: "Your request looks like wrong")
                case 429:
                    completion(.failure(APIError.reachlimit))
                    AlertManager.shared.showAlert(title: "API calls", message: "You have reached limit")
                case .none:
                    break
                case .some(_):
                    break
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func fetchWeatherDaysData(latitude: Double, longitude: Double, completion: @escaping (Result<MultipleResponse, Error>) -> Void) {
        let baseURL = "https://api.openweathermap.org/data/2.5/forecast"
        let urlString = "\(baseURL)?lat=47.0264&lon=28.8404&appid=\(apiKey)"

        AF.request(urlString).responseDecodable(of: MultipleResponse.self) { response in
            switch response.result {
            case .success(let weatherResponse):
                switch weatherResponse.cod {
                case "200":
                    completion(.success(weatherResponse))
                case "401":
                    completion(.failure(APIError.apikeywrong))
                    AlertManager.shared.showAlert(title: "API key", message: "Something wrong with your api key")
                case "404":
                    completion(.failure(APIError.requestFailed))
                    AlertManager.shared.showAlert(title: "API reques", message: "Your request looks like wrong")
                case "429":
                    completion(.failure(APIError.reachlimit))
                    AlertManager.shared.showAlert(title: "API calls", message: "You have reached limit")
                case .none:
                    break
                case .some(_):
                    break
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }

}
