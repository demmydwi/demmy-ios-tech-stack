//
//  UILabel.swift
//  UmrohTask
//
//  Created by Demmy Dwi Rhamadan on 15/01/20.
//  Copyright © 2020 Demmy Dwi Rhamadan. All rights reserved.
//

import UIKit

extension UILabel {
    convenience public init(text: String? = nil, font: UIFont? = UIFont.systemFont(ofSize: 14), textColor: UIColor = .black, textAlignment: NSTextAlignment = .left, numberOfLines: Int = 1) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
}
