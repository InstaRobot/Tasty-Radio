//
//  Configurator.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 12.01.2021.
//  Copyright © 2021 DEVLAB, LLC. All rights reserved.
//

import Foundation
import Swinject

class Configurator {
    private static let container = Container()
    
    static func register<T>(name: String, value: T) {
        container.register(type(of: value), name: name) { _ in value }
    }

    static func resolve<T>(service: T.Type, name: String) -> T? {
        return container.resolve(service, name: name)
    }
}
