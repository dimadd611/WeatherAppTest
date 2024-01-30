//
//  TableViewCell.swift
//  WeatherApp
//
//  Created by admin on 30.01.2024.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    func configure(item: ListOfParams) {
        guard let date = item.dt, let minTemp = item.main?.tempMin, let maxTemp = item.main?.tempMax else { return }
        dateLabel.text = "\(date.toDate())"
        minLabel.text = "\(minTemp.kelvinToCelsius())°"
        maxLabel.text = "\(maxTemp.kelvinToCelsius())°"
        weatherImage.image = UIImage(systemName: WeatherIcon(iconText: item.weather?[0].main ?? "").rawValue)?.withRenderingMode(.alwaysOriginal)
    }
    
}
