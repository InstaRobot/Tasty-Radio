//
//  ParseGenre.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 12/20/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import Foundation
import Parse

final class ParseGenre: PFObject {
    @NSManaged var name: String?
    @NSManaged var cover: PFFileObject?
}

extension ParseGenre: PFSubclassing {
    static func parseClassName() -> String {
        return "RadioGenres"
    }
    
    /// Выбор всех жанров с сервера
    /// - Parameters:
    ///   - skip: пропустить количество записей для пагинации
    ///   - callback: массив моделей станций по готовности
    static func fetchGenres(skip: Int, callback: @escaping ([ParseGenre]) -> Void) {
        guard
            let query = ParseGenre.query() else {
            return
        }
        DispatchQueue.global().async {
            query.limit = 10
            query.skip = skip
            if let objects = try? query.findObjects() as? [ParseGenre] {
                DispatchQueue.main.async {
                    callback(objects)
                }
            }
        }
    }
    
    /// Подсчет количества жанров на сервере
    /// - Parameter callback: возвращает значение по готовности
    static func countGenres(callback: @escaping (Int) -> Void) {
        guard
            let query = ParseGenre.query() else {
            return
        }
        DispatchQueue.global().async {
            query.countObjectsInBackground { count, error in
                if count > 0, error == nil {
                    DispatchQueue.main.async {
                        callback(Int(count))
                    }
                }
            }
        }
    }
}
