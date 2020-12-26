//
//  CloudKitService.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 12/26/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import Foundation
import CloudKit

protocol CloudKitServiceDelegate: class {
    func updateStations(stations: [Station])
}

class CloudKitService {
    static let shared = CloudKitService()
    weak var delegate: CloudKitServiceDelegate?
    
    var stations = [Station]() {
        didSet {
            self.delegate?.updateStations(stations: stations)
        }
    }
    
    private let recordFavourite = "FavouriteStation"
    private let recordRate = "RatedStation"
    
    private let privateCloudDatabase = CKContainer.default().publicCloudDatabase//.privateCloudDatabase
    
    func saveStationToCloud(station: Station) {
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
            
            self.fetchStationsFromCloud()
        }
    }
    
    func fetchStationsFromCloud() {
        let query = CKQuery(recordType: recordFavourite, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        self.privateCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard
                let records = records else {
                return
            }
            self.stations.removeAll()
            
            records.forEach { record in
                let station = Station(record: record)
                self.stations.append(station)
            }
        }
    }
    
    func deleteStation(with stationId: String) {
        let query = CKQuery(recordType: recordFavourite, predicate: NSPredicate(value: true))
        self.privateCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard
                let records = records else {
                return
            }
            
            records.forEach { record in
                if let currentStationId = record.value(forKey: "stationId") as? String, currentStationId == stationId {
                    self.privateCloudDatabase.delete(withRecordID: record.recordID) { _, error in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        
                        self.fetchStationsFromCloud()
                    }
                }
            }
        }
    }
}
