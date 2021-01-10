//
//  ParseService.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 12/20/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import Foundation
import Parse

class ParseService: NSObject {
    override init() {
        super.init()
        self.connect()
    }
    
    func countGenres(callback: @escaping (Int) -> Void) {
        ParseGenre.countGenres(callback: callback)
    }
    
    func countStations(callback: @escaping (Int) -> Void) {
        ParseStation.countStations(callback: callback)
    }
    
    func fetchGenres(skip: Int, callback: @escaping ([ParseGenre]) -> Void) {
        ParseGenre.fetchGenres(skip: skip, callback: callback)
    }

    func fetchStations(for genre: String? = nil, callback: @escaping ([ParseStation]) -> Void) {
        ParseStation.fetchStations(for: genre, callback: callback)
    }
    
    func rateStation(with stationId: String, rate: Int, callback: @escaping () -> Void) {
        ParseStation.rateStation(with: stationId, rate: rate, callback: callback)
    }
    
    /// PRIVATE
    
    private func connect() {
        PFConfig.getInBackground { config, error in
            if let version = config?["APP_VERSION"] as? NSNumber {
                print("[ВЕРСИЯ ПРИЛОЖЕНИЯ] = \(version)")
            }
        }
    }
}
