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
    
    func fetchGenres(callback: @escaping ([ParseGenre]) -> Void) {
        ParseGenre.fetchGenres(callback: callback)
    }
    
    func fetchStations(callback: @escaping ([ParseStation]) -> Void) {
        ParseStation.fetchStations(callback: callback)
    }
    
    func fetchStations(for genre: String, callback: @escaping ([ParseStation]) -> Void) {
        ParseGenre.fetchStations(for: genre, callback: callback)
    }
    
    func rateStation(with stationId: String, rate: Int, callback: @escaping () -> Void) {
        ParseStation.rateStation(with: stationId, rate: rate, callback: callback)
    }
    
    /// PRIVATE
    
    private func connect() {
        checkAppVersion()
    }
    
    private func checkAppVersion() {
        PFConfig.getInBackground { config, error in
            if let version = config?["APP_VERSION"] as? NSNumber {
                print("[ВЕРСИЯ ПРИЛОЖЕНИЯ] = \(version)")
            }
        }
    }
}
