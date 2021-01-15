//
//  UIImageView+Extensions.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 15.01.2021.
//  Copyright © 2021 DEVLAB, LLC. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImageWithURL(url: URL, callback: @escaping (UIImage) -> ()) {
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: url, completionHandler: { [weak self] url, response, error in
            if error == nil, let url = url {
                if let data = NSData(contentsOf: url) {
                    if let image = UIImage(data: data as Data) {
                        DispatchQueue.main.async(execute: {
                            if let strongSelf = self {
                                strongSelf.image = image
                                callback(image)
                            }
                        })
                    }
                }
            }
        })
        downloadTask.resume()
    }
}