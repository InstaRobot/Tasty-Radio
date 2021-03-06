//
//  FavouriteCollectionViewCell.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 12/26/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit
import Kingfisher

final class FavouriteCollectionViewCell: UICollectionViewCell {
    @IBOutlet private(set) weak var stationImageView: UIImageView! {
        didSet {
            stationImageView.layer.cornerRadius = 8
            stationImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var stationNameLabel: UILabel!
    
    func configure(with station: RadioStation) {
        self.stationNameLabel.text = station.name
        if let url = station.imageURL {
            self.stationImageView.kf.setImage(with: url)
        }
    }
}
