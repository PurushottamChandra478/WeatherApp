//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Puru on 29/06/20.
//  Copyright © 2020 Purushottam Chandra. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.register(UINib(nibName: "WeatherDataTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherDataTableViewCell")
        }
    }
    
    private var forecastData: [DailyForecast] = []
    
    func setData(fiveDayData: [DailyForecast]) {
        forecastData = fiveDayData
        tableView.reloadData()
    }
    
}

extension WeatherCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: WeatherDataTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherDataTableViewCell", for: indexPath) as? WeatherDataTableViewCell {
            cell.set(date: UIHelper.getDateInString(date: forecastData[indexPath.row].epochDate),
                     highTemp: forecastData[indexPath.row].temperature.maximum.value,
                     lowTemp: forecastData[indexPath.row].temperature.minimum.value)
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
}

extension WeatherCollectionViewCell: UITableViewDelegate {
    
}
