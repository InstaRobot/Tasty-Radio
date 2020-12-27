//
//  GradientView.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/29/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit

class GradientView: UIView {
    lazy private var gradientLayer: CAGradientLayer = {
        let firstColor = UIColor.clear.cgColor
        let secondColor = UIColor.dark2.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor, secondColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        return gradientLayer
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        layer.insertSublayer(gradientLayer, at: 1)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}
