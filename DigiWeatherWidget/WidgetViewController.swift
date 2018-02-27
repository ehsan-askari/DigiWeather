//
//  WidgetViewController.swift
//  DigiWeatherWidget
//
//  Created by Ehsan Askari on 2/26/18.
//  Copyright © 2018 Ehsan Askari. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation
import RealmSwift
import Kingfisher


class WidgetViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate var simpleWeather: SimpleWeather = SimpleWeather(){
        didSet{
            self.updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        // Do any additional setup after loading the view from its nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(BaseModule.shared.getLocationIdToDisplay().isEmpty){
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        }else{
            if let location = BaseModule.shared.realm.objects(LocationRealm.self).filter(NSPredicate(format: "id = '\(BaseModule.shared.getLocationIdToDisplay())' ")).first {
                
                getSimpleWeather(latitude: location.latitude, longitude: location.longitude)
                
            }
        }
    }
    
    // updateUI
    fileprivate func updateUI(){
        locationLabel.text = simpleWeather.locationName
        conditionLabel.text = simpleWeather.condition
        tempLabel.text = simpleWeather.temp
        conditionImageView.kf.setImage(with: URL(string: simpleWeather.iconUrl))
    }
    
    // getSimpleWeather
    fileprivate func getSimpleWeather(latitude: String, longitude: String){
        BaseModule.shared.network.getSimpleWeather(view: self.view, latitude: latitude, longitude: longitude, completionHandler: { (simpleWeather, error, msg) in
            if !error{
                if let sw = simpleWeather{
                    self.simpleWeather = sw
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}

// MARK: - CLLocationManagerDelegate
extension WidgetViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            getSimpleWeather(latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude))
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error finding location: \(error.localizedDescription)")
    }
}
