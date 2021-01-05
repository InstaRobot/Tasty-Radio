//
//  ParseStation.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 12/20/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import Foundation
import Parse

class ParseStation: PFObject {
    @NSManaged var name: String?
    @NSManaged var cover: PFFileObject?
    @NSManaged var stream: String?
    @NSManaged var genre: String?
    @NSManaged var country: String?
    @NSManaged var city: String?
    
    @NSManaged var iso: String?
    @NSManaged var votes: NSNumber?
    @NSManaged var badStream: Bool
}

extension ParseStation: PFSubclassing {
    static func parseClassName() -> String {
        return "RadioStations"
    }
    
    /// Выбор всех станций
    /// - Parameter callback: массив с моделями станций
    static func fetchStations(callback: @escaping ([ParseStation]) -> Void) {
        guard
            let query = ParseStation.query() else {
            return
        }
        query.limit = 1000
        if let objects = try? query.findObjects() as? [ParseStation] {
            callback(objects)
        }
    }
    
    /// Поставить оценку станции на сервере
    /// - Parameters:
    ///   - stationId: ид станции для оценки
    ///   - rate: оценка: 1 или -1
    ///   - callback: выход по готовности
    static func rateStation(with stationId: String, rate: Int, callback: @escaping () -> Void) {
        guard
            let query = ParseStation.query() else {
            return
        }
        if let object = try? query.getObjectWithId(stationId) as? ParseStation {
            if var vote = object.votes?.intValue {
                vote = vote + rate
                if vote < 0 { // не даем уводить рейтинг станции ниже 0
                    vote = 0
                }
                
                object.votes = NSNumber(value: vote)
                object.saveInBackground { result, error in
                    if result, error == nil {
                        callback()
                    }
                }
            }
        }
    }
}
