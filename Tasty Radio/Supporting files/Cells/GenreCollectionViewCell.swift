//
//  GenreCollectionViewCell.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/28/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit
import Kingfisher

final class GenreCollectionViewCell: UICollectionViewCell {
    @IBOutlet private(set) weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 5
        }
    }
    @IBOutlet private(set) weak var genreImageView: UIImageView!
    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet var indicatorView: UIActivityIndicatorView! {
        didSet {
            indicatorView.color = .white
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: .none)
    }
    
    func configure(with genre: Genre?) {
        if let genre = genre {
            nameLabel.text = genre.name
            if let url = genre.imageURL {
                genreImageView.kf.indicatorType = .activity
                genreImageView.kf.setImage(with: url)
            }
            else {
                genreImageView.image = UIImage(named: "back_genre_cell")
            }
            indicatorView.stopAnimating()
        }
        else {
            nameLabel.text = .none
            genreImageView.image = .none
            indicatorView.startAnimating()
        }
    }
}
