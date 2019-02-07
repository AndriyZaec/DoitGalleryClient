//
//  GalleryItemCollectionViewCell.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/7/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import UIKit

class GalleryItemCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties -
    @IBOutlet private weak var galleryImageView: UIImageView?
    @IBOutlet private weak var weatherLabel: UILabel?
    @IBOutlet private weak var locationNameLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
