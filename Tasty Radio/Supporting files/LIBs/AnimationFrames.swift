//
//  AnimationFrames.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 12/27/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit

class AnimationFrames {
    class func createFrames() -> [UIImage] {
        var animationFrames = [UIImage]()
        for i in 0...3 {
            if let image = UIImage(named: "NowPlayingBars-\(i)")?.imageWithColor(tintColor: .dark10) {
                animationFrames.append(image)
            }
        }
        for i in stride(from: 2, to: 0, by: -1) {
            if let image = UIImage(named: "NowPlayingBars-\(i)")?.imageWithColor(tintColor: .dark10) {
                animationFrames.append(image)
            }
        }
        return animationFrames
    }
}
