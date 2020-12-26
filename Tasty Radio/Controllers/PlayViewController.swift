//
//  PlayViewController.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/29/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation

class PlayViewController: UIViewController {
    var stations: [Station] = []
    var currentIndex = 0
    
    private var player: AVPlayer?
    private var isPlaying = false
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stationImageView: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    private var favouriteStations: [Station] = CloudKitService.shared.stations
    private var cloudKitService = CloudKitService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cloudKitService.delegate = self
        
        let station = self.stations[self.currentIndex]
        self.playStation(with: station)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.player = nil
    }
    
    @IBAction func onBack(_ sender: UIButton) {
        sender.animateTap {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onFavourite(_ sender: UIButton) {
        sender.animateTap {
            let currentStation = self.stations[self.currentIndex]
            if self.favouriteStations.contains(currentStation), let index = self.favouriteStations.firstIndex(of: currentStation) {
                self.favouriteStations.remove(at: index)
                CloudKitService.shared.deleteStation(with: currentStation.stationId)
            }
            else {
                CloudKitService.shared.saveStationToCloud(station: currentStation)
            }
            self.updateFavouriteButtonState()
        }
    }
    
    @IBAction func onPrevious(_ sender: UIButton) {
        sender.animateTap {
            if self.currentIndex > 0 {
                self.playStation(with: self.stations[self.currentIndex - 1])
            }
        }
    }
    
    @IBAction func onPlayPause(_ sender: UIButton) {
        sender.animateTap {
            if self.isPlaying {
                self.player?.pause()
                self.isPlaying = false
            }
            else {
                let station = self.stations[self.currentIndex]
                self.playStation(with: station)
            }
            self.updatePlayButton()
        }
    }
    
    @IBAction func onNext(_ sender: UIButton) {
        sender.animateTap {
            if self.currentIndex < self.stations.count - 1 {
                self.playStation(with: self.stations[self.currentIndex + 1])
            }
        }
    }
    
    func playStation(with station: Station) {
        if let index = stations.firstIndex(of: station) {
            self.currentIndex = index
            self.updateButtonsState()
        }
        
        if let url = station.imageUrl {
            stationImageView.kf.indicatorType = .activity
            stationImageView.kf.setImage(with: url)
        }
        
        if let url = station.stationUrl {
            self.player = AVPlayer(url: url)
            self.player?.play()
            self.isPlaying = true
        }
        nameLabel.text = station.name
        self.updatePlayButton()
    }

    private func updateButtonsState() {
        if currentIndex == 0 {
            self.previousButton.isEnabled = false
            self.previousButton.tintColor = .dark5
        }
        else {
            self.previousButton.isEnabled = true
            self.previousButton.tintColor = .dark10
        }
        
        if currentIndex == stations.count - 1 {
            self.nextButton.isEnabled = false
            self.nextButton.tintColor = .dark5
        }
        else {
            self.nextButton.isEnabled = true
            self.nextButton.tintColor = .dark10
        }
        
        updateFavouriteButtonState()
    }
    
    private func updatePlayButton() {
        DispatchQueue.main.async {
            if self.isPlaying {
                self.playPauseButton.setImage(UIImage(named: "pause-button"), for: .normal)
            }
            else {
                self.playPauseButton.setImage(UIImage(named: "play-button"), for: .normal)
            }
        }
    }
    
    private func updateFavouriteButtonState() {
        let currentStation = self.stations[self.currentIndex]
        DispatchQueue.main.async { [unowned self] in
            if self.favouriteStations.contains(currentStation) {
                self.favouriteButton.tintColor = .favourite
            }
            else {
                self.favouriteButton.tintColor = .dark8
            }
        }
    }
}

extension PlayViewController: CloudKitServiceDelegate {
    func updateStations(stations: [Station]) {
        self.favouriteStations = stations
        self.updateFavouriteButtonState()
    }
}
