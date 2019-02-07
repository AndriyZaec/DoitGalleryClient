//
//  AuthViewController.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/5/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import Foundation
import UIKit

enum AuthViewControllerFlow {
    case signUp
    case signIn
    
    var buttonTitle: String {
        switch self {
        case .signIn:
            return "Sign Up"
        case .signUp:
            return "Sign In"
        }
    }
}

final class AuthViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet private weak var avatarImageView: UIImageView?
    @IBOutlet private weak var usernameTextField: UITextField?
    @IBOutlet private weak var emailTextField: UITextField?
    @IBOutlet private weak var passwordTextField: UITextField?
    @IBOutlet private weak var flowChangeButton: UIButton?
    
    private var flow: AuthViewControllerFlow = .signIn
    private let viewModel = AuthViewModel()
    
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
    
    @IBAction private func switchFlowAction(_ sender: UIButton) {
        flow = flow == .signIn ? .signUp : .signIn
        performFlowUITransition()
    }
    
    @IBAction private func sendAction(_ sender: UIButton) {
        validateAndPerformRequest()
    }
    
    //MARK: - UI -
    
    private func setupUI() {
        usernameTextField?.addUnderlineLayer(width: 2.0)
        emailTextField?.addUnderlineLayer(width: 2.0)
        passwordTextField?.addUnderlineLayer(width: 2.0)
        
        guard let avatarImageView = avatarImageView else { return }
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2.0
        
        flowChangeButton?.setTitle(flow.buttonTitle, for: .normal)
    }
    
    private func performFlowUITransition() {
        flowChangeButton?.setTitle(flow.buttonTitle, for: .normal)
        switch flow {
        case .signIn:
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.avatarImageView?.alpha = 0
                self?.usernameTextField?.alpha = 0
            }
        case .signUp:
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.avatarImageView?.alpha = 1
                self?.usernameTextField?.alpha = 1
            }
        }
    }
    
    //MARK: - Privates -
    
    private func configViewModel() {
        
        viewModel.onLoading = { isLoading in
            if isLoading {
                LoaderController.sharedInstance.showLoader()
            } else {
                LoaderController.sharedInstance.removeLoader()
            }
        }
        
        viewModel.onDone = {
            self.alert(title: DoitKeychain.wrapper.authToken ?? "lol").action().present(self)
        }
        
        viewModel.onError = { [unowned self] errorMsg in
            self.alert(title: errorMsg).action().present(self)
        }
        
    }
    
    private func validateAndPerformRequest() {
        guard let email = emailTextField?.text,
            let pass = passwordTextField?.text,
            !email.isEmpty,
            !pass.isEmpty else {
                alert(title: "Ooops, Email & Password fields are required!").action().present(self)
                return
        }
        
        guard isValidEmail(email: email) else {
            alert(title: "Ooops, Email is not valid!").action().present(self)
            return
        }
        
        if flow == .signIn {
            viewModel.login(params: LoginUserParameters(email,pass))
            return
        }
        
        guard flow == .signUp,
            let avatar = avatarImageView?.image,
            let username = usernameTextField?.text else {
                alert(title: "Ooops, data is not valid!").action().present(self)
                return
        }
        
        viewModel.createUser(params: CreateUserParameters(username, email, pass, avatar))
        
    }
    
    private func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
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
