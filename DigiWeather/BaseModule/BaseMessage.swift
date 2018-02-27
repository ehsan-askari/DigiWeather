//
//  BaseMessage.swift
//  DigiWeather
//
//  Created by Ehsan Askari on 2/24/18.
//  Copyright © 2018 Ehsan Askari. All rights reserved.
//

import Foundation

class BaseMessage  {
    
    static let shared = BaseMessage()
    private init() {}
    
    var recieveDataError: String {
        return "Getting information has encountered a problem!"
    }
    
    var internetConnectionError: String {
        return  "No network connectivity!"
    }
}
