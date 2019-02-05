//
//  TokenResponse.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/6/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import Foundation

struct TokenResponse: Codable {
    var token: String {
        didSet {
            DoitKeychain.wrapper.set(authToken: token)
        }
    }
}
