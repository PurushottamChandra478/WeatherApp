//
//  NavigationController.swift
//  WeatherApp
//
//  Created by Puru on 29/06/20.
//  Copyright © 2020 Purushottam Chandra. All rights reserved.
//

import UIKit

var activityIndicatorView: ActivityIndicator = ActivityIndicator()
var activityIndicatorCoverView: UIView = UIView()

class NavigationController {
    
    var window: UIWindow?
    var navigationController: UINavigationController?
    
    init(window: UIWindow?) {
        self.window = window
        navigationController = UINavigationController()
        start()
        navigationController?.setNavigationBarHidden(true, animated: true)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        setupActivityIndicator()
    }
    
    func start() {
        if let mainVC: ViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            mainVC.loginCompletion = {
                self.pushToHomepage()
            }
            navigationController = UINavigationController(rootViewController: mainVC)
        }
    }
    
    func setupActivityIndicator() {
        activityIndicatorView.stopAnimating()
    }
    
    func pushToHomepage() {
        if let homeVC: HomeViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            homeVC.logoutCompletion = {
                self.navigationController?.popViewController(animated: true)
            }
            navigationController?.pushViewController(homeVC, animated: true)
        }
    }
}
