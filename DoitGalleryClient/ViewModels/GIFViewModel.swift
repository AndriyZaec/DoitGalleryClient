//
//  GIFViewModel.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/11/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import Foundation
import Moya

final class GIFViewModel: Eventable {
    // MARK: - Events -
    
    var onError: ((String) -> Void)?
    var onDone: (() -> Void)?
    var onLoading: ((Bool) -> Void)?
    
    // MARK: - Properties -
    
    private let provider = MoyaProvider<DoitGalleryService>()
    
    var gifUrl: URL?
    
    // MARK: - Networking -
    
    func getGIF(weather: String?) {
        self.onLoading?(true)
        provider.request(.getGifImage(weather)) { [weak self] result in
            self?.onLoading?(false)
            switch result {
            case .success(let response):
                do {
                    let gifModel = try JSONDecoder().decode(GIFResponseModel.self, from: response.data)
                    guard let gifUrl = URL(string: gifModel.gif) else {
                        self?.onError?("Ooops, something goes wrong")
                        return
                    }
                    self?.gifUrl = gifUrl
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
