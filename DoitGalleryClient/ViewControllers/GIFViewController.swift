//
//  GIFViewController.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/11/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import UIKit
import Nuke

final class GIFViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet private weak var gifImageView: UIImageView?
    
    private let viewModel = GIFViewModel()
    
    var weather: String?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewsBehaviour()
        configViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getGIF(weather: weather)
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
            guard let gifImageView = self.gifImageView, let gifUrl = self.viewModel.gifUrl else {
                self.viewModel.onError?("Ooops, something goes wrong")
                return
            }

            ImagePipeline.Configuration.isAnimatedImageDataEnabled = true
            Nuke.loadImage(with: gifUrl, into: gifImageView)
        }
        
        viewModel.onError = { [unowned self] errorMsg in
            self.viewModel.onLoading?(false)
            self.alert(title: errorMsg).action().present(self)
        }
    }
    
    private func setupViewsBehaviour() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissAction(_:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapRecognizer)
    }
    
    //MARK: - Actions -
    
    @objc private func dismissAction(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
}
