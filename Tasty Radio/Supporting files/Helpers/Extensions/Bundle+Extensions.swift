//
//  Bundle+Extensions.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 12/20/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import Foundation

extension Bundle {
    var appName: String? {
        return Bundle.main.infoDictionary?["CFBundleName"] as? String
    }

    /// Returns the canonical application name - this is the name default name of the app if CFDisplayName is not specified
    var displayName: String? {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
    }
    var buildNumber: String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String  // Was: CFBuildNumber
    }

    /// Returns the version number - known as the marketing version number
    var versionNumber: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
