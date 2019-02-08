//
//  DoitGalleryService.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/7/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import Foundation
import Moya

enum DoitGalleryService {
    case getUserImages
}

extension DoitGalleryService: TargetType {
    var baseURL: URL {
        return Constants.baseUrl
    }
    
    var path: String {
        switch self {
        case .getUserImages:
            return "/all"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserImages:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var params: [String: Any]? {
        return nil
    }
    
    var task: Task {
        switch self {
        case .getUserImages:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getUserImages:
            return ["token": DoitKeychain.wrapper.authToken ?? ""]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
