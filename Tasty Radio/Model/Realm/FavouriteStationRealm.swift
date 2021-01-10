//
//  FavouriteStationRealm.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 10.01.2021.
//  Copyright © 2021 DEVLAB, LLC. All rights reserved.
//

import Foundation
import RealmSwift

class FavouriteStationRealm: Object {
    @objc var stationId: String = ""
    @objc var sortOrder: Int = 0
    @objc var name: String = ""
    @objc var city: String = ""
    @objc var country: String = ""
    @objc var streamURL: String = ""
    @objc var imageURL: String = ""
    @objc var votes: Int = 0
    @objc var iso: String = ""
    @objc var badStream: Bool = false
    
    var info: String {
        return country + ", " + city
    }
    
    override static func primaryKey() -> String? {
       return "stationId"
    }
}
