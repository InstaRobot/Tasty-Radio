//
//  Station.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/28/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit
import CloudKit

struct Station {
    var stationId = UUID().uuidString
    var sortOrder: Int
    var name: String
    var city: String
    var country: String
    var imageUrl: URL?
    var stationUrl: URL?
    
    var rating: Int
    var info: String
    
    init(
        stationId: String = UUID().uuidString,
        sortOrder: Int = 0,
        name: String,
        city: String,
        country: String,
        imageUrl: URL?,
        stationUrl: URL?,
        rating: Int,
        info: String
    ) {
        self.stationId = stationId
        self.name = name
        self.city = city
        self.country = country
        self.imageUrl = imageUrl
        self.stationUrl = stationUrl
        self.sortOrder = sortOrder
        self.rating = rating
        self.info = info
    }
    
    init(
        record: CKRecord
    ) {
        self.stationId = record.value(forKey: "stationId") as? String ?? ""
        self.name = record.value(forKey: "name") as? String ?? ""
        self.city = record.value(forKey: "city") as? String ?? ""
        self.country = record.value(forKey: "country") as? String ?? ""
        self.imageUrl = URL(string: record.value(forKey: "imageUrl") as? String ?? "")
        self.stationUrl = URL(string: record.value(forKey: "stationUrl") as? String ?? "")
        self.sortOrder = 0
        self.rating = 0
        self.info = ""
    }
}

extension Station: Equatable {
    static func == (lhs: Station, rhs: Station) -> Bool {
        return lhs.stationId == rhs.stationId
    }
}
