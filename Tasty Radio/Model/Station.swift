//
//  Station.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/28/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit

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
}

extension Station: Equatable {
    static func == (lhs: Station, rhs: Station) -> Bool {
        return lhs.stationId == rhs.stationId
    }
}
