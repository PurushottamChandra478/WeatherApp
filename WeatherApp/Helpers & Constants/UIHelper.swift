//
//  UIHelper.swift
//  WeatherApp
//
//  Created by Puru on 29/06/20.
//  Copyright © 2020 Purushottam Chandra. All rights reserved.
//

import UIKit

struct UIHelper {
    static func showActivityIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.addSubview(activityIndicatorCoverView)
            UIApplication.shared.keyWindow?.addSubview(activityIndicatorView)
            activityIndicatorView.startAnimating()
            UIApplication.shared.keyWindow?.isUserInteractionEnabled = false
        }
    }
    
    static func hideActivityIndicator() {
        DispatchQueue.main.async {
            activityIndicatorCoverView.removeFromSuperview()
            activityIndicatorView.removeFromSuperview()
            activityIndicatorView.stopAnimating()
            UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
        }
    }
    
    static func getDateInString(date: Int, format: String = "dd-MMMM-yyyy") -> String {
        let dateNormal = Date(timeIntervalSince1970: TimeInterval(date))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: dateNormal)
    }
}
