//
//  WeatherDataTableViewCell.swift
//  WeatherApp
//
//  Created by Puru on 29/06/20.
//  Copyright © 2020 Purushottam Chandra. All rights reserved.
//

import UIKit

class WeatherDataTableViewCell: UITableViewCell {

    @IBOutlet var cellBackgroundView: UIView! {
        didSet {
            cellBackgroundView.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var highLabel: UILabel!
    @IBOutlet var lowLabel: UILabel!

    func set(date: String, highTemp: Int, lowTemp: Int) {
        dateLabel.text = date
        highLabel.text = String(highTemp) + "\u{00B0}"
        lowLabel.text = String(lowTemp) + "\u{00B0}"
    }
    
}
