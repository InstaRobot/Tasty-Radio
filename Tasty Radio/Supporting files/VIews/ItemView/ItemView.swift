//
//  ItemView.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/22/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit

class ItemView: UIView {
    static let itemName = "ItemView"

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 100
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
    }
    
    convenience init(image: UIImage?, title: String, subtitle: String) {
        self.init()
        backgroundColor = .clear
        self.imageView.image = image
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
    }
    
    private func loadNib() {
        Bundle.main.loadNibNamed(ItemView.itemName, owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
}
