//
//  Device.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 20.01.2021.
//  Copyright © 2021 DEVLAB, LLC. All rights reserved.
//

import Foundation

struct Device: Codable {
    let deviceModel: String
    let deviceName: String
    let systemName: String
    let systemVersion: String

    let regionCode: String
    let languageCode: String
    
    enum CodingKeys: String, CodingKey {
        case deviceModel    = "Device Model"
        case deviceName     = "Device Name"
        case systemName     = "System Name"
        case systemVersion  = "System Version"
        case regionCode     = "Region Code"
        case languageCode   = "Language Code"
    }
}
