//
//  StoreService.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 10.01.2021.
//  Copyright © 2021 DEVLAB, LLC. All rights reserved.
//

import Foundation

final class StoreService: NSObject {
    func saveRated(with stationId: String, callback: @escaping () -> Void) {
        RatedStationRealm.save(with: stationId, callback: callback)
    }
    
    func fetchRated(callback: @escaping ([String]) -> Void) {
        RatedStationRealm.fetchStations(callback: callback)
    }
    
    func fetchFavouriteStations(callback: @escaping ([RadioStation]) -> Void) {
        FavouriteStationRealm.fetchStations(callback: callback)
    }
    
    func isFavourite(stationId: String) -> Bool {
        return FavouriteStationRealm.isFavourite(stationId: stationId)
    }
    
    func setStation(with station: RadioStation, callback: @escaping () -> Void) {
        FavouriteStationRealm.set(with: station, callback: callback)
    }
}
