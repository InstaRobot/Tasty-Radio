//
//  Genre.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/28/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit
import Kingfisher

struct Genre {
    var genreId = UUID().uuidString
    var sortOrder: Int
    var name: String
    var imageUrl: URL?
    var stations: [Station] = []
}
