//
//  RadioStation.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 12/27/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit
import CloudKit

struct RadioStation: Codable {
    var stationId: String
    var sortOrder: Int
    var name: String
    var city: String
    var country: String
    var streamURL: URL?
    var imageURL: URL?
    var rating: Int
    var info: String
    
    init(
        stationId: String,
        sortOrder: Int,
        name: String,
        city: String,
        country: String,
        streamURL: URL?,
        imageURL: URL?,
        rating: Int = 0,
        info: String = ""
    ) {
        self.stationId  = stationId
        self.sortOrder  = sortOrder
        self.name       = name
        self.city       = city
        self.country    = country
        self.streamURL  = streamURL
        self.imageURL   = imageURL
        self.rating     = rating
        self.info       = info
    }
    
    init(
        record: CKRecord
    ) {
        self.stationId  = record.value(forKey: "stationId") as? String ?? ""
        self.name       = record.value(forKey: "name") as? String ?? ""
        self.city       = record.value(forKey: "city") as? String ?? ""
        self.country    = record.value(forKey: "country") as? String ?? ""
        self.imageURL   = URL(string: record.value(forKey: "imageURL") as? String ?? "")
        self.streamURL  = URL(string: record.value(forKey: "streamURL") as? String ?? "")
        self.sortOrder  = 0
        self.rating     = 0
        self.info       = ""
    }
}

extension RadioStation: Equatable {
    
    static func == (lhs: RadioStation, rhs: RadioStation) -> Bool {
        return (lhs.stationId == rhs.stationId)
    }
}
