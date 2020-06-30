//
//  LocationData.swift
//  WeatherApp
//
//  Created by Puru on 30/06/20.
//  Copyright © 2020 Purushottam Chandra. All rights reserved.
//

import Foundation

struct LocationData: Codable {
    let key: String
    let localizedName: String
    let country: AdministrativeArea
    let administrativeArea: AdministrativeArea
    
    enum CodingKeys: String, CodingKey {
        case key = "Key"
        case localizedName = "LocalizedName"
        case country = "Country"
        case administrativeArea = "AdministrativeArea"
    }
}

// MARK: - AdministrativeArea
struct AdministrativeArea: Codable {
    let id: String
    let localizedName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case localizedName = "LocalizedName"
    }
}
