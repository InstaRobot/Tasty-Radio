//
//  GenresOperation.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 15.01.2021.
//  Copyright © 2021 DEVLAB, LLC. All rights reserved.
//

import Foundation

final class GenresOperation: Operation {
    var loadingFinishHandler: (([Genre]) -> Void) = { _ in }
    
    private var genres: [Genre]
    
    init(genres: [Genre]) {
        self.genres = genres
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        
    }
}
