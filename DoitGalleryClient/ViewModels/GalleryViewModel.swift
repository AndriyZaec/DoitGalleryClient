//
//  GalleryViewModel.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/7/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import Foundation
import Moya

final class GalleryViewModel: Eventable {
    
    // MARK: - Events -
    
    var onError: ((String) -> Void)?
    var onDone: (() -> Void)?
    var onLoading: ((Bool) -> Void)?
    
    // MARK: - Properties -
    
    var galleryDataSource: [ImageModel] = []
    private let provider = MoyaProvider<DoitGalleryService>()
    
    // MARK: - Networking -
    
    func getAllImages() {
        self.onLoading?(true)
        provider.request(.getUserImages) { [weak self] result in
            self?.onLoading?(false)
            switch result {
            case .success(let response):
                do {
                    let imageResponse = try JSONDecoder().decode(ImageResponseModel.self, from: response.data)
                    self?.galleryDataSource = imageResponse.images
                    self?.onDone?()
                } catch let error {
                    self?.onError?(error.localizedDescription)
                }
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
    
}
