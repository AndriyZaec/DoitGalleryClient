//
//  ImageResponseModel.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/7/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import Foundation

struct ImageResponseModel: Decodable {
    let images: [ImageModel]
}

struct ImageModel: Decodable {
    let id: Int
    let parameters: ParametersModel
    let smallImagePath: String
    let bigImagePath: String
    
    struct ParametersModel: Decodable {
        let longitude: Float
        let latitude: Float
        let weather: String
    }
}
