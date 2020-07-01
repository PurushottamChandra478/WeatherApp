//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Puru on 29/06/20.
//  Copyright © 2020 Purushottam Chandra. All rights reserved.
//

import UIKit
import GoogleSignIn

class HomeViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet var autocompleteTableView: UITableView! {
        didSet {
            autocompleteTableView.register(UINib(nibName: "AutocompleteTableViewCell", bundle: nil), forCellReuseIdentifier: "AutocompleteTableViewCell")
            autocompleteTableView.delegate = self
            autocompleteTableView.dataSource = self
            autocompleteTableView.alpha = 0
            autocompleteTableView.layer.cornerRadius = 10
            autocompleteTableView.separatorStyle = .none
        }
    }

    @IBOutlet var secondaryBackgroundview: UIView! {
        didSet {
            secondaryBackgroundview.clipsToBounds = true
            secondaryBackgroundview.layer.cornerRadius = 20
            secondaryBackgroundview.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        }
    }
    
    @IBOutlet var weatherCollectionView: UICollectionView! {
        didSet {
            weatherCollectionView.delegate = self
            weatherCollectionView.dataSource = self
            weatherCollectionView.register(UINib(nibName: "WeatherCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WeatherCollectionViewCell")
            weatherCollectionView.register(UINib(nibName: "GraphCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GraphCollectionViewCell")

        }
    }
    
    @IBOutlet var weatherPageController: UIPageControl!
    
    @IBOutlet var bodyToTitleTopConstraint: NSLayoutConstraint!
    @IBOutlet var bodyToSearchbarTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var searchButton: UIButton! {
        didSet {
            searchButton.layer.cornerRadius = searchButton.bounds.width / 2
            searchButton.addTarget(self, action: #selector(showSearchBar), for: .touchUpInside)
        }
    }

    @IBOutlet var cityLabel: UILabel!
    
    @IBOutlet var cityDescriptionLabel: UILabel!
    
    @IBOutlet var temperatureLabel: UILabel!

    @IBOutlet var instructionsLabel: UILabel!
    
    var viewModel: HomeViewModel? = HomeViewModel()
    var logoutCompletion: (()->Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.delegate = self
        instructionsLabel.isHidden = false
        showSearchBar()
    }

    @objc func showSearchBar() {
        viewModel?.isSearchBarVisible = true
        weatherPageController.isHidden = true
        searchButton.isHidden = true
        searchButton.isEnabled = false
        bodyToTitleTopConstraint.priority = .defaultLow
        bodyToSearchbarTopConstraint.priority = .defaultHigh
        temperatureLabel.isHidden = true
        cityDescriptionLabel.isHidden = true
        cityLabel.isHidden = true
        weatherCollectionView.reloadData()
        searchBar.becomeFirstResponder()
        
        if searchBar.text?.isEmpty == false {
            viewModel?.callLocationAPI(withSearchText: searchBar.text ?? "")
            UIView.animate(withDuration: TimeInterval(0.25)) {
                self.view.bringSubviewToFront(self.autocompleteTableView)
                self.autocompleteTableView.alpha = 1
            }
        }
    }
    
    func hideSearchBar() {
        viewModel?.isSearchBarVisible = false
        weatherPageController.isHidden = false
        searchButton.isHidden = false
        searchButton.isEnabled = true
        bodyToTitleTopConstraint.priority = .defaultHigh
        bodyToSearchbarTopConstraint.priority = .defaultLow
        temperatureLabel.isHidden = false
        cityDescriptionLabel.isHidden = false
        cityLabel.isHidden = false
        weatherCollectionView.reloadData()
    }
    
    @IBAction func didTapLogout() {
        let alert = UIAlertController(title: "Are you sure?", message: "This will sign you out of the app. Do you want to proceed?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
            self.logoutCompletion?()
            GIDSignIn.sharedInstance()?.signOut()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.count) % 3 == 0 {
            viewModel?.callLocationAPI(withSearchText: searchText)
            UIView.animate(withDuration: TimeInterval(0.25)) {
                self.view.bringSubviewToFront(self.autocompleteTableView)
                self.autocompleteTableView.alpha = 1
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        viewModel?.callLocationAPI(withSearchText: searchBar.text ?? "")
        UIView.animate(withDuration: TimeInterval(0.25)) {
            self.view.bringSubviewToFront(self.autocompleteTableView)
            self.autocompleteTableView.alpha = 1
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
            if regex.firstMatch(in: text, options: [], range: NSMakeRange(0, text.count)) != nil {
                return false
            }
        }
        catch {
            print("ERROR")
        }
        return true
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        weatherPageController.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: weatherCollectionView.frame.width, height: weatherCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel?.isSearchBarVisible == true {
            return 0
        }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            if let cell: WeatherCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as? WeatherCollectionViewCell {
                cell.setData(fiveDayData: viewModel?.getFiveDayData()?.dailyForecasts ?? [])
                return cell
            }
        } else {
            if let cell: GraphCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GraphCollectionViewCell", for: indexPath) as? GraphCollectionViewCell {
                if let chartData = viewModel?.getChartsData() {
                    cell.createChart(dates: chartData.fiveDayDates, max: chartData.maxFiveDays, min: chartData.minFiveDays)
                }
                return cell
            }
        }
        return UICollectionViewCell()
    }
}

extension HomeViewController: ReloatDataProtocol {
    func reloadCollectionViewData(cityText: String, cityDescription: String, temperature: String) {
        DispatchQueue.main.async {
            self.hideSearchBar()
            self.cityLabel.text = cityText
            self.cityDescriptionLabel.text = cityDescription
            self.temperatureLabel.text = temperature
            self.weatherCollectionView.reloadData()
        }
    }
    
    func reloadTableViewData() {
        DispatchQueue.main.async {
            self.instructionsLabel.isHidden = true
            self.autocompleteTableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.resignFirstResponder()
        UIView.animate(withDuration: TimeInterval(0.25), animations: {
            self.autocompleteTableView.alpha = 0
        }, completion: { _ in
            self.view.bringSubviewToFront(self.secondaryBackgroundview)
            self.viewModel?.callFiveDayForecastAPI(forRow: indexPath.row)
        })
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel?.getAutocompleteData().isEmpty == true && searchBar.text?.isEmpty == false {
            return 1
        }
        return viewModel?.getAutocompleteData().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: AutocompleteTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AutocompleteTableViewCell", for: indexPath) as? AutocompleteTableViewCell {
            
            if let autocompleteData = viewModel?.getAutocompleteData(), !autocompleteData.isEmpty {
                var cityText = autocompleteData[indexPath.row].localizedName
                cityText.append(", ")
                cityText.append(autocompleteData[indexPath.row].country.localizedName)
                cell.setLabel(cityText)
            } else {
                cell.setLabel("No results found.")
            }
            return cell
        }
        return UITableViewCell()
    }
}
