//
//  API.swift
//  WeatherApp
//
//  Created by Puru on 29/06/20.
//  Copyright © 2020 Purushottam Chandra. All rights reserved.
//

import Foundation

open class API {
    
    static let apiKey: String = "GZ7JT1QkWASKIpkO10k5hbzAcmZZiDLl"
    
    public enum Endpoints {
        
        case getLocationKey(String)
        case get5DayForecastData(String)
        
        public var path: String {
            switch self {
            case let .getLocationKey(param):
                return "http://dataservice.accuweather.com/locations/v1/cities/autocomplete?apikey=\(apiKey)&q=\(param)"
            case let .get5DayForecastData(param):
                return "http://dataservice.accuweather.com/forecasts/v1/daily/5day/\(param)?apikey=\(apiKey)"
            }
        }
    }
    
    static func request(_ endpoint: API.Endpoints, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        if let requestURL : URL = URL(string: endpoint.path) {
            var request = URLRequest(url: requestURL)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                completionHandler(data, response, error)
            })
            return task
        }
        return URLSessionDataTask()
    }
}
