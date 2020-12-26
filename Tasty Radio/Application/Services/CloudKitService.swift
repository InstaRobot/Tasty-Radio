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
    
    var stations = [Station]()
    
    private let recordFavourite = "FavouriteStation"
    private let recordRate = "RatedStation"
    
    private let privateCloudDatabase = CKContainer.default().publicCloudDatabase//.privateCloudDatabase
    
    func saveStationToCloud(station: Station, callback: @escaping () -> Void) {
        let record = CKRecord(recordType: recordFavourite)
        record.setValue(station.name, forKey: "name")
        record.setValue(station.city, forKey: "city")
        record.setValue(station.country, forKey: "country")
        record.setValue(station.imageUrl?.absoluteString, forKey: "imageUrl")
        record.setValue(station.stationId, forKey: "stationId")
        record.setValue(station.stationUrl?.absoluteString, forKey: "stationUrl")
        
        privateCloudDatabase.save(record) { (ckRecord, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            callback()
        }
    }
    
    func fetchStationsFromCloud(callback: @escaping ([Station]) -> Void) {
        self.stations = []
        
        let query = CKQuery(recordType: recordFavourite, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["city", "country", "name", "imageUrl", "stationId", "stationUrl"]
        queryOperation.queuePriority = .veryHigh
        
        queryOperation.recordFetchedBlock = { record in
            let station = Station(record: record)
            self.stations.append(station)
        }
        
        queryOperation.queryCompletionBlock = { _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            callback(self.stations)
        }
        
        privateCloudDatabase.add(queryOperation)
    }
    
    func deleteStation(with stationId: String, callback: @escaping () -> Void) {
        let query = CKQuery(
            recordType: recordFavourite,
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
                        print(error.localizedDescription)
                        return
                    }
                }
            }
        }
        
        queryOperation.queryCompletionBlock = { _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            callback()
        }
        
        privateCloudDatabase.add(queryOperation)
    }
}
