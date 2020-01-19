//
//  UITableViewExt.swift
//  UmrohTask
//
//  Created by Demmy Dwi Rhamadan on 16/01/20.
//  Copyright © 2020 Demmy Dwi Rhamadan. All rights reserved.
//

import UIKit

extension UITableView {
    func setEmptyOrErrorMessage(errorMessage: String){
        let _title = errorMessage.isEmpty ? "No repositories found" : "Sorry"
        let _message = errorMessage.isEmpty ? "Please try different keywords" : errorMessage
        let nameLabel = UILabel(text: "\(_title)\n\(_message)", font: .boldSystemFont(ofSize: 15), textColor: .black,
                                textAlignment: .center, numberOfLines: 3)
        self.backgroundView = nameLabel
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
//    func setLoading(isLoading: Bool) {
//        if (isLoading) {
//            let ai = UIActivityIndicatorView.init(style: .large)
//            ai.startAnimating()
//            ai.center = self.center
//            self.backgroundView = ai
//            self.separatorStyle = .none
//        } else {
//            self.backgroundView = nil
//            self.separatorStyle = .singleLine
//        }
//    }
}
