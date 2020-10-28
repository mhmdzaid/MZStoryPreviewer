//
//  UImageView + Extension.swift
//  ZStory publisher Demo
//
//  Created by Mohamed Zead on 10/4/20.
//  Copyright © 2020 Spark Cloud. All rights reserved.
//

import UIKit
import SDWebImage

internal extension UIImageView {
    /// loads Image from url  given in string
    func loadImage(_ urlString: String?, completion: (() -> ())? = nil) {
        guard let url = URL(string: urlString ?? "") else { return }
        self.sd_setImage(with: url) { (_, error, _, _) in
            guard error != nil else{  (completion ?? {})()
                return
            }
            
        }
    }

    /// Makes the imageView in a circle shape
    func setToCircular() {
        let cornerRadius = frame.size.width / 2
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        layer.sublayers?.forEach { layer in
            layer.removeFromSuperlayer()
        }
    }

   
}
