//
//  ImagePickerHelper.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/10/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import Foundation
import UIKit

final class ImagePickerHelper {
    
    typealias PickerNeededProtocols = UIImagePickerControllerDelegate & UINavigationControllerDelegate
    
    var sender: UIViewController
    
    init(with sender: UIViewController) {
        self.sender = sender
    }
    
    func setupPickerAction(on view: UIView, with selector: Selector?) {
        view.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: sender, action: selector)
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func pickUpPhoto() {
        guard sender.conforms(to: UIImagePickerControllerDelegate.self), sender.conforms(to: UINavigationControllerDelegate.self) else {
                return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = sender as? PickerNeededProtocols
        imagePicker.allowsEditing = true
        
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { [weak self] (alertAction) in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
            
            imagePicker.sourceType = .camera
            self?.sender.present(imagePicker, animated: true, completion: nil)
        })
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] (alertAction) in
            imagePicker.sourceType = .photoLibrary
            self?.sender.present(imagePicker, animated: true, completion: nil)
        })
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibrary)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        sender.present(alertController, animated: true)
    }
    
}
