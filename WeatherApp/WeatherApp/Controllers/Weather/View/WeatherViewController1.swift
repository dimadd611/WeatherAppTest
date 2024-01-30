//
//  ViewController.swift
//  WeatherApp
//
//  Created by Slava Golomoz on 30.01.2024.
//

import UIKit
import CoreLocation
import Network

class WeatherViewController1: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherConditionImage: UIImageView!
    @IBOutlet weak var todaysTemperatureLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: WeatherViewModel!
    var finish: Bool = false
    let monitor = NWPathMonitor()
    var load: Bool = false {
        didSet {
            viewModel.getDataDay { success in
                if success {
                    self.configureUI()
                }
            }
            viewModel.getData3Days { success in
                if success {
                    self.finish = true
                    self.viewModel.filterArray()
                    self.tableView.reloadData()
                    self.checkLoading()
                }
            }
        }
    }
    private var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        getLocation()
        configureTV()
        checkLoading()
        checkConection()
    }
    
    func checkLoading() {
        cityLabel.isHidden = finish ? false : true
        weatherConditionImage.isHidden = finish ? false : true
        todaysTemperatureLabel.isHidden = finish ? false : true
        tableView.isHidden = finish ? false : true
        if finish {
            activityIndicator.stopAnimating()
        }
    }
    
    func checkConection() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                DispatchQueue.main.async {
                    AlertManager.shared.showAlert(title: "Internet conction", message: "Internet connection is lost")
                }
            }
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    func configureUI (){
        cityLabel.text = viewModel.weatherDay.name
        todaysTemperatureLabel.text = "\(viewModel.weatherDay.main.temp.kelvinToCelsius())°"
        weatherConditionImage.image = UIImage(systemName: WeatherIcon(iconText: viewModel.weatherDay.weather?[0].main ?? "").rawValue)?.withRenderingMode(.alwaysOriginal)
    }
    
    func getLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.startUpdatingLocation()
    }
    
    func configureTV() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: String(describing: TableViewCell.self),
                                 bundle: nil),
                           forCellReuseIdentifier: TableViewCell.identifier)
    }
    
    
}



extension WeatherViewController1: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.weather3Days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier,
                                                       for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        if finish {
            cell.configure(item: viewModel.weather3Days[indexPath.row])
        }
        return cell
    }
    
    
}

extension WeatherViewController1: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension WeatherViewController1: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            viewModel.lat = location.coordinate.latitude
            viewModel.log = location.coordinate.longitude
            load.toggle()
            locationManager?.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}
