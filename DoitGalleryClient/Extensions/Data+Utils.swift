//
//  Data+Utils.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/10/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import Foundation
import Moya

extension Data {
    func multipartData(name: String) -> MultipartFormData {
        return MultipartFormData(provider: .data(self), name: name)
    }
    
    func multipartFileData(name: String, filename: String, mime: String) -> MultipartFormData {
        return MultipartFormData(provider: .data(self),
                                 name: name,
                                 fileName: filename,
                                 mimeType: mime)
    }
}
