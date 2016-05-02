//
//  Meme.swift
//  MemeMe
//
//  Created by soheiln on 5/2/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import UIKit

struct Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
    init(topText_: String, bottomText_: String, originalImage_: UIImage, memedImage_: UIImage) {
        topText = topText_
        bottomText = bottomText_
        originalImage = originalImage_
        memedImage = memedImage_
    }
}
