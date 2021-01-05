//
//  RatedStation.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 05.01.2021.
//  Copyright © 2021 DEVLAB, LLC. All rights reserved.
//

import Foundation
import CloudKit

struct RatedStation {
    var stationId: String
    
    init(record: CKRecord) {
        self.stationId  = record.value(forKey: "stationId") as? String ?? ""
    }
}

extension RatedStation: Equatable {
    static func == (lhs: RatedStation, rhs: RatedStation) -> Bool {
        return lhs.stationId == rhs.stationId
    }
}
