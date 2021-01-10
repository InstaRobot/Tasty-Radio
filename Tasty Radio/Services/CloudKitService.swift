//
//  CloudKitService.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 12/26/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitService {
    static let shared = CloudKitService()

    private let recordFavourite = "FavouriteStation"
    private let recordRate = "RatedStation"
    
    private let privateCloudDatabase = CKContainer.default().publicCloudDatabase//.privateCloudDatabase
    
    /// Сохранение станции в избранное
    /// - Parameters:
    ///   - station: модель станции
    ///   - callback: выход по завершении
    func saveStationToCloud(station: RadioStation, callback: @escaping () -> Void) {
        DispatchQueue.global().async {
            let record = CKRecord(recordType: self.recordFavourite)
            record.setValue(station.name, forKey: "name")
            record.setValue(station.city, forKey: "city")
            record.setValue(station.country, forKey: "country")
            record.setValue(station.imageURL?.absoluteString, forKey: "imageUrl")
            record.setValue(station.stationId, forKey: "stationId")
            record.setValue(station.streamURL?.absoluteString, forKey: "stationUrl")
            
            self.privateCloudDatabase.save(record) { (ckRecord, error) in
                if let error = error {
                    Log.error(error.localizedDescription)
                    return
                }
                DispatchQueue.main.async {
                    callback()
                }
            }
        }
    }
    
    /// Сохранение оцененной станции в список ранее оцениваемых станций
    /// - Parameters:
    ///   - stationId: ид станции
    ///   - callback: выход по готовности
    func saveRatedToCloud(with stationId: String, callback: @escaping () -> Void) {
        DispatchQueue.global().async {
            let record = CKRecord(recordType: self.recordRate)
            record.setValue(stationId, forKey: "stationId")
            
            self.privateCloudDatabase.save(record) { (ckRecord, error) in
                if let error = error {
                    Log.error(error.localizedDescription)
                    return
                }
                DispatchQueue.main.async {
                    callback()
                }
            }
        }
    }
    
    /// Загрузка списка избранных станций для пользователя
    /// - Parameter callback: массив моделей избранных станций
    func fetchStationsFromCloud(callback: @escaping ([RadioStation]) -> Void) {
        DispatchQueue.global().async {
            var stations = [RadioStation]()
            
            let query = CKQuery(recordType: self.recordFavourite, predicate: NSPredicate(value: true))
            query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            
            let queryOperation = CKQueryOperation(query: query)
            queryOperation.desiredKeys = ["city", "country", "name", "imageUrl", "stationId", "stationUrl"]
            queryOperation.queuePriority = .high
            
            queryOperation.recordFetchedBlock = { record in
                let station = RadioStation(record: record)
                stations.append(station)
            }
            
            queryOperation.queryCompletionBlock = { _, error in
                if let error = error {
                    Log.error(error.localizedDescription)
                    return
                }
                DispatchQueue.main.async {
                    callback(stations)
                }
            }
            
            self.privateCloudDatabase.add(queryOperation)
        }
    }
    
    /// Загрузка ранее оцениваемых станций для пользователя
    /// - Parameter callback: массив моделей оцениваемых станций
    func fetchRatedFromCloud(callback: @escaping ([RatedStation]) -> Void) {
        DispatchQueue.global().async {
            var rated: [RatedStation] = []
            let query = CKQuery(recordType: self.recordRate, predicate: NSPredicate(value: true))
            let queryOperation = CKQueryOperation(query: query)
            
            queryOperation.recordFetchedBlock = { record in
                let station = RatedStation(record: record)
                rated.append(station)
            }
            
            queryOperation.queryCompletionBlock = { _, error in
                if let error = error {
                    Log.error(error.localizedDescription)
                    return
                }
                DispatchQueue.main.async {
                    callback(rated)
                }
            }
            self.privateCloudDatabase.add(queryOperation)
        }
    }
    
    /// Удаление станции из списка избранного для пользователя
    /// - Parameters:
    ///   - stationId: ид станции
    ///   - callback: выход по готовности
    func deleteStation(with stationId: String, callback: @escaping () -> Void) {
        DispatchQueue.global().async {
            let query = CKQuery(
                recordType: self.recordFavourite,
                predicate: NSPredicate(
                    format: "stationId == %@",
                    argumentArray: [stationId]
                )
            )
            let queryOperation = CKQueryOperation(query: query)
            queryOperation.desiredKeys = ["stationId"]
            queryOperation.queuePriority = .high
            
            queryOperation.recordFetchedBlock = { record in
                if let currentStationId = record.value(forKey: "stationId") as? String, currentStationId == stationId {
                    self.privateCloudDatabase.delete(withRecordID: record.recordID) { _, error in
                        if let error = error {
                            Log.error(error.localizedDescription)
                            return
                        }
                    }
                }
            }
            
            queryOperation.queryCompletionBlock = { _, error in
                if let error = error {
                    Log.error(error.localizedDescription)
                    return
                }
                DispatchQueue.main.async {
                    callback()
                }
            }
            
            self.privateCloudDatabase.add(queryOperation)
        }
    }
}
