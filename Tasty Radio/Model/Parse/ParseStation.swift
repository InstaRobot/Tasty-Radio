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
    
    /// Выборка станций
    /// - Parameters:
    ///   - genre: используется если выборка по имени жанра
    ///   - skip: пропустить количество записей для пагинации
    ///   - callback: массив моделей станций
    static func fetchStations(for genre: String?, skip: Int, callback: @escaping ([ParseStation]) -> Void) {
        DispatchQueue.global().async {
            if let genre = genre, let query = ParseGenre.query() {
                query.whereKey("name", equalTo: genre)
                query.limit = 20
                query.skip  = skip
                if let object = try? query.getFirstObject() {
                    let relation = object.relation(forKey: "stations")
                    if let stations = try? relation.query().findObjects() as? [ParseStation] {
                        DispatchQueue.main.async {
                            callback(stations)
                        }
                    }
                }
            }
            else {
                guard
                    let query = ParseStation.query() else {
                    return
                }
                query.limit = 20
                query.skip  = skip
                if let stations = try? query.findObjects() as? [ParseStation] {
                    DispatchQueue.main.async {
                        callback(stations)
                    }
                }
            }
        }
    }
    
    /// Подсчет количества станций на сервере
    /// - Parameter callback: возвращает значение по готовности
    static func countStations(callback: @escaping (Int) -> Void) {
        guard
            let query = ParseStation.query() else {
            return
        }
        DispatchQueue.global().async {
            query.countObjectsInBackground { count, error in
                if count > 0, error == nil {
                    DispatchQueue.main.async {
                        callback(Int(count))
                    }
                }
            }
        }
    }
    
    static func badStream(for stationId: String, callback: @escaping () -> Void) {
        guard
            let query = ParseStation.query() else {
            return
        }
        DispatchQueue.global().async {
            if let object = try? query.getObjectWithId(stationId) as? ParseStation {
                object.badStream = true
                object.saveInBackground { result, error in
                    if result, error == nil {
                        DispatchQueue.main.async {
                            callback()
                        }
                    }
                }
            }
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
        DispatchQueue.global().async {
            if let object = try? query.getObjectWithId(stationId) as? ParseStation {
                if var vote = object.votes?.intValue {
                    vote = vote + rate
                    if vote < 0 { // не даем уводить рейтинг станции ниже 0
                        vote = 0
                    }
                    
                    object.votes = NSNumber(value: vote)
                    object.saveInBackground { result, error in
                        if result, error == nil {
                            DispatchQueue.main.async {
                                callback()
                            }
                        }
                    }
                }
            }
        }
    }
}
