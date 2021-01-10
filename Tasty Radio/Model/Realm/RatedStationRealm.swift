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
