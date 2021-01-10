//
//  FavouriteViewController.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/29/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class FavouriteViewController: UIViewController {
    
    @IBOutlet private(set) var db: StoreService!
    @IBOutlet private(set) weak var collectionView: UICollectionView! {
        didSet {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
            layout.minimumLineSpacing = 24
            collectionView.collectionViewLayout = layout
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    @IBOutlet private(set) weak var nowPlayingAnimationImageView: UIImageView!
    
    let radioPlayer = RadioPlayer()
    weak var playViewController: PlayViewController?
    
    var stations = [RadioStation]() {
        didSet {
            guard
                stations != oldValue else {
                return
            }
            self.reloadStations()
            self.stationsDidUpdate()
        }
    }
    var previousStation: RadioStation?
    private var selectedStationIndex = 0
    private var refreshControl: UIRefreshControl = {
        return UIRefreshControl()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        radioPlayer.delegate = self
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch {
            Log.error("audioSession could not be activated")
        }
        
        setupPullToRefresh()
        setupRemoteCommandCenter()
        setupHandoffUserActivity()
        createNowPlayingAnimation()
        
        addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        db.fetchFavouriteStations { [weak self] stations in
            self?.stations = stations
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction private func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func onAnimation() {
        Log.debug(#function)
    }
}

extension FavouriteViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteCollectionViewCell", for: indexPath) as! FavouriteCollectionViewCell
        cell.congigure(with: stations[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.showPlayController(from: indexPath)
    }
}

extension FavouriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: (view.frame.width - 60) / 2 - 12, height: 160)
        return size
    }
}

extension FavouriteViewController {
    private func reloadStations() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func showPlayController(from indexPath: IndexPath?) {
        let newStation: Bool
        if let indexPath = indexPath {
            radioPlayer.station = stations[indexPath.item]
            newStation = radioPlayer.station != previousStation
            previousStation = radioPlayer.station
        }
        else {
            newStation = false
        }
        
        let playController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PlayViewController") as! PlayViewController
        playController.modalPresentationStyle = .fullScreen
        self.playViewController = playController
        playController.load(station: radioPlayer.station, track: radioPlayer.track, isNewStation: newStation)
        playController.delegate = self
        self.navigationController?.present(playController, animated: true, completion: nil)
    }
}

extension FavouriteViewController: RadioPlayerDelegate {
    func playerStateDidChange(_ playerState: FRadioPlayerState) {
        playViewController?.playerStateDidChange(playerState, animate: true)
    }
    
    func playbackStateDidChange(_ playbackState: FRadioPlaybackState) {
        playViewController?.playbackStateDidChange(playbackState, animate: true)
        startNowPlayingAnimation(radioPlayer.player.isPlaying)
    }
    
    func trackDidUpdate(_ track: Track?) {
        updateLockScreen(with: track)
        updateHandoffUserActivity(userActivity, station: radioPlayer.station, track: track)
        playViewController?.updateTrackMetadata(with: track)
    }
    
    func trackArtworkDidUpdate(_ track: Track?) {
        updateLockScreen(with: track)
        playViewController?.updateTrackArtwork(with: track)
    }
}

extension FavouriteViewController {
    private func addObservers() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("remoteControlNextTrack"),
            object: nil,
            queue: .main) { [weak self] (_) in
            self?.didPressNextButton()
        }
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("remoteControlPreviousTrack"),
            object: nil,
            queue: .main) { [weak self] (_) in
            self?.didPressPreviousButton()
        }
    }
    
    private func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { event in
            return .success
        }
        commandCenter.pauseCommand.addTarget { event in
            return .success
        }
        commandCenter.nextTrackCommand.addTarget { event in
            return .success
        }
        commandCenter.previousTrackCommand.addTarget { event in
            return .success
        }
    }

    func updateLockScreen(with track: Track?) {
        var nowPlayingInfo = [String : Any]()
        if let image = track?.artworkImage {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { size -> UIImage in
                return image
            })
        }
        if let artist = track?.artist {
            nowPlayingInfo[MPMediaItemPropertyArtist] = artist
        }
        if let title = track?.title {
            nowPlayingInfo[MPMediaItemPropertyTitle] = title
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}

extension FavouriteViewController {
    private func setupHandoffUserActivity() {
        userActivity = NSUserActivity(activityType: NSUserActivityTypeBrowsingWeb)
        userActivity?.becomeCurrent()
    }
    
    func updateHandoffUserActivity(_ activity: NSUserActivity?, station: RadioStation?, track: Track?) {
        guard let activity = activity else { return }
        activity.webpageURL = (track?.title == station?.name) ? nil : getHandoffURL(from: track)
        updateUserActivityState(activity)
    }
    
    override func updateUserActivityState(_ activity: NSUserActivity) {
        super.updateUserActivityState(activity)
    }
    
    private func getHandoffURL(from track: Track?) -> URL? {
        guard let track = track else { return nil }
        var components = URLComponents()
        components.scheme = "https"
        components.host = "google.com"
        components.path = "/search"
        components.queryItems = [URLQueryItem]()
        components.queryItems?.append(URLQueryItem(name: "q", value: "\(track.artist) \(track.title)"))
        return components.url
    }
}

extension FavouriteViewController: PlayViewControllerDelegate {
    func didPressPlayingButton() {
        radioPlayer.player.togglePlaying()
    }
    
    func didPressStopButton() {
        radioPlayer.player.stop()
    }
    
    func didPressNextButton() {
        guard let index = getIndex(of: radioPlayer.station) else { return }
        radioPlayer.station = (index + 1 == stations.count) ? stations[0] : stations[index + 1]
        handleRemoteStationChange()
    }
    
    func didPressPreviousButton() {
        guard let index = getIndex(of: radioPlayer.station) else { return }
        radioPlayer.station = (index == 0) ? stations.last : stations[index - 1]
        handleRemoteStationChange()
    }
    
    func handleRemoteStationChange() {
        if let nowPlayingVC = playViewController {
            nowPlayingVC.load(station: radioPlayer.station, track: radioPlayer.track)
            nowPlayingVC.stationDidChange()
        }
        else if let station = radioPlayer.station {
            radioPlayer.player.radioURL = station.streamURL
        }
    }
}

extension FavouriteViewController {
    private func stationsDidUpdate() {
        DispatchQueue.main.async { [weak self] in
            guard
                let currentStation = self?.radioPlayer.station else {
                return
            }
            if self?.stations.firstIndex(of: currentStation) == nil {
                self?.resetCurrentStation()
            }
        }
    }
    
    private func resetCurrentStation() {
        radioPlayer.resetRadioPlayer()
        nowPlayingAnimationImageView.stopAnimating()
    }
    
    private func createNowPlayingAnimation() {
        nowPlayingAnimationImageView.animationImages = AnimationFrames.createFrames()
        nowPlayingAnimationImageView.animationDuration = 0.7
        nowPlayingAnimationImageView.tintColor = .dark10
    }
    
    private func startNowPlayingAnimation(_ animate: Bool) {
        animate ? nowPlayingAnimationImageView.startAnimating() : nowPlayingAnimationImageView.stopAnimating()
    }
    
    private func getIndex(of station: RadioStation?) -> Int? {
        guard
            let station = station,
            let index = stations.firstIndex(of: station) else {
            return nil
        }
        return index
    }
    
    private func setupPullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление станций", attributes: [.foregroundColor: UIColor.white])
        refreshControl.backgroundColor = .dark1
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender: AnyObject) {
        db.fetchFavouriteStations { [weak self] stations in
            self?.stations = stations
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.view.setNeedsDisplay()
        }
    }
}
