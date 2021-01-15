//
//  MainViewController.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/22/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    @IBOutlet private(set) var service: ParseService!
    @IBOutlet private(set) weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private(set) weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.backgroundImage = UIImage()
            searchBar.searchBarStyle = .prominent
            searchBar.setTextFieldColor(color: .clear)
            searchBar.tintColor = .dark2
            searchBar.barTintColor = .dark2
            searchBar.placeholder = "поиск по жанрам"
            guard
                let textField = searchBar.textField else {
                return
            }
            textField.backgroundColor = .clear
            textField.font = .systemFont(ofSize: 14)
            textField.textColor = .dark2
            textField.keyboardAppearance = .dark
            
            if let searchImage = UIImage(named: "search-icon")?.scale(to: CGSize(width: 20, height: 20)) {
                searchBar.setImage(searchImage, for: .search, state: .normal)
            }
            if let clearImage = UIImage(named: "delete-icon")?.scale(to: CGSize(width: 20, height: 20)) {
                searchBar.setImage(clearImage, for: .clear, state: .normal)
            }
        }
    }
    @IBOutlet private(set) weak var collectionView: UICollectionView! {
        didSet {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
            layout.minimumLineSpacing = 24
            collectionView.collectionViewLayout = layout
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        }
    }
    @IBOutlet private(set) weak var plateView: UIView! {
        didSet {
            plateView.layer.cornerRadius = 30
            plateView.layer.shadowColor = UIColor.dark5.cgColor
            plateView.layer.backgroundColor = UIColor.clear.cgColor
            plateView.layer.shadowOffset = .zero
            plateView.layer.shadowRadius = 10
            plateView.layer.shadowOpacity = 0.3
        }
    }
    
    private var gestureRecognizer: UITapGestureRecognizer {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideCursor))
        gesture.cancelsTouchesInView = false
        return gesture
    }
    private var refreshControl: UIRefreshControl = {
        return UIRefreshControl()
    }()
    
    private var genres: [Genre] = []
    private var genresReserved: [Genre] = []
    
    private var totalGenres = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(gestureRecognizer)
        setupPullToRefresh()
        hideTabBar()
        fetchGenres()
        
        service.countGenres { [weak self] count in
            self?.totalGenres = count
            Log.info("genres: \(count)")
        }
        
        service.countStations{ count in
            Log.info("stations: \(count)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showTabBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        hideTabBar()
    }
    
    // MARK: - Actions
    
    @IBAction private func onMain(_ sender: UIButton) {
        sender.animateTap { }
    }
    @IBAction private func onStations(_ sender: UIButton) {
        sender.animateTap {
            if let stationController = StationsViewController.make() {
                self.navigationController?.pushViewController(stationController, animated: true)
                stationController.genre = nil
            }
        }
    }
    @IBAction private func onFavourite(_ sender: UIButton) {
        sender.animateTap {
            if let favouriteController = FavouriteViewController.make() {
                self.navigationController?.pushViewController(favouriteController, animated: true)
            }
        }
    }
    @IBAction private func onSettings(_ sender: UIButton) {
        sender.animateTap {
            if let settingsController = SettingsViewController.make() {
                self.navigationController?.pushViewController(settingsController, animated: true)
            }
        }
    }
    @IBAction private func onInfo(_ sender: UIButton) {
        sender.animateTap {
            if let aboutController = InfoViewController.make() {
                self.navigationController?.pushViewController(aboutController, animated: true)
            }
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.genres = self.genresReserved
        }
        else {
            self.genres = self.genresReserved.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
        self.collectionView.reloadData()
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCollectionViewCell", for: indexPath) as! GenreCollectionViewCell
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        }
        else {
            cell.configure(with: genres[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let stationController = StationsViewController.make() {
            self.navigationController?.pushViewController(stationController, animated: true)
            stationController.genre = genres[indexPath.item]
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hideCursor()
    }
}

extension MainViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            self.fetchGenres()
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: (view.frame.width - 60) / 2 - 12, height: 70)
        return size
    }
}

extension MainViewController {
    private func setupPullToRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление жанров", attributes: [.foregroundColor: UIColor.white])
        refreshControl.backgroundColor = .dark1
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    private func fetchGenres() {
        HUD.show(.loading, text: "Загрузка", backgroundColor: .dark1, activityStule: .large)
        
        service.fetchGenres(skip: genresReserved.count) { [weak self] parseGenres in
            self?.genres = parseGenres.map {
                Genre(genreId: $0.objectId ?? "",
                      sortOrder: 0,
                      name: $0.name ?? "",
                      imageURL: URL(string: $0.cover?.url ?? "")
                )
            }
            self?.genresReserved = self?.genres ?? []
            
            DispatchQueue.main.async {
                HUD.dismiss()
                guard
                    let self = self else {
                    return
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    private func hideTabBar() {
        self.bottomConstraint.constant = -100
        self.view.layoutIfNeeded()
    }
    
    private func showTabBar() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.bottomConstraint.constant = 8
            UIView.animate(withDuration: TimeInterval(0.2)) {
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func hideCursor() {
        view.endEditing(true)
    }
    
    @objc func refresh(sender: AnyObject) {
        fetchGenres()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.view.setNeedsDisplay()
        }
    }
    
    private func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.item >= genres.count
    }
    
    private func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleItems = collectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleItems).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

extension MainViewController {
    static func make() -> MainViewController? {
        if let controller = UIStoryboard(
            name: "Main",
            bundle: .none
        ).instantiateViewController(identifier: "MainViewController") as? MainViewController {
            return controller
        }
        return .none
    }
}
