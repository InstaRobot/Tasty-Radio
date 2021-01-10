//
//  FavouriteStationRealm.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 10.01.2021.
//  Copyright © 2021 DEVLAB, LLC. All rights reserved.
//

import Foundation
import RealmSwift
import IceCream

class FavouriteStationRealm: Object {
    @objc dynamic var stationId: String = ""
    @objc dynamic var sortOrder: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var country: String = ""
    @objc dynamic var streamURL: String = ""
    @objc dynamic var imageURL: String = ""
    @objc dynamic var votes: Int = 0
    @objc dynamic var iso: String = ""
    @objc dynamic var badStream: Bool = false
    
    @objc dynamic var isDeleted = false

    override static func primaryKey() -> String? {
       return "stationId"
    }
}

extension FavouriteStationRealm {
    /// Установка статуса избранной станции
    /// - Parameters:
    ///   - station: модель станции
    ///   - callback: выход по готовности
    static func set(with station: RadioStation, callback: @escaping () -> Void) {
        if isFavourite(stationId: station.stationId) {
            delete(for: station.stationId, callback: callback)
        }
        else {
            save(with: station, callback: callback)
        }
    }
    
    /// Выборка избранных станции из БД
    /// - Parameter callback: массив с моделями станций
    static func fetchStations(callback: @escaping ([RadioStation]) -> Void) {
        let predicate = NSPredicate(format: "isDeleted == %@", argumentArray: [false])
        guard
            let objects = RealmObjects.objects(type: self)?.filter(predicate) else {
            return
        }
        let stations: [RadioStation] = objects.map {
            RadioStation(
                stationId: $0.stationId,
                sortOrder: $0.sortOrder,
                name: $0.name,
                city: $0.city,
                country: $0.country,
                streamURL: URL(string: $0.streamURL),
                imageURL: URL(string: $0.imageURL),
                rating: $0.votes,
                iso: $0.iso,
                badStream: $0.badStream
            )
        }
        callback(stations)
    }
    
    /// Проверка станции в избранном она или нет
    /// - Parameter stationId: ид станции
    /// - Returns: результат операции
    static func isFavourite(stationId: String) -> Bool {
        let predicate = NSPredicate(format: "stationId == %@ AND isDeleted == %@", argumentArray: [stationId, false])
        if let _ = RealmObjects.objects(type: self)?.filter(predicate).first {
            return true
        }
        else {
            return false
        }
    }
    
    // MARK: - PRIVATE HELPERS
    
    static private func save(with station: RadioStation, callback: @escaping () -> Void) {
        let model = FavouriteStationRealm()
        model.stationId = station.stationId
        model.sortOrder = station.sortOrder
        model.name = station.name
        model.city = station.city
        model.country = station.country
        model.streamURL = station.streamURL?.absoluteString ?? ""
        model.imageURL = station.imageURL?.absoluteString ?? ""
        model.iso = station.iso
        model.badStream = station.badStream
        model.isDeleted = false
        model.addWithPrimaryKey()
        callback()
    }
    
    static private func delete(for stationId: String, callback: @escaping () -> Void) {
        let predicate = NSPredicate(format: "stationId == %@", argumentArray: [stationId])
        if let object = RealmObjects.objects(type: self)?.filter(predicate).first {
            object.update {
                object.isDeleted = true
            }
        }
        callback()
    }
}

// MARK: - IceCream

extension FavouriteStationRealm: CKRecordConvertible {}
extension FavouriteStationRealm: CKRecordRecoverable {}
