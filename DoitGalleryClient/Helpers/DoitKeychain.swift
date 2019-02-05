//
//  DoitKeychain.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/6/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

final class DoitKeychain {
    
    // MARK: - Keys -
    private enum DoitKeychainKeys: String {
        case authToken
    }
    
    // MARK: - Singleton -
    static var wrapper = DoitKeychain()
    private init() {}
    
    // MARK: - Public properties -
    var authToken: String? {
        return KeychainWrapper.standard.string(forKey: DoitKeychainKeys.authToken.rawValue)
    }
    
    // MARK: - Public set -
    func set(authToken: String) {
        KeychainWrapper.standard.set(authToken, forKey: DoitKeychainKeys.authToken.rawValue)
    }
    
    // MARK: - Public remove -
    func removeAuthToken() {
        KeychainWrapper.standard.removeObject(forKey: DoitKeychainKeys.authToken.rawValue)
    }
}
