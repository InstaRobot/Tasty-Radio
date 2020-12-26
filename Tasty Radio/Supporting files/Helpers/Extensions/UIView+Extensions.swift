//
//  UIView+Extensions.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/29/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit

extension UIView {
    func animateTap(callback: @escaping () -> Void) {
        UIView.animate(withDuration: TimeInterval(0.1)) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            UIView.animate(withDuration: TimeInterval(0.1)) {
                self.transform = CGAffineTransform.identity
            } completion: { _ in
                callback()
            }
        }
    }
}
