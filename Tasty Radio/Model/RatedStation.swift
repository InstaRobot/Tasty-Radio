//
//  RatedStation.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 05.01.2021.
//  Copyright © 2021 DEVLAB, LLC. All rights reserved.
//

import Foundation

struct RatedStation {
    var stationId: String
    
    init(stationId: String) {
        self.stationId = stationId
    }
    
    init(object: RatedStationRealm) {
        self.stationId = object.stationId
    }
}

extension RatedStation: Equatable {
    static func == (lhs: RatedStation, rhs: RatedStation) -> Bool {
        return lhs.stationId == rhs.stationId
    }
}
