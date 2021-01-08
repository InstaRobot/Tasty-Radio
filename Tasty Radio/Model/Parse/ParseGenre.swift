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
        return "RadioGenres"
    }
    
    /// Выбор всех жанров с сервера
    /// - Parameter callback: массив с моделями жанров
    static func fetchGenres(callback: @escaping ([ParseGenre]) -> Void) {
        guard
            let query = ParseGenre.query() else {
            return
        }
        if let objects = try? query.findObjects() as? [ParseGenre] {
            callback(objects)
        }
    }
    
    /// Подсчет количества жанров на сервере
    /// - Parameter callback: возвращает значение по готовности
    static func countGenres(callback: @escaping (Int) -> Void) {
        guard
            let query = ParseGenre.query() else {
            return
        }
        query.countObjectsInBackground { count, error in
            if count > 0, error == nil {
                callback(Int(count))
            }
        }
    }
}
