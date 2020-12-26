//
//  ParseGenre.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 12/20/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import Foundation
import Parse

class ParseGenre: PFObject {
    @NSManaged var name: String?
    @NSManaged var cover: PFFileObject?
}

extension ParseGenre: PFSubclassing {
    static func parseClassName() -> String {
        return "Genres"
    }

    static func fetchGenres(callback: @escaping ([ParseGenre]) -> Void) {
        guard
            let query = ParseGenre.query() else {
            return
        }
        if let objects = try? query.findObjects() as? [ParseGenre] {
            callback(objects)
        }
    }
    
    static func fetchStations(for genre: String, callback: @escaping ([ParseStation]) -> Void) {
        guard
            let query = ParseGenre.query() else {
            return
        }
        query.whereKey("name", equalTo: genre)
        if let object = try? query.getFirstObject() {
            let relation = object.relation(forKey: "stations")
            if let stations = try? relation.query().findObjects() as? [ParseStation] {
                callback(stations)
            }
        }
    }
}
