//
//  PlayViewController.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/29/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit
import Kingfisher
import MediaPlayer
import AVKit

protocol PlayViewControllerDelegate: class {
    func didPressPlayingButton()
    func didPressStopButton()
    func didPressNextButton()
    func didPressPreviousButton()
}


class PlayViewController: UIViewController {
    weak var delegate: PlayViewControllerDelegate?
    
    // MARK: - Properties
    
    var currentStation: RadioStation!
    var currentTrack: Track!
    
    var newStation = true
    var nowPlayingImageView: UIImageView!
    let radioPlayer = FRadioPlayer.shared
    
    var mpVolumeSlider: UISlider?
    
    
    
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
    
    @IBOutlet weak var airPlayView: UIView!
    
    @IBOutlet weak var songLabel: SpringLabel!
    @IBOutlet weak var artistLabel: UILabel!
//    @IBOutlet weak var nowPlayingImageView: UIImageView!
    
    private var favouriteStations = [Station]()
    private var cloudKitService = CloudKitService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAirPlayButton()
        
        let station = self.stations[self.currentIndex]
        self.playStation(with: station)
        self.reloadStations()
    }
    
    func setupAirPlayButton() {
        let airPlayButton = AVRoutePickerView(frame: airPlayView.bounds)
        airPlayButton.activeTintColor = .dark10
        airPlayButton.tintColor = .gray
        airPlayView.backgroundColor = .clear
        airPlayView.addSubview(airPlayButton)
    }
    
    func stationDidChange() {
        radioPlayer.radioURL = URL(string: currentStation.streamURL)
//        albumImageView.image = currentTrack.artworkImage
//        stationDescLabel.text = currentStation.desc
//        stationDescLabel.isHidden = currentTrack.artworkLoaded
        title = currentStation.name
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
            if self.favouriteStations.contains(currentStation) {
                CloudKitService.shared.deleteStation(with: currentStation.stationId) { [weak self] in
                    self?.reloadStations()
                }
            }
            else {
                CloudKitService.shared.saveStationToCloud(station: currentStation) { [weak self] in
                    self?.reloadStations()
                }
            }
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
    
    @IBAction private func onShare(_ sender: UIButton) {
        sender.animateTap { [unowned self] in
            guard
                self.currentStation != nil,
                self.currentTrack != nil else {
                return
            }
            let radioShoutout = "Я слушаю \(self.currentStation.name) через Tasty Radio"
            let shareImage = ShareImageGenerator(radioShoutout: radioShoutout, track: self.currentTrack).generate()
            
            let activityViewController = UIActivityViewController(activityItems: [radioShoutout, shareImage], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.center.x, y: self.view.center.y, width: 0, height: 0)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            
            activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed:Bool, returnedItems:[Any]?, error: Error?) in
                if completed {
                    // do something on completion if you want
                }
            }
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func playStation(with station: Station) {
        if let index = stations.firstIndex(of: station) {
            self.currentIndex = index
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
        self.updateButtonsState()
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
    
    private func reloadStations() {
        CloudKitService.shared.fetchStationsFromCloud { [weak self] stations in
            self?.favouriteStations = stations
            self?.updateFavouriteButtonState()
        }
    }
}
