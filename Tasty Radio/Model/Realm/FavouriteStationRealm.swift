//
//  FavouriteStationRealm.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 10.01.2021.
//  Copyright © 2021 DEVLAB, LLC. All rights reserved.
//

import Foundation
import RealmSwift

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

    override static func primaryKey() -> String? {
       return "stationId"
    }
}

extension FavouriteStationRealm {
    static func save(with station: RadioStation, callback: @escaping () -> Void) {
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
        model.addWithPrimaryKey()
        callback()
    }
    
    static func fetchStations(callback: @escaping ([RadioStation]) -> Void) {
        guard
            let objects = RealmObjects.objects(type: self) else {
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
}
