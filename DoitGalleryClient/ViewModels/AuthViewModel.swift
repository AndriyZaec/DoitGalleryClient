//
//  AuthViewModel.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/5/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import Foundation
import Moya

final class AuthViewModel: Eventable {
    
    // MARK: - Events -
    
    var onError: ((String) -> Void)?
    var onDone: (() -> Void)?
    var onLoading: ((Bool) -> Void)?
    
    // MARK: - Properties -
    
    private let provider = MoyaProvider<DoitAuthService>()
    
    // MARK: - Networking -
    
    func login(params: LoginUserParameters) {
        self.onLoading?(true)
        provider.request(.login(params)) { [weak self] result in
            self?.onLoading?(false)
            switch result {
            case .success(let response):
                do {
                    let tokenResponse = try JSONDecoder().decode(TokenResponseModel.self, from: response.data)
                    DoitKeychain.wrapper.set(authToken: tokenResponse.token)
                    self?.onDone?()
                } catch let error {
                    self?.onError?(error.localizedDescription)
                }
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
    
    func createUser(params: CreateUserParameters) {
        self.onLoading?(true)
        provider.request(.createUser(params)) { [weak self] result in
            self?.onLoading?(false)
            switch result {
            case .success(let response):
                do {
                    let tokenResponse = try JSONDecoder().decode(TokenResponseModel.self, from: response.data)
                    DoitKeychain.wrapper.set(authToken: tokenResponse.token)
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
