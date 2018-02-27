//
//  LocationRealm.swift
//  DigiWeather
//
//  Created by Ehsan Askari on 2/25/18.
//  Copyright © 2018 Ehsan Askari. All rights reserved.
//

import RealmSwift

class LocationRealm: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var latitude = ""
    @objc dynamic var longitude = ""
    
    // primaryKey
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // generateUUID
    func generateUUID() -> String {
        return UUID().uuidString
    }
    
}

