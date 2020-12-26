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
    func playStation(with station: Station)
}

class StationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var stationImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    weak var delegate: StationCollectionViewCellDelegate?
    
    private var station: Station? {
        didSet {
            guard
                let station = station else {
                return
            }
            if let url = station.imageUrl {
                stationImageView.kf.indicatorType = .activity
                stationImageView.kf.setImage(with: url)
            }
            self.nameLabel.text = station.name
            self.infoLabel.text = station.info
        }
    }
    
    func configure(with station: Station) {
        self.station = station
    }
    
    @IBAction func onPlay(_ sender: UIButton) {
        sender.animateTap {
            guard
                let station = self.station else {
                return
            }
            self.delegate?.playStation(with: station)
        }
    }
    
}
