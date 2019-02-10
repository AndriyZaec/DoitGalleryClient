//
//  AddImageViewController.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/10/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import UIKit

final class AddImageViewController: UIViewController {

    //MARK: - Properties
    
    @IBOutlet private weak var weatherImageView: UIImageView?
    @IBOutlet private weak var descriptionTextField: DoitTextFiled?
    @IBOutlet private weak var hashtagsTextFields: DoitTextFiled?
    
    private var imagePickerHelper: ImagePickerHelper?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Privates
    
    //MARK: - Navigation
    
    //MARK: - Actions
    
    @objc private func chooseImage(_ sender: UIGestureRecognizer) {
        imagePickerHelper?.pickUpPhoto()
    }
    
    //MARK: - UI
    
    private func setupUI() {
        imagePickerHelper = ImagePickerHelper(with: self)
        
        guard let weatherImageView = weatherImageView else { return }
        imagePickerHelper?.setupPickerAction(on: weatherImageView, with: #selector(chooseImage(_:)))
    }
}

// MARK: - UIImagePickerControllerDelegate -
extension AddImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editingImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            weatherImageView?.contentMode = .scaleAspectFill
            weatherImageView?.image = editingImage
            
        } else if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            weatherImageView?.contentMode = .scaleAspectFill
            weatherImageView?.image = pickedImage
        }
        
        self.dismiss(animated:true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}

