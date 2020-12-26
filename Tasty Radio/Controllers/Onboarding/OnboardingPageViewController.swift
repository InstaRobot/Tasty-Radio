//
//  OnboardingPageViewController.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/22/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIPageViewController {
    private var items: [UIViewController] = []
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        configureAppearance()
        
        let content: [(image: UIImage?, title: String, subtitle: String)] = [
            (image: scale(for: UIImage(named: "music-1"), to: CGSize(width: 150, height: 150)),
             title: "Популярные станции",
             subtitle: "Пользователи голосуют за понравившиеся станции. Вы можете слушать только лучший контент!"),
            (image: scale(for: UIImage(named: "music-2"), to: CGSize(width: 150, height: 150)),
             title: "Доступно везде",
             subtitle: "Слушайте любимые станции, где бы вы не находились"),
            (image: scale(for: UIImage(named: "music-3"), to: CGSize(width: 100, height: 100)),
             title: "Авторские подборки",
             subtitle: "У нас вы найдете частные станции талантливых музыкантов"),
            (image: scale(for: UIImage(named: "music-4"), to: CGSize(width: 120, height: 120)),
             title: "Любимое дело",
             subtitle: "Мы создавали этот проект не с целью заработать, а просто дать возможность наслаждаться музыкой")
        ]
        
        content.forEach { contentItem in
            let item = self.createItem(image: contentItem.image, title: contentItem.title, subtitle: contentItem.subtitle)
            items.append(item)
        }
        
        if let firstController = items.first {
            setViewControllers([firstController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func createItem(image: UIImage?, title: String, subtitle: String) -> UIViewController {
        let controller = UIViewController()
        controller.view = ItemView(image: image, title: title, subtitle: subtitle)
        return controller
    }
    
    private func configureAppearance() {
        let pageControll = UIPageControl.appearance(whenContainedInInstancesOf: [OnboardingPageViewController.self])
        pageControll.currentPageIndicatorTintColor = UIColor(named: "Dark10")
        pageControll.pageIndicatorTintColor = UIColor(named: "Dark7")

    }
    
    func scale(for image: UIImage?, to newSize: CGSize) -> UIImage? {
        guard
            let image = image else {
            return nil
        }
        let horizontalRatio = newSize.width / image.size.width
        let verticalRatio = newSize.height / image.size.height
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage?.withRenderingMode(image.renderingMode)
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard
            let viewControllerIndex = items.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard
            previousIndex >= 0 else {
            return items.last
        }
        
        guard
            items.count > previousIndex else {
            return nil
        }
        
        return items[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let viewControllerIndex = items.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard
            items.count != nextIndex else {
            return items.first
        }
        
        guard
            items.count > nextIndex else {
            return nil
        }
        
        return items[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return items.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard
            let firstViewController = viewControllers?.first,
            let firstIndex = items.firstIndex(of: firstViewController) else {
            return 0
        }
        
        return firstIndex
    }
    
}
