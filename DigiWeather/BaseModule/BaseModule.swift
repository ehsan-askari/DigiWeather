//
//  BaseModule.swift
//  DigiWeather
//
//  Created by Ehsan Askari on 2/23/18.
//  Copyright © 2018 Ehsan Askari. All rights reserved.
//

import Foundation
import RealmSwift

class BaseModule {
    
    static let shared = BaseModule()
    private init() {}
    
    lazy var network = BaseNetwok.shared
    lazy var message = BaseMessage.shared
    
    let realm = getRealm()
    
    // getLocationIdToDisplay
    func getLocationIdToDisplay() -> String{
        if let displayId = UserDefaults(suiteName: "group.ir.ehsanaskari.digiweather")?.object(forKey: "displayId") as? String{
            return displayId
        }
        return ""
    }
    
    // setLocationIdToDisplay
    func setLocationIdToDisplay(displayId: String){
        let userDefaults = UserDefaults(suiteName: "group.ir.ehsanaskari.digiweather")
        userDefaults?.set(displayId, forKey: "displayId")
        userDefaults?.synchronize()
    }
    
    // getRealm
    class func getRealm() -> Realm {
        let fileURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.ir.ehsanaskari.digiweather")!
            .appendingPathComponent("Library/Caches/default.realm")
        let configuration = Realm.Configuration(fileURL: fileURL, encryptionKey: nil)
        let realm = try! Realm(configuration: configuration)
        return realm
    }
    
}
