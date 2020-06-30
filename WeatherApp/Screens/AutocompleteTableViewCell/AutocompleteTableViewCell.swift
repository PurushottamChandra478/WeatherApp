//
//  AutocompleteTableViewCell.swift
//  WeatherApp
//
//  Created by Puru on 30/06/20.
//  Copyright © 2020 Purushottam Chandra. All rights reserved.
//

import UIKit

class AutocompleteTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    
    func setLabel(_ text: String?) {
        titleLabel.text = text
    }
    
}
