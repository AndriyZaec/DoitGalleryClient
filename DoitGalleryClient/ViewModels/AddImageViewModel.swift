//
//  AddImageViewModel.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/10/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import Foundation

final class AddImageViewModel: Eventable {
    var onError: ((String) -> Void)?
    var onDone: (() -> Void)?
    var onLoading: ((Bool) -> Void)?
    
    
}
