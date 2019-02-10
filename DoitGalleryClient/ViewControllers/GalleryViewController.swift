//
//  GalleryViewController.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/7/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import Foundation
import UIKit
import Moya

class GalleryViewController: UIViewController {

    //MARK: - Properties
    
    @IBOutlet private weak var galleryCollectionView: UICollectionView?
    
    private let viewModel = GalleryViewModel()
    private let galleryCellReuseId = String(describing: GalleryItemCollectionViewCell.self)
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configCollectionView()
        configViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            self.galleryCollectionView?.reloadData()
        }
        
        viewModel.onError = { [unowned self] errorMsg in
            self.alert(title: errorMsg).action().present(self)
        }
    }
    
    //MARK: - Navigation
    
    //MARK: - UI
    
    private func setupUI() {
        viewModel.getAllImages()
    }
}

extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let galleryCell = cell as? GalleryItemCollectionViewCell else { return }
        
        galleryCell.configCell(with: viewModel.galleryDataSource[indexPath.row])
    }
}

extension GalleryViewController: UICollectionViewDataSource {
    
    private func configCollectionView() {
        galleryCollectionView?.register(UINib(nibName: galleryCellReuseId, bundle: nil),
                                        forCellWithReuseIdentifier: galleryCellReuseId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.galleryDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: galleryCellReuseId , for: indexPath) as! GalleryItemCollectionViewCell
        return cell
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding

        return CGSize(width: collectionViewSize / 2, height: collectionViewSize / 2)
    }
}
