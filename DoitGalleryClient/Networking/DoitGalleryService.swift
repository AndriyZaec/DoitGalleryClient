//
//  DoitGalleryService.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/7/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import Foundation
import Moya

typealias PostImageParameters = (image: UIImage, description: String, hashtag: String, latitude: Float, longitude: Float)

enum DoitGalleryService {
    case getUserImages
    case postImage(PostImageParameters)
    case getGifImage(_ weather: String?)
}

extension DoitGalleryService: TargetType {
    var baseURL: URL {
        return Constants.baseUrl
    }
    
    var path: String {
        switch self {
        case .getUserImages:
            return "/all"
        case .postImage:
            return "/image"
        case .getGifImage:
            return "/gif"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserImages, .getGifImage:
            return .get
        case .postImage:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var params: [String: Any]? {
        switch self {
        case .getGifImage(let weather):
            return weather != nil ? ["weather": weather!] : nil
        default:
            return nil
        }
    }
    
    var multipartParams: [MultipartFormData]? {
        switch self {
        case .postImage(let params):
            let imageData = params.image.jpegData(compressionQuality: 0.4) ?? Data()
            let imageMultiData = imageData.multipartFileData(name: "image",
                                                             filename: "\(UUID().uuidString)_image.jpeg",
                mime: "image/jpeg")
            
            let descriptionData = params.description.data(using: .utf8) ?? Data()
            let descriptionMultiData = descriptionData.multipartData(name: "description")
            
            let hashtagData = params.hashtag.data(using: .utf8) ?? Data()
            let hashtagMultiData = hashtagData.multipartData(name: "hashtag")
            
            let latitudeData = String(params.latitude).data(using: .utf8) ?? Data()
            let latitudeMultiData = latitudeData.multipartData(name: "latitude")
            
            let longitude = String(params.longitude).data(using: .utf8) ?? Data()
            let longitudeMultiData = longitude.multipartData(name: "longitude")
            return [imageMultiData, descriptionMultiData, hashtagMultiData, latitudeMultiData, longitudeMultiData]
        default: return nil
        }
    }
    
    var task: Task {
        switch self {
        case .getUserImages:
            return .requestPlain
        case .getGifImage:
            return .requestParameters(parameters: params ?? [:], encoding: URLEncoding.default)
        case .postImage:
            return .uploadMultipart(multipartParams ?? [])
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .postImage:
            return ["Content-type" : "multipart/form-data",
                    "token": DoitKeychain.wrapper.authToken ?? ""]
        default:
            return ["Content-type" : "application/json",
                    "token": DoitKeychain.wrapper.authToken ?? ""]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
