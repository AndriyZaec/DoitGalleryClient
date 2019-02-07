//
//  UIViewController+Utils.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/7/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import UIKit

extension UIViewController {
    /// MARK: - UIAlertController easy way
    func alert(title: String, meassge: String? = nil, style: UIAlertController.Style = .alert) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: meassge, preferredStyle: style)
        return alertController
    }
}
