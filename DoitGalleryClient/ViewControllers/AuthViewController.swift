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
    private var imagePickerHelper: ImagePickerHelper?
    private let galleryNavigationControllerID = "GalleryNavigationController"
    
    //MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configViewModel()
        configViewsBehaviour()
    }
    
    //MARK: - Navigation -
    
    //MARKL - Actions -
    
    @objc private func chooseAvatar(_ sender: UIGestureRecognizer) {
        imagePickerHelper?.pickUpPhoto()
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
        imagePickerHelper = ImagePickerHelper(with: self)
        
        flowChangeButton?.setTitle(flow.buttonTitle, for: .normal)
        
        guard let avatarImageView = avatarImageView else { return }
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2.0

        imagePickerHelper?.setupPickerAction(on: avatarImageView, with: #selector(chooseAvatar(_:)))
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
        
        viewModel.onDone = { [unowned self] in
            self.setRootViewController()
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
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseAvatar(_:)))
        avatarImageView.addGestureRecognizer(tapRecognizer)
    }
    
    private func setRootViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let navigation = storyBoard.instantiateViewController(withIdentifier: self.galleryNavigationControllerID) as! UINavigationController
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window!.rootViewController = navigation
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
