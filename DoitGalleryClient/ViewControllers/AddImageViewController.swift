//
//  AddImageViewController.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/10/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import UIKit
import Photos

final class AddImageViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet private weak var weatherImageView: UIImageView?
    @IBOutlet private weak var descriptionTextField: DoitTextFiled?
    @IBOutlet private weak var hashtagsTextView: UITextView?
    
    private var imagePickerHelper: ImagePickerHelper?
    
    private let viewModel = AddImageViewModel()
    
    private let locationManager = CLLocationManager()
    
    private var currUserLocationCordinates: CLLocationCoordinate2D?
    
    private var imageLongitude: Float?
    private var imageLatitude: Float?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: - Privates
    
    private func configViewModel() {
        viewModel.onLoading = { isLoading in
            if isLoading {
                LoaderController.sharedInstance.showLoader()
            } else {
                LoaderController.sharedInstance.removeLoader()
            }
        }
        
        viewModel.onDone = { [unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
        
        viewModel.onError = { [unowned self] errorMsg in
            self.alert(title: errorMsg).action().present(self)
        }
    }
    
    private func validateAndGenerateImageData() -> PostImageParameters? {
        guard let weatherImage = weatherImageView?.image,
            weatherImage != UIImage(named: "imagePlaceholder") else {
                alert(title: "Ooops, please pick image.").action().present(self)
                return nil
        }
        
        if imageLongitude == nil,
            imageLatitude == nil,
            let currUserCoordinates = currUserLocationCordinates {
            imageLongitude = Float(currUserCoordinates.latitude)
            imageLatitude = Float(currUserCoordinates.longitude)
        } else {
            // Kiev location
            imageLongitude = 30.52
            imageLatitude = 50.45
        }
        
        return PostImageParameters(weatherImage,
                                   descriptionTextField?.text ?? "",
                                   hashtagsTextView?.text ?? "",
                                   imageLatitude!,
                                   imageLongitude!)
    }
    
    //MARK: - Navigation
    
    //MARK: - Actions
    
    @objc private func chooseImageAction(_ sender: UIGestureRecognizer) {
        imagePickerHelper?.pickUpPhoto()
    }
    
    @IBAction private func completeAction(_ sender: UIBarButtonItem) {
        guard let params = validateAndGenerateImageData() else { return }
        
        viewModel.postImage(postImageParams: params)
    }
    
    //MARK: - UI
    
    private func setupUI() {
        imagePickerHelper = ImagePickerHelper(with: self)
        
        hashtagsTextView?.addUnderlineLayer(height: 2.0)
        hashtagsTextView?.text = "#hashtag"
        hashtagsTextView?.textColor = UIColor.gray
        
        guard let weatherImageView = weatherImageView else { return }
        imagePickerHelper?.setupPickerAction(on: weatherImageView, with: #selector(chooseImageAction(_:)))
    }
    
    private func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
}

// MARK: - UIImagePickerControllerDelegate -
extension AddImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let assetUrl = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset,
            let lat = assetUrl.location?.coordinate.latitude,
            let long = assetUrl.location?.coordinate.longitude {
            imageLatitude = Float(lat)
            imageLongitude = Float(long)
        }
        
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

// MARK: - UITextViewDelegate -
extension AddImageViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textView.resolveHashTags()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "#hashtag"
            textView.textColor = UIColor.gray
        }
    }
}

extension AddImageViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.currUserLocationCordinates = locValue
    }
}

