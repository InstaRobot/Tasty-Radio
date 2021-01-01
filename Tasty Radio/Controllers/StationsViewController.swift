//
//  StationsViewController.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/28/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class StationsViewController: UIViewController {
    @IBOutlet private(set) var service: ParseService!
    @IBOutlet private(set) weak var bottonConstraint: NSLayoutConstraint!
    @IBOutlet private(set) weak var spacingConstraint: NSLayoutConstraint!
    @IBOutlet private(set) weak var nowPlayingAnimationImageView: UIImageView!
    @IBOutlet private(set) weak var searchBar: UISearchBar! {
        didSet {
            searchBar.backgroundColor = .clear
            searchBar.delegate = self
            searchBar.backgroundImage = UIImage()
            searchBar.searchBarStyle = .prominent
            searchBar.setTextFieldColor(color: .clear)
            searchBar.tintColor = .dark2
            searchBar.barTintColor = .dark2
            searchBar.placeholder = "поиск по станциям"
            guard
                let textField = searchBar.textField else {
                return
            }
            textField.backgroundColor = .clear
            textField.font = .systemFont(ofSize: 14)
            textField.textColor = .dark9
            textField.keyboardAppearance = .dark
            
            if let searchImage = UIImage(named: "search-icon")?.scale(to: CGSize(width: 20, height: 20)) {
                searchBar.setImage(searchImage, for: .search, state: .normal)
            }
            if let clearImage = UIImage(named: "delete-icon")?.scale(to: CGSize(width: 20, height: 20)) {
                searchBar.setImage(clearImage, for: .clear, state: .normal)
            }
        }
    }
    @IBOutlet private(set) weak var leftSegmentIndicatorView: UIView! {
        didSet {
            leftSegmentIndicatorView.layer.cornerRadius = 2
        }
    }
    @IBOutlet private(set) weak var rightSegmentIndicatorView: UIView! {
        didSet {
            rightSegmentIndicatorView.layer.cornerRadius = 2
            rightSegmentIndicatorView.backgroundColor = .clear
        }
    }
    @IBOutlet private(set) weak var collectionView: UICollectionView! {
        didSet {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout.minimumLineSpacing = 0
            collectionView.collectionViewLayout = layout
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
            
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    @IBOutlet private(set) weak var playImageView: UIImageView! {
        didSet {
            playImageView.layer.cornerRadius = 18
        }
    }
    @IBOutlet private(set) weak var playTitleLabel: UILabel! {
        didSet {
            playTitleLabel.text = ""
        }
    }
    @IBOutlet private(set) weak var playSubtitleLabel: UILabel! {
        didSet {
            playSubtitleLabel.text = ""
        }
    }
    @IBOutlet private(set) weak var previousButton: UIButton!
    @IBOutlet private(set) weak var nextButton: UIButton!
    
    let radioPlayer = RadioPlayer()
    weak var playViewController: PlayViewController?
    
    var genre: Genre? {
        didSet {
            self.reloadStations(name: genre?.name)
        }
    }
    var isPlaying = false
    
    var reservedStations: [RadioStation] = []
    var stations = [RadioStation]() {
        didSet {
            guard
                stations != oldValue else {
                return
            }
            stationsDidUpdate()
        }
    }
    var previousStation: RadioStation?
    
    private var selectedSegmentIndex = 0
    private var selectedStationIndex = 0
    
    private var gestureRecognizer: UITapGestureRecognizer {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideCursor))
        gesture.cancelsTouchesInView = false
        return gesture
    }
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
            print("audioSession could not be activated")
        }
        
        self.bottonConstraint.constant = -84
        self.spacingConstraint.constant = 34
        self.view.layoutIfNeeded()
        
        setupPullToRefresh()
        setupRemoteCommandCenter()
        setupHandoffUserActivity()
        createNowPlayingAnimation()
        
        view.addGestureRecognizer(gestureRecognizer)
        addObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction private func onBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction private func onAnimation() {
        print(#function)
    }
    @IBAction private func onOrderedSegment(_ sender: UIButton) {
        sender.animateTap {
            self.selectedSegmentIndex = 0
            self.configureSegments()
        }
    }
    @IBAction private func onPopularSegment(_ sender: UIButton) {
        sender.animateTap {
            self.selectedSegmentIndex = 1
            self.configureSegments()
        }
    }
    @IBAction private func onPrevious(_ sender: UIButton) {
        sender.animateTap {
            if self.selectedStationIndex > 0 {
                self.playStation(with: self.stations[self.selectedStationIndex - 1])
            }
        }
    }
    @IBAction private func onStop(_ sender: UIButton) {
        sender.animateTap {
            self.isPlaying = false
        }
    }
    @IBAction private func onNext(_ sender: UIButton) {
        sender.animateTap {
            if self.selectedStationIndex < self.stations.count - 1 {
                self.playStation(with: self.stations[self.selectedStationIndex + 1])
            }
        }
    }
}

extension StationsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.stations = self.reservedStations
        }
        else {
            self.stations = self.reservedStations.filter {
                $0.name.lowercased().contains(searchText.lowercased())
                    || $0.city.lowercased().contains(searchText.lowercased())
                    || $0.country.lowercased().contains(searchText.lowercased())
            }
        }

        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension StationsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StationCollectionViewCell", for: indexPath) as! StationCollectionViewCell
        cell.backgroundColor = .clear
        cell.configure(with: stations[indexPath.item])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showPlayController(from: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hideCursor()
    }
}

extension StationsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 70)
    }
}

extension StationsViewController: StationCollectionViewCellDelegate {
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
    
    func playStation(with station: RadioStation) {
        if let index = stations.firstIndex(of: station) {
            self.selectedStationIndex = index
            self.updateButtonsState()
        }

        if let url = station.imageURL {
            playImageView.kf.indicatorType = .activity
            playImageView.kf.setImage(with: url)
        }
        playTitleLabel.text = station.name
        playSubtitleLabel.text = station.info
    }
    
    /// Отображение индикатора на сегмент контроле
    private func configureSegments() {
        switch selectedSegmentIndex {
        case 0:
            leftSegmentIndicatorView.backgroundColor = .dark10
            rightSegmentIndicatorView.backgroundColor = .clear
        default:
            leftSegmentIndicatorView.backgroundColor = .clear
            rightSegmentIndicatorView.backgroundColor = .dark10
        }
        self.collectionView.reloadData()
    }
    
    /// Показать или скрыть нижний маленький проигрыватель
    private func updatePlayView() {
        if isPlaying {
            self.bottonConstraint.constant = 0
            self.spacingConstraint.constant = 0
        }
        else {
            self.bottonConstraint.constant = -84
            self.spacingConstraint.constant = 34
        }
        UIView.animate(withDuration: TimeInterval(0.2)) {
            self.view.layoutIfNeeded()
        }
    }
    
    /// Настройка кнопок маленького проигрывателя
    private func updateButtonsState() {
        if selectedStationIndex == 0 {
            self.previousButton.isEnabled = false
            self.previousButton.tintColor = .dark5
        }
        else {
            self.previousButton.isEnabled = true
            self.previousButton.tintColor = .dark10
        }
        
        if selectedStationIndex == stations.count - 1 {
            self.nextButton.isEnabled = false
            self.nextButton.tintColor = .dark5
        }
        else {
            self.nextButton.isEnabled = true
            self.nextButton.tintColor = .dark10
        }
    }
    
    func reloadStations(name: String?) {
        if let name = name {
            self.service.fetchStations(for: name) { [unowned self] parseStations in
                self.stations = parseStations.map {
                    RadioStation(
                        stationId: $0.objectId ?? "",
                        sortOrder: 0,
                        name: $0.name ?? "",
                        city: $0.city ?? "",
                        country: $0.country ?? "",
                        streamURL: URL(string: $0.stream ?? ""),
                        imageURL: URL(string: $0.cover?.url ?? ""),
                        rating: $0.votes?.intValue ?? 0,
                        iso: $0.iso ?? "",
                        badStream: $0.badStream
                    )
                }
                self.reservedStations = self.stations
                
                guard
                    self.collectionView != nil else {
                    return
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        else {
            service.fetchStations {  [unowned self] parseStations in
                self.stations = parseStations.map {
                    RadioStation(
                        stationId: $0.objectId ?? "",
                        sortOrder: 0,
                        name: $0.name ?? "",
                        city: $0.city ?? "",
                        country: $0.country ?? "",
                        streamURL: URL(string: $0.stream ?? ""),
                        imageURL: URL(string: $0.cover?.url ?? ""),
                        rating: $0.votes?.intValue ?? 0,
                        iso: $0.iso ?? "",
                        badStream: $0.badStream
                    )
                }
                self.reservedStations = self.stations
                
                guard
                    self.collectionView != nil else {
                    return
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    @objc private func hideCursor() {
        view.endEditing(true)
    }
}

extension StationsViewController: RadioPlayerDelegate {
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

extension StationsViewController {
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

extension StationsViewController {
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

extension StationsViewController: PlayViewControllerDelegate {
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

extension StationsViewController {
    private func stationsDidUpdate() {
        DispatchQueue.main.async { [weak self] in
            guard
                let currentStation = self?.radioPlayer.station else {
                return
            }
            if self?.stations.firstIndex(of: currentStation) == nil {
                self?.resetCurrentStation()
            }

            guard
                self?.collectionView != nil else {
                return
            }
            self?.collectionView.reloadData()
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
        reloadStations(name: genre?.name)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.view.setNeedsDisplay()
        }
    }
}
