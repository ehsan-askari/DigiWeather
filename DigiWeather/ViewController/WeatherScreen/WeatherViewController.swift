//
//  WeatherViewController.swift
//  DigiWeather
//
//  Created by Ehsan Askari on 2/23/18.
//  Copyright © 2018 Ehsan Askari. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var highestTempLabel: UILabel!
    @IBOutlet weak var lowestTempLabel: UILabel!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var dailyTableView: UITableView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    fileprivate let locationManager = CLLocationManager()
    var id: String = "" // id of special location
    fileprivate var weather: Weather = Weather(){
        didSet{
            self.updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationLabel.adjustsFontSizeToFitWidth = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        self.hourlyCollectionView.dataSource = self
        self.dailyTableView.dataSource = self
        
        if(id.isEmpty){
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        }else{
            if let location = BaseModule.shared.realm.objects(LocationRealm.self).filter(NSPredicate(format: "id = '\(id)' ")).first {
                
                getWeather(latitude: location.latitude, longitude: location.longitude)
                
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // updateUI
    fileprivate func updateUI(){
        locationLabel.text = weather.locationName
        conditionLabel.text = weather.hourlyArray[0].condition
        tempLabel.text = weather.hourlyArray[0].temp
        weekDayLabel.text = weather.today.weekDay
        highestTempLabel.text = weather.today.highestTemp
        lowestTempLabel.text = weather.today.lowestTemp
        hourlyCollectionView.reloadData()
        dailyTableView.reloadData()
        summaryLabel.text = weather.summary
        var s = "\n"
        for i in 0 ..< weather.detailKey.count {
            if([2, 3, 5, 7].contains(i)){
                s.append("\n")
            }
            s.append(weather.detailKey[i] + ":  " + weather.detailValue[i])
            s.append("\n")
        }
        detailLabel.text = s
    }
    
    // getWeather
    fileprivate func getWeather(latitude: String, longitude: String){
        BaseModule.shared.network.getWeather(view: self.view, latitude: latitude, longitude: longitude, completionHandler: { (weather, error, msg) in
            if !error{
                if let w = weather{
                    self.weather = w
                }
            }
        })
    }
    
}

// MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            getWeather(latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude))
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error finding location: \(error.localizedDescription)")
    }
}


// MARK: - UICollectionViewDataSource
extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.weather.hourlyArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath) as! HourlyCollectionViewCell
        cell.item = self.weather.hourlyArray[indexPath.row]
        return cell
    }
    
    
}

// MARK: - UITableViewDataSource
extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weather.dailyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyTableViewCell", for: indexPath) as! DailyTableViewCell
        cell.item = self.weather.dailyArray[indexPath.row]
        return cell
    }
    
}
