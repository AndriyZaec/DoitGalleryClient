//
//  UIAlertController.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/7/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import UIKit

extension UIAlertController {
    /// Decorate UIAlertController with action
    func action(title: String? = "OK", _ style: UIAlertAction.Style = .default, _ handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        self.addAction(UIAlertAction(title: title, style: style, handler: handler))
        return self
    }
    
    /// Present UIAlertController on sender UIViewController
    func present(_ sender: UIViewController, _ animated: Bool = true, _ completion: (() -> Void)? = nil) {
        sender.present(self, animated: true, completion: completion)
    }
}
