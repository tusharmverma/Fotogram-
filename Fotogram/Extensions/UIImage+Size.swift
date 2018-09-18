//
//  UIImage+Size.swift
//  Fotogram
//
//  Created by Tushar  Verma on 7/13/18.
//  Copyright © 2018 Tushar Verma. All rights reserved.
//

import UIKit

extension UIImage {
    var aspectHeight: CGFloat {
        let heightRatio = size.height / 736
        let widthRatio = size.width / 414
        let aspectRatio = fmax(heightRatio, widthRatio)
        
        return size.height / aspectRatio
    }
}
