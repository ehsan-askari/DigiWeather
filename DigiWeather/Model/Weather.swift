//
//  Weather.swift
//  DigiWeather
//
//  Created by Ehsan Askari on 2/23/18.
//  Copyright © 2018 Ehsan Askari. All rights reserved.
//

import Foundation

struct Weather {
    
    var locationName: String = ""
    var hourlyArray: [Hourly] = [Hourly]()
    var today: Daily = Daily()
    var dailyArray: [Daily] = [Daily]()
    var summary: String = ""
    var detailKey: [String] = [String]()
    var detailValue: [String] = [String]()
    
}
