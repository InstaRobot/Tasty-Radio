//
//  Realm+Extensions.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 10.01.2021.
//  Copyright © 2021 DEVLAB, LLC. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

final class RealmObjects {
    static func objects<T: Object>(type: T.Type) -> Results<T>? {
        let realm = try? Realm()
        return realm?.objects(type)
    }
}

extension Object {
    func add() {
        let realm = try? Realm()
        try? realm?.write {
            realm?.add(self)
        }
    }

    func addWithPrimaryKey() {
        let realm = try? Realm()
        try? realm?.write {
            realm?.add(self, update: .all)
        }
    }

    func update(updateBlock: () -> Void) {
        let realm = try? Realm()
        try? realm?.write(updateBlock)
    }

    func delete() {
        let realm = try? Realm()
        try? realm?.write {
            realm?.delete(self)
        }
    }
}

protocol CascadeDeleting {
    func delete<S: Sequence>(_ objects: S, cascading: Bool) where S.Iterator.Element: Object
    func delete<Entity: Object>(_ entity: Entity, cascading: Bool)
}

extension Realm: CascadeDeleting {
    func delete<S: Sequence>(_ objects: S, cascading: Bool) where S.Iterator.Element: Object {
        for obj in objects {
            delete(obj, cascading: cascading)
        }
    }

    func delete<Entity: Object>(_ entity: Entity, cascading: Bool) {
        if cascading {
            cascadeDelete(entity)
        }
        else {
            delete(entity)
        }
    }
}

private extension Realm {
    private func cascadeDelete(_ entity: RLMObjectBase) {
        guard
            let entity = entity as? Object else {
            return
        }
        var toBeDeleted = Set<RLMObjectBase>()
        toBeDeleted.insert(entity)
        while !toBeDeleted.isEmpty {
            guard
                let element = toBeDeleted.removeFirst() as? Object,
                !element.isInvalidated else {
                continue
            }
            resolve(element: element, toBeDeleted: &toBeDeleted)
        }
    }

    private func resolve(element: Object, toBeDeleted: inout Set<RLMObjectBase>) {
        element.objectSchema.properties.forEach {
            guard
                let value = element.value(forKey: $0.name) else {
                return
            }
            if let entity = value as? RLMObjectBase {
                toBeDeleted.insert(entity)
            }
            else if let list = value as? RealmSwift.ListBase {
                for index in 0 ..< list._rlmArray.count {
                    if let realmObject = list._rlmArray.object(at: index) as? RLMObjectBase {
                        toBeDeleted.insert(realmObject)
                    }
                }
            }
        }
        delete(element)
    }
}
