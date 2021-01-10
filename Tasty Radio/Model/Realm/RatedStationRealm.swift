//
//  RatedStationSwift.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 10.01.2021.
//  Copyright © 2021 DEVLAB, LLC. All rights reserved.
//

import Foundation
import RealmSwift

class RatedStationRealm: Object {
    @objc dynamic var stationId: String = ""

  	override static func primaryKey() -> String? {
    	 return "stationId"
  	}
}

extension RatedStationRealm {
    static func save(with stationId: String, callback: @escaping () -> Void) {
        let model = RatedStationRealm()
        model.stationId = stationId
        model.addWithPrimaryKey()
        callback()
    }
    
    static func fetchStations(callback: @escaping ([String]) -> Void) {
        guard
            let objects = RealmObjects.objects(type: self) else {
            return
        }
        let ids: [String] = objects.map { $0.stationId }
        
        callback(ids)
    }
}
