//
//  RatedStationSwift.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 10.01.2021.
//  Copyright © 2021 DEVLAB, LLC. All rights reserved.
//

import Foundation
import RealmSwift
import IceCream

final class RatedStationRealm: Object {
    @objc dynamic var stationId: String = ""
    @objc dynamic var isDeleted = false

  	override static func primaryKey() -> String? {
    	 return "stationId"
  	}
}

extension RatedStationRealm {
    /// Сохранение станции за которую ранее голосовали чтобы избежать накрутки голосов
    /// - Parameters:
    ///   - stationId: ид станции
    ///   - callback: выход по готовности
    static func save(with stationId: String, callback: @escaping () -> Void) {
        let model = RatedStationRealm()
        model.stationId = stationId
        model.addWithPrimaryKey()
        callback()
    }
    
    /// Выборка ИД станций из БД
    /// - Parameter callback: массив ид в формате строки
    static func fetchStations(callback: @escaping ([String]) -> Void) {
        guard
            let objects = RealmObjects.objects(type: self) else {
            return
        }
        let ids: [String] = objects.map { $0.stationId }
        
        callback(ids)
    }
}

// MARK: - IceCream

extension RatedStationRealm: CKRecordConvertible {}
extension RatedStationRealm: CKRecordRecoverable {}
