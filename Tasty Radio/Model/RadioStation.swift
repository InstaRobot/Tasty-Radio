//
//  RadioStation.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 12/27/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit

struct RadioStation: Codable {
    var stationId: String
    var sortOrder: Int
    var name: String
    var city: String
    var country: String
    var streamURL: URL?
    var imageURL: URL?
    var votes: Int
    var iso: String
    var badStream: Bool
    
    var info: String {
        return country + ", " + city
    }
    
    init(
        stationId: String,
        sortOrder: Int,
        name: String,
        city: String,
        country: String,
        streamURL: URL?,
        imageURL: URL?,
        rating: Int = 0,
        iso: String,
        badStream: Bool = false
    ) {
        self.stationId  = stationId
        self.sortOrder  = sortOrder
        self.name       = name
        self.city       = city
        self.country    = country
        self.streamURL  = streamURL
        self.imageURL   = imageURL
        self.votes      = rating
        self.iso        = iso
        self.badStream  = badStream
    }
}

extension RadioStation: Equatable {
    static func == (lhs: RadioStation, rhs: RadioStation) -> Bool {
        return lhs.stationId == rhs.stationId
    }
}
