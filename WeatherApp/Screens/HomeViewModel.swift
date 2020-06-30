//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Puru on 30/06/20.
//  Copyright © 2020 Purushottam Chandra. All rights reserved.
//

import Foundation

protocol ReloatDataProtocol {
    func reloadTableViewData()
    func reloadCollectionViewData(cityText: String, cityDescription: String, temperature: String)
}

struct ChartsDataModel {
    var fiveDayDates: [String] = []
    var maxFiveDays: [Temperature] = []
    var minFiveDays: [Temperature] = []
}

class HomeViewModel {
    
    private var autocompleteData: [LocationData] = []
    private var fiveDayForecastData: FiveDayForecastData? = nil
    private var chartsDataModel: ChartsDataModel? = nil
    
    var isSearchBarVisible: Bool = true
    
    var delegate: ReloatDataProtocol?

    init() {
    }
    
    func callLocationAPI(withSearchText searchText: String) {
        if !searchText.isEmpty {
            UIHelper.showActivityIndicator()
            let task = API.request(.getLocationKey(searchText)) { (data, response, error) in
                UIHelper.hideActivityIndicator()
                if let jsonData = data {
                    do {
                        if let searchResult = try? JSONDecoder().decode([LocationData].self, from: jsonData) {
                            self.autocompleteData = searchResult
                            self.delegate?.reloadTableViewData()
                        }
                    }
                }
                
            }
            task.resume()
        } else {
            self.autocompleteData = []
            self.delegate?.reloadTableViewData()
        }
    }
    
    func callFiveDayForecastAPI(forRow row: Int) {
        if autocompleteData.isEmpty {
            return
        }
        let locationKey: String = autocompleteData[row].key
        UIHelper.showActivityIndicator()
        let task = API.request(.get5DayForecastData(locationKey)) { (data, response, error) in
            UIHelper.hideActivityIndicator()
            if let jsonData = data {
                do {
                    if let searchResult = try? JSONDecoder().decode(FiveDayForecastData.self, from: jsonData) {
                        self.fiveDayForecastData = searchResult
                        self.processForecastData()
                        let temperature = searchResult.dailyForecasts.first?.temperature
                        let degree = temperature?.maximum.unit ?? ""
                        self.delegate?.reloadCollectionViewData(
                            cityText: "\(self.autocompleteData[row].localizedName), \(self.autocompleteData[row].country.localizedName)",
                            cityDescription: searchResult.headline.text,
                            temperature: "\(temperature?.minimum.value ?? 0)\u{00B0}\(degree) to \(temperature?.maximum.value ?? 0)\u{00B0}\(degree)")
                    }
                }
            }
        }
        task.resume()
    }
    
    private func processForecastData() {
        if let forecastData = fiveDayForecastData {
            chartsDataModel = ChartsDataModel()
            for dailyForecast in forecastData.dailyForecasts {
                
                chartsDataModel?.fiveDayDates.append(UIHelper.getDateInString(date: dailyForecast.epochDate, format: "dd MMMM"))
                
                chartsDataModel?.maxFiveDays.append(dailyForecast.temperature.maximum)
                
                chartsDataModel?.minFiveDays.append(dailyForecast.temperature.minimum)
            }

        }
    }
    
    func getAutocompleteData() -> [LocationData] {
        return autocompleteData
    }
    
    func getFiveDayData() -> FiveDayForecastData? {
        return fiveDayForecastData
    }
    
    func getChartsData() -> ChartsDataModel? {
        return chartsDataModel
    }
    
}
