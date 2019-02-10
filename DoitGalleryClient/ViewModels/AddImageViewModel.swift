//
//  AddImageViewModel.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/10/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import Foundation
import Moya

final class AddImageViewModel: Eventable {
    
    // MARK: - Events -
    
    var onError: ((String) -> Void)?
    var onDone: (() -> Void)?
    var onLoading: ((Bool) -> Void)?
    
    // MARK: - Properties -
    
    private let provider = MoyaProvider<DoitGalleryService>()
    
    // MARK: - Networking -
    
    func postImage(postImageParams: PostImageParameters) {
        self.onLoading?(true)
        provider.request(.postImage(postImageParams)) { [weak self] result in
            self?.onLoading?(false)
            switch result {
            case .success(_):
                self?.onDone?()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
}
