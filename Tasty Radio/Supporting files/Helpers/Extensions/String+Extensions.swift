//
//  String+Extensions.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 13.01.2021.
//  Copyright © 2021 DEVLAB, LLC. All rights reserved.
//

import Foundation

extension String {
    var transliterated: String {
        return self
            .applyingTransform(.toLatin, reverse: false)?
            .applyingTransform(.stripDiacritics, reverse: false)?
            .lowercased()
            .replacingOccurrences(of: " ", with: "-") ?? self
    }
}
