//
//  ParseStation.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 12/20/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import Foundation
import Parse

class ParseStation: PFObject {
    @NSManaged var name: String?
    @NSManaged var cover: PFFileObject?
    @NSManaged var stream: String?
    @NSManaged var genre: String?
    @NSManaged var country: String?
    @NSManaged var city: String?
    
    @NSManaged var iso: String?
    @NSManaged var votes: NSNumber?
    @NSManaged var badStream: Bool
}

extension ParseStation: PFSubclassing {
    static func parseClassName() -> String {
        return "RadioStations"
    }
    
    static func fetchStations(callback: @escaping ([ParseStation]) -> Void) {
        guard
            let query = ParseStation.query() else {
            return
        }
        query.limit = 1000
        if let objects = try? query.findObjects() as? [ParseStation] {
            callback(objects)
        }
    }
}
