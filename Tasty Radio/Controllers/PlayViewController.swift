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
    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var stationDescLabel: UILabel!
    @IBOutlet private(set) weak var springView: SpringView!
    @IBOutlet private(set) weak var albumImageView: SpringImageView!
    @IBOutlet private(set) weak var favouriteButton: UIButton!
    @IBOutlet private(set) weak var playingButton: UIButton!
    @IBOutlet private(set) weak var previousButton: UIButton!
    @IBOutlet private(set) weak var nextButton: UIButton!
    @IBOutlet private(set) weak var airPlayView: UIView!
    @IBOutlet private(set) weak var songLabel: SpringLabel!
    @IBOutlet private(set) weak var artistLabel: UILabel!
    @IBOutlet private(set) weak var backAnimationView: UIView!
    @IBOutlet private(set) weak var dislikeButton: UIButton!
    @IBOutlet private(set) weak var likeButton: UIButton!
    
    weak var delegate: PlayViewControllerDelegate?
    
    // MARK: - Properties
    
    var currentStation: RadioStation!
    var currentTrack: Track!
    
    var newStation = true
    var nowPlayingImageView: UIImageView!
    let radioPlayer = FRadioPlayer.shared
    
    private var ratedStations: [RatedStation] = [] {
        didSet {
            guard
                ratedStations != oldValue else {
                return
            }
            self.updateRate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNowPlayingAnimation()
        setupAirPlayButton()
        
        if currentStation != nil {
            nameLabel.text = currentStation.name
            stationDescLabel.text = currentStation.info
        }
        
        if currentTrack != nil {
            albumImageView.image = currentTrack.artworkImage
            stationDescLabel.isHidden = currentTrack.artworkLoaded
        }
        
        newStation ? stationDidChange() : playerStateDidChange(radioPlayer.state, animate: false)
        
        self.loadRatedStations()
    }
    
    @IBAction private func onBack(_ sender: UIButton) {
        sender.animateTap { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction private func onFavourite(_ sender: UIButton) {
//        sender.animateTap { [weak self] in
//
//        }
    }
    @IBAction private func onPrevious(_ sender: UIButton) {
        sender.animateTap { [weak self] in
            self?.delegate?.didPressPreviousButton()
        }
    }
    @IBAction private func onPlayPause(_ sender: UIButton) {
        sender.animateTap { [weak self] in
            self?.delegate?.didPressPlayingButton()
        }
    }
    @IBAction private func onNext(_ sender: UIButton) {
        sender.animateTap {  [weak self] in
            self?.delegate?.didPressNextButton()
        }
    }
    @IBAction private func onLike(_ sender: UIButton) {
        sender.animateTap { [weak self] in
            guard
                let stationId = self?.currentStation.stationId else {
                return
            }
            ParseService().rateStation(with: stationId, rate: 1) {
                CloudKitService.shared.saveRatedToCloud(with: stationId) {
                    self?.loadRatedStations()
                }
            }
        }
    }
    @IBAction private func onDislike(_ sender: UIButton) {
        sender.animateTap { [weak self] in
            guard
                let stationId = self?.currentStation.stationId else {
                return
            }
            ParseService().rateStation(with: stationId, rate: -1) {
                CloudKitService.shared.saveRatedToCloud(with: stationId) {
                    self?.loadRatedStations()
                }
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
            let appLink = "https://devlab.studio"
            let tags = " #tastyradio #musicapp #freeradio"
            let activityViewController = UIActivityViewController(activityItems: [radioShoutout + ". : " + appLink + tags,  shareImage], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.center.x, y: self.view.center.y, width: 0, height: 0)
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            
            activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
                if completed {
                    // do something on completion if you want
                }
            }
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}

extension PlayViewController {
    func load(station: RadioStation?, track: Track?, isNewStation: Bool = true) {
        guard
            let station = station else {
            return
        }
        currentStation = station
        currentTrack = track
        newStation = isNewStation
        self.updateRate()
    }
    
    private func updateRate() {
        guard
            currentStation != nil else {
            return
        }
        
        DispatchQueue.main.async { [unowned self] in
            let rated = RatedStation(stationId: currentStation.stationId)
            if self.ratedStations.contains(rated) {
                self.likeButton.isHidden = true
                self.dislikeButton.isHidden = true
            }
            else {
                self.likeButton.isHidden = false
                self.dislikeButton.isHidden = false
            }
        }
    }
    
    private func loadRatedStations() {
        CloudKitService().fetchRatedFromCloud { [weak self] rated in
            self?.ratedStations = rated
        }
    }
    
    func updateTrackMetadata(with track: Track?) {
        guard
            let track = track else {
            return
        }
        currentTrack.artist = track.artist
        currentTrack.title = track.title
        updateLabels()
    }
    
    func updateTrackArtwork(with track: Track?) {
        guard
            let track = track else {
            return
        }
        currentTrack.artworkImage = track.artworkImage
        currentTrack.artworkLoaded = track.artworkLoaded
        albumImageView.image = currentTrack.artworkImage
        
        if track.artworkLoaded {
            springView.animation = "swing"
            springView.duration = 2
            springView.animate()
            stationDescLabel.isHidden = true
        }
        else {
            stationDescLabel.isHidden = false
        }
        view.setNeedsDisplay()
    }
    
    func updateLabels(with statusMessage: String? = nil, animate: Bool = true) {
        guard
            let statusMessage = statusMessage else {
            songLabel.text = currentTrack.title
            artistLabel.text = currentTrack.artist
            shouldAnimateSongLabel(animate)
            return
        }
        guard
            songLabel.text != statusMessage else {
            return
        }
        songLabel.text = statusMessage
        artistLabel.text = currentStation.name
        if animate {
            songLabel.animation = "flash"
            songLabel.repeatCount = 3
            songLabel.animate()
        }
    }
    
    private func isPlayingDidChange(_ isPlaying: Bool) {
        playingButton.isSelected = isPlaying
        startNowPlayingAnimation(isPlaying)
    }
    
    func playbackStateDidChange(_ playbackState: FRadioPlaybackState, animate: Bool) {
        let message: String?
        switch playbackState {
        case .paused:
            message = "Пауза воспроизведения"
        case .playing:
            message = nil
        case .stopped:
            message = "Остановлено"
        }
        updateLabels(with: message, animate: animate)
        isPlayingDidChange(radioPlayer.isPlaying)
    }
    
    func playerStateDidChange(_ state: FRadioPlayerState, animate: Bool) {
        let message: String?
        switch state {
        case .loading:
            message = "Загружаю ..."
        case .urlNotSet:
            message = "Неверная ссылка на поток"
        case .readyToPlay, .loadingFinished:
            playbackStateDidChange(radioPlayer.playbackState, animate: animate)
            return
        case .error:
            message = "Ошибка воспроизведения"
        }
        updateLabels(with: message, animate: animate)
    }
    
    func stationDidChange() {
        radioPlayer.radioURL = currentStation.streamURL
        albumImageView.image = currentTrack.artworkImage
        nameLabel.text = currentStation.name
        stationDescLabel.text = currentStation.info
        stationDescLabel.isHidden = currentTrack.artworkLoaded
    }
    
    // Animations
    
    private func shouldAnimateSongLabel(_ animate: Bool) {
        guard
            animate,
            currentTrack.title != currentStation.name else {
            return
        }
        songLabel.animation = "zoomIn"
        songLabel.duration = 1.5
        songLabel.damping = 1
        songLabel.animate()
    }
    
    private func startNowPlayingAnimation(_ animate: Bool) {
        animate ? nowPlayingImageView.startAnimating() : nowPlayingImageView.stopAnimating()
    }
}

extension PlayViewController {
    private func setupAirPlayButton() {
        let airPlayButton = AVRoutePickerView(frame: airPlayView.bounds)
        airPlayButton.activeTintColor = .dark10
        airPlayButton.tintColor = .gray
        airPlayView.backgroundColor = .clear
        airPlayView.addSubview(airPlayButton)
    }
    
    private func createNowPlayingAnimation() {
        nowPlayingImageView = UIImageView(image: UIImage(named: "NowPlayingBars-3"))
        nowPlayingImageView.autoresizingMask = []
        nowPlayingImageView.contentMode = UIView.ContentMode.center
        
        nowPlayingImageView.animationImages = AnimationFrames.createFrames()
        nowPlayingImageView.animationDuration = 0.7
        
        let barButton = UIButton(type: .custom)
        barButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        barButton.addSubview(nowPlayingImageView)
        nowPlayingImageView.center = barButton.center
        backAnimationView.addSubview(barButton)
        
        nowPlayingImageView.tintColor = .dark10
    }
}
