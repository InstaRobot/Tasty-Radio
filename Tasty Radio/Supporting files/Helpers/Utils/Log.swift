//
//  Log.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 10.01.2021.
//  Copyright © 2021 DEVLAB, LLC. All rights reserved.
//

import Foundation

enum Log {
    static let level: Level = .verbose

    enum Level: Int {
        case none    = 0
        case verbose = 3
        case info    = 2
        case error   = 1
        case debug   = 4

        func shouldLog(_ level: Level) -> Bool {
            return level.rawValue <= self.rawValue
        }
    }

    static func assertFailure(
        _ message: @autoclosure () -> Any?,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        #if DEBUG
        assertionFailure(String(describing: message() ?? "nil"), file: file, line: line)
        #endif
    }

    static func assert(
        _ condition: @autoclosure () -> Bool,
        _ message: @autoclosure () -> Any?,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        if !condition() {
            assertFailure(String(describing: message() ?? "nil"), file: file, line: line)
        }
    }

    static func verbose(
        _ message: @autoclosure () -> Any?,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        #if DEBUG
        if level.shouldLog(.verbose) {
            print("📘 [VERBOSE] \(String(describing: message() ?? "nil"))")
        }
        #endif
    }

    static func info(
        _ message: @autoclosure () -> Any?,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        #if DEBUG
        if level.shouldLog(.info) {
            print("📗 [INFO] \(String(describing: message() ?? "nil"))")
        }
        #endif
    }

    static func debug(
        _ message: @autoclosure () -> Any?,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        #if DEBUG
        if level.shouldLog(.error) {
            print("📙 [DEBUG] \(String(describing: message() ?? "nil"))")
        }
        #endif
    }

    static func error(
        _ message: @autoclosure () -> Any?,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        #if DEBUG
        if level.shouldLog(.error) {
            print("📕 [ERROR] \(String(describing: message() ?? "nil"))")
        }
        #endif
    }
}
