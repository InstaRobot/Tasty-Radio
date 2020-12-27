//
//  Genre.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/28/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit

struct Genre {
    var genreId = UUID().uuidString
    var sortOrder: Int
    var name: String
    var imageURL: URL?
    var stations: [RadioStation] = []
}

extension Genre: Equatable {
    static func == (lhs: Genre, rhs: Genre) -> Bool {
        return lhs.genreId == rhs.genreId
    }
}
