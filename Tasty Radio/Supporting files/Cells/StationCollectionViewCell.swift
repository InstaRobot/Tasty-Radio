//
//  StationCollectionViewCell.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/29/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit
import Kingfisher

protocol StationCollectionViewCellDelegate: class {
    func playStation(with station: RadioStation)
}

class StationCollectionViewCell: UICollectionViewCell {
    @IBOutlet private(set) weak var stationImageView: UIImageView!
    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var infoLabel: UILabel!
    
    weak var delegate: StationCollectionViewCellDelegate?
    
    private var station: RadioStation? {
        didSet {
            guard
                let station = station else {
                return
            }
            if let url = station.imageURL {
                stationImageView.kf.indicatorType = .activity
                stationImageView.kf.setImage(with: url)
            }
            self.nameLabel.text = station.name
            self.infoLabel.text = station.info
        }
    }
    
    func configure(with station: RadioStation) {
        self.station = station
    }
    
    @IBAction private func onPlay(_ sender: UIButton) {
        sender.animateTap { [weak self] in
            guard
                let station = self?.station else {
                return
            }
            self?.delegate?.playStation(with: station)
        }
    }
}
