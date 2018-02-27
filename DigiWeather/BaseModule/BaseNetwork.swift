//
//  BaseNetwork.swift
//  DigiWeather
//
//  Created by Ehsan Askari on 2/23/18.
//  Copyright © 2018 Ehsan Askari. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class BaseNetwok{
    
    static let shared = BaseNetwok()
    private init() {}
    
    private let baseURL: String = "http://api.wunderground.com/api/"
    private let apiKey: String = "33bdaeb71c34f03c"
    private let autoCompleteBaseURL: String = "http://autocomplete.wunderground.com/"
    
    // loadData
    fileprivate func loadData(view: UIView?, url: String, completionHandler: @escaping ((_ data: JSON?, _ error: Bool, _ msg: String? ) -> ())){
        
        view?.makeToastActivity(.center)
        
        Alamofire.request(url).responseJSON { response in
            view?.hideToastActivity()
            switch response.result {
            case .success(let value):
                if((response.result.value) != nil) {
                    let json = JSON(value)
                    if (json["response"]["error"].exists()){
                        view?.makeToast(json["response"]["error"].description)
                        completionHandler(nil, true, json["response"]["error"].description)
                    }else{
                        completionHandler(json, false, nil)
                    }
                }else{
                    completionHandler(nil, true, BaseModule.shared.message.recieveDataError)
                }
            case .failure(let error):
                if(error.localizedDescription.contains("offline")){
                    view?.makeToast(BaseModule.shared.message.internetConnectionError)
                }else{
                    view?.makeToast(error.localizedDescription)
                }
                completionHandler(nil, true, error.localizedDescription)
            }
        }
    }
    
    // getWeather
    func getWeather(view: UIView?, latitude: String, longitude: String, completionHandler: @escaping ((_ weather: Weather?, _ error: Bool, _ msg: String? ) -> ())){
        
        loadData(view: view, url: baseURL + apiKey + "/astronomy/conditions/forecast/forecast10day/hourly/q/" + latitude + "," + longitude + ".json") { (json, error, msg) in
            
            if !error{
                if let json = json{
                    var weather = Weather()
                    weather.locationName = json["current_observation"]["observation_location"]["city"].stringValue
                    
                    let forecast36hour = json["hourly_forecast"]
                    for i in 0 ..< forecast36hour.count{
                        if(weather.hourlyArray.count == 24){break}
                        let f = forecast36hour[i]
                        weather.hourlyArray.append(Hourly(hour: String(format: "%02d", f["FCTTIME"]["hour"].intValue), condition: f["condition"].stringValue, iconUrl: f["icon_url"].stringValue, temp: f["temp"]["metric"].stringValue + "°"))
                    }
                    weather.hourlyArray.insert(Hourly(hour: "Now", condition: json["current_observation"]["weather"].stringValue, iconUrl: json["current_observation"]["icon_url"].stringValue, temp: json["current_observation"]["temp_c"].stringValue + "°"), at: 0)
                    
                    let forecast10day = json["forecast"]["simpleforecast"]["forecastday"]
                    weather.today = Daily(weekDay: forecast10day[0]["date"]["weekday"].stringValue, iconUrl: forecast10day[0]["icon_url"].stringValue, highestTemp: forecast10day[0]["high"]["celsius"].stringValue, lowestTemp: forecast10day[0]["low"]["celsius"].stringValue)
                    for i in 1 ..< forecast10day.count{
                        if(weather.hourlyArray.count == 7){break}
                        let f = forecast10day[i]
                        weather.dailyArray.append(Daily(weekDay: f["date"]["weekday"].stringValue, iconUrl: f["icon_url"].stringValue, highestTemp: f["high"]["celsius"].stringValue, lowestTemp: f["low"]["celsius"].stringValue))
                    }
                    
                    weather.summary = "Today: " + json["forecast"]["txt_forecast"]["forecastday"][0]["fcttext_metric"].stringValue
                    
                    weather.detailKey = ["Sunrise", "Sunset", "Humidity", "Wind", "Feels Like", "Precipitation", "Pressure", "Visibility", "UV Index"]
                    
                    weather.detailValue.append(String(format: "%02d", json["sun_phase"]["sunrise"]["hour"].intValue) + ":" + String(format: "%02d", json["sun_phase"]["sunrise"]["minute"].intValue))
                    weather.detailValue.append(String(format: "%02d", json["sun_phase"]["sunset"]["hour"].intValue) + ":" + String(format: "%02d", json["sun_phase"]["sunset"]["minute"].intValue))
                    weather.detailValue.append(json["current_observation"]["relative_humidity"].stringValue)
                    weather.detailValue.append(json["current_observation"]["wind_dir"].stringValue + " " + json["current_observation"]["wind_kph"].stringValue + " km/h")
                    weather.detailValue.append(json["current_observation"]["feelslike_c"].stringValue + "°")
                    weather.detailValue.append(json["current_observation"]["precip_today_metric"].stringValue + " mm")
                    weather.detailValue.append(json["current_observation"]["pressure_mb"].stringValue + " mb")
                    weather.detailValue.append(json["current_observation"]["visibility_km"].stringValue + " km")
                    weather.detailValue.append(json["current_observation"]["UV"].stringValue)
                    
                    completionHandler(weather, false, nil)
                    
                }
            }
            else{
                completionHandler(nil, error, msg)
            }
            
        }
    }
    
    // searchAutoComplete
    func searchAutoComplete(view: UIView?, query: String, completionHandler: @escaping ((_ locations: [Location]?, _ error: Bool, _ msg: String? ) -> ())){
        
        loadData(view: view, url: autoCompleteBaseURL + "aq?query=" + query) { (json, error, msg) in
            
            if !error{
                if let json = json {
                    var locations = [Location]()
                    let results = json["RESULTS"].arrayValue
                    for result in results{
                        locations.append(Location(name: result["name"].stringValue, latitude: result["lat"].stringValue, longitude: result["lon"].stringValue))
                    }
                    completionHandler(locations, false, nil)
                }
            }else{
                completionHandler(nil, error, msg)
            }
        }
    }
    
    // getSimpleWeather
    func getSimpleWeather(view: UIView?, latitude: String, longitude: String, completionHandler: @escaping ((_ simpleWeather: SimpleWeather?, _ error: Bool, _ msg: String? ) -> ())){
        
        loadData(view: view, url: baseURL + apiKey + "/conditions/q/" + latitude + "," + longitude + ".json") { (json, error, msg) in
            
            if !error{
                if let json = json{
                    var simpleWeather = SimpleWeather()
                    simpleWeather.locationName = json["current_observation"]["observation_location"]["city"].stringValue
                    simpleWeather.condition = json["current_observation"]["weather"].stringValue
                    simpleWeather.iconUrl = json["current_observation"]["icon_url"].stringValue
                    simpleWeather.temp = json["current_observation"]["temp_c"].stringValue + "°"
                    
                    completionHandler(simpleWeather, false, nil)
                    
                }
            }
            else{
                completionHandler(nil, error, msg)
            }
            
        }
    }
    
}
