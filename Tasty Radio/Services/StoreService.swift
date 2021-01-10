//
//  StoreService.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 10.01.2021.
//  Copyright © 2021 DEVLAB, LLC. All rights reserved.
//

import Foundation

class StoreService: NSObject {
    func saveRated(with stationId: String, callback: @escaping () -> Void) {
        RatedStationRealm.save(with: stationId, callback: callback)
    }
    
    func fetchRated(callback: @escaping ([RatedStation]) -> Void) {
        RatedStationRealm.fetchStations(callback: callback)
    }
}
