//
//  AuthViewController.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/5/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import Foundation
import UIKit

final class AuthViewController: UIViewController {

    //MARK: - Properties
    
    @IBOutlet private weak var avatarImageView: UIImageView?
    @IBOutlet private weak var usernameTextField: UITextField?
    @IBOutlet private weak var emailTextField: UITextField?
    @IBOutlet private weak var passwordTextField: UITextField?
    
    //MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configViewModel()
        configViewsBehaviour()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - Navigation -
    
    //MARKL - Actions -
    
    @objc private func setupAvatar(_ sender: UIGestureRecognizer) {
        pickUpPhoto()
    }
    
    //MARK: - UI -
    
    private func setupUI() {
        usernameTextField?.addUnderlineLayer(width: 2.0)
        emailTextField?.addUnderlineLayer(width: 2.0)
        passwordTextField?.addUnderlineLayer(width: 2.0)
        
        guard let avatarImageView = avatarImageView else { return }
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2.0
    }
    
    //MARK: - Privates -
    
    private func configViewModel() {
        
    }
    
    private func validateFields() {
        guard let email = emailTextField?.text, let pass = passwordTextField?.text else {
            return
        }
        
        // TODO: - Validation
    }
    
    private func configViewsBehaviour() {
        guard let avatarImageView = avatarImageView else { return }
        avatarImageView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(setupAvatar(_:)))
        avatarImageView.addGestureRecognizer(tapRecognizer)
    }
    
    private func pickUpPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { [weak self] (alertAction) in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
            
            imagePicker.sourceType = .camera
            self?.present(imagePicker, animated: true, completion: nil)
        })
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] (alertAction) in
            imagePicker.sourceType = .photoLibrary
            self?.present(imagePicker, animated: true, completion: nil)
        })
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibrary)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate -
extension AuthViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editingImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            avatarImageView?.contentMode = .scaleAspectFill
            avatarImageView?.image = editingImage
            
        } else if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            avatarImageView?.contentMode = .scaleAspectFill
            avatarImageView?.image = pickedImage
        }
        
        self.dismiss(animated:true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}
