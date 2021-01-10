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
    @objc var stationId: String = ""

  	override static func primaryKey() -> String? {
    	 return "stationId"
  	}
}

extension RatedStationRealm {
    static func save(with stationId: String) {
        let model = RatedStationRealm()
        model.stationId = stationId
        model.addWithPrimaryKey()
    }
    
    static func fetchStations(callback: @escaping ([RatedStation]) -> Void) {
        guard
            let objects = RealmObjects.objects(type: self) else {
            return
        }
        let ids: [RatedStation] = objects.map {
            RatedStation(stationId: $0.stationId)
        }
        callback(ids)
    }
}
