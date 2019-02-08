//
//  GalleryItemCollectionViewCell.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/7/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import UIKit
import Nuke

class GalleryItemCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties -
    
    @IBOutlet private weak var galleryImageView: UIImageView?
    @IBOutlet private weak var weatherLabel: UILabel?
    @IBOutlet private weak var locationNameLabel: UILabel?
    
    func configCell(with model: ImageModel) {
        weatherLabel?.text = model.parameters.weather
        
        LocationHelper(with: Double(model.parameters.latitude), longitude: Double(model.parameters.longitude))
            .geocode { [weak self] placemark, _ in
                if let placemark = placemark {
                    self?.locationNameLabel?.text = "\(placemark.locality ?? "Unknown"), \(placemark.country ?? "Unknown")"
                } else {
                    self?.locationNameLabel?.text = "Unknown"
                }
        }
        
        guard let galleryImageView = galleryImageView,
            let imageUrl = URL(string: model.smallImagePath) else { return }
        
        Nuke.loadImage(with: imageUrl, into: galleryImageView)
    }
}
