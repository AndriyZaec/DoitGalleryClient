//
//  DoitAuthAPI.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/6/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import Foundation
import Moya

typealias CreateUserParameters = (username: String, email: String, password: String, avatar: UIImage)
typealias LoginUserParameters = (email: String, password: String)

enum DoitAuthAPI {
    case createUser(CreateUserParameters)
    case login(LoginUserParameters)
}

extension DoitAuthAPI: TargetType {
    var baseURL: URL {
        return Constants.baseUrl
    }
    
    var path: String {
        switch self {
        case .createUser:
            return "/create"
        case .login:
            return "/login"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var params: [String: Any]? {
        switch self {
        case .login(let params):
            return ["email": params.email, "password": params.password]
        default:
            return nil
        }
    }
    
    var multiPartParams: [MultipartFormData]? {
        switch self {
        case .createUser(let params):
            let userNameData = params.username.data(using: .utf8) ?? Data()
            let userNameMultiData = userNameData.multipartData(name: "username")
            
            let emailData = params.email.data(using: .utf8) ?? Data()
            let emailMultiData = emailData.multipartData(name: "email")
            
            let passwordData = params.password.data(using: .utf8) ?? Data()
            let passwordMultiData = passwordData.multipartData(name: "password")
            
            let imageData = params.avatar.jpegData(compressionQuality: 0.4) ?? Data()
            let imageMultiData = imageData.multipartFileData(name: "avatar",
                                                             filename: "\(params.email)_avatar.jpeg",
                                                             mime: "image/jpeg")
            
            return [userNameMultiData, emailMultiData, passwordMultiData, imageMultiData]
        default:
            return nil
        }
    }
    
    var task: Task {
        switch self {
        case .createUser:
            return .uploadMultipart(multiPartParams ?? [])
        default:
            return .requestParameters(parameters: params ?? [:], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .createUser:
            return ["Content-type" : "multipart/form-data"]
        default:
            return ["Content-type" : "application/json"]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

fileprivate extension Data {
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
