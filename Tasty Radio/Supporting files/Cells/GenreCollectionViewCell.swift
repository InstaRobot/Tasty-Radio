//
//  GenreCollectionViewCell.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/28/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit
import Kingfisher

class GenreCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var genreImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func configure(with genre: Genre) {
        if let url = genre.imageURL {
            genreImageView.kf.indicatorType = .activity
            genreImageView.kf.setImage(with: url)
        }
        else {
            genreImageView.image = UIImage(named: "back_genre_cell")
        }
        nameLabel.text = genre.name
    }
}
