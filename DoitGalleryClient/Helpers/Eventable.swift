//
//  Eventable.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/5/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

protocol Eventable {
    var onError: ((_ message: String) -> Void)? { get set }
    var onDone: (() -> Void)? { get set }
    var onLoading: ((_ isLoading: Bool) -> Void)? { get set }
}
