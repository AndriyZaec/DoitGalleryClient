//
//  DoitTextFiled.swift
//  DoitGalleryClient
//
//  Created by Andrew Zaiets on 2/10/19.
//  Copyright © 2019 Andrew Zaiets. All rights reserved.
//

import UIKit

class DoitTextFiled: UITextField {
    
    @IBInspectable
    var underlineWidth: CGFloat = 2.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addUnderlineLayer(width: underlineWidth)
    }
    
}
