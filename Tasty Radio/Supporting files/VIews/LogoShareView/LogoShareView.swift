//
//  LogoShareView.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 12/27/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit

class LogoShareView: UIView {
    @IBOutlet private(set) weak var albumArtImageView: UIImageView! {
        didSet {
            albumArtImageView.layer.cornerRadius = 12
        }
    }
    @IBOutlet private(set) weak var radioShoutoutLabel: UILabel!
    @IBOutlet private(set) weak var trackTitleLabel: UILabel!
    @IBOutlet private(set) weak var trackArtistLabel: UILabel!
    @IBOutlet private(set) weak var logoImageView: UIImageView!
    
    class func instanceFromNib() -> LogoShareView {
        return UINib(
            nibName: "LogoShareView",
            bundle: nil
        ).instantiate(withOwner: nil, options: nil)[0] as! LogoShareView
    }
    
    func shareSetup(
        albumArt: UIImage?,
        radioShoutout: String,
        trackTitle: String,
        trackArtist: String
    ) {
        self.albumArtImageView.image = albumArt
        self.radioShoutoutLabel.text = radioShoutout
        self.trackTitleLabel.text = trackTitle
        self.trackArtistLabel.text = trackArtist
        self.logoImageView.image = UIImage(named: "logo")
    }
}
