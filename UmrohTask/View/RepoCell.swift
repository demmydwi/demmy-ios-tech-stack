//
//  RepoCell.swift
//  UmrohTask
//
//  Created by Demmy Dwi Rhamadan on 16/01/20.
//  Copyright © 2020 Demmy Dwi Rhamadan. All rights reserved.
//

import UIKit
import Kingfisher

class RepositoryCell: UITableViewCell {
    static let Identifier = "RepositoryCell"
    let indicator = UIActivityIndicatorView.init(style: .medium)
    var finishLabel = UILabel()
    
    @IBOutlet weak var ivOwner: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnShare: UIButton!
}

extension RepositoryCell {
    
    func configureWith(repoModel: RepoModel, searchText: String) {
        
        if let isLoading = repoModel.isLoadingView {
            if (isLoading) {
                onLoading()
            } else {
                onFinish()
            }
        } else {
            onItemLoad(repoModel, searchText)
        }
    }
    
    private func onItemLoad(_ repoModel: RepoModel, _ searchText: String){
        remove(indicator)
        remove(finishLabel)
        hideContent(isHidden: false)
        setImage(repoModel: repoModel)
        setLabel(repoModel: repoModel, searchText: searchText)
    }
    
    private func setImage(repoModel: RepoModel){
        let url = URL(string: repoModel.owner?.avatarURL ?? "-")
        let processor =
            DownsamplingImageProcessor(size: ivOwner.frame.size) |>
            RoundCornerImageProcessor(cornerRadius: 24)
        ivOwner.kf.setImage(with: url, options: [
            .processor(processor), .transition(.fade(1)), .cacheOriginalImage])
    }
    
    private func setLabel(repoModel: RepoModel, searchText: String){
        let name = repoModel.owner?.login ?? "-"
        let repoName = repoModel.name ?? "-"
        let fullName = name + "/" + repoName
        lblTitle.attributedText = highlightedString(fullString: fullName, highlightedString: searchText)
        
        let descText = repoModel.itemDescription ?? "-"
        lblDesc.attributedText = highlightedString(fullString: descText, highlightedString: searchText)
    }
    
    private func onLoading(){
        remove(finishLabel)
        hideContent(isHidden: true)
        indicator.color = .gray
        indicator.center = contentView.center
        indicator.startAnimating()
        contentView.addSubview(indicator)
    }
    private func onFinish(){
        remove(indicator)
        hideContent(isHidden: true)
        finishLabel.text = "-- All item loaded --"
        finishLabel.centerInSuperview()
        contentView.addSubview(finishLabel)
    }
    
    private func hideContent(isHidden: Bool){
        lblTitle.isHidden = isHidden
        lblDesc.isHidden = isHidden
        ivOwner.isHidden = isHidden
        btnShare.isHidden = isHidden
    }
    
    private func remove(_ _view: UIView){
        if let _ = _view.superview {
            _view.removeFromSuperview()
        }
    }
    
    private func highlightedString(fullString: String, highlightedString: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: fullString)
        let str = NSString(string: fullString)
        let theRange = str.range(of: highlightedString, options: .caseInsensitive)
        attributedString.addAttribute(.backgroundColor, value: UIColor.yellow, range: theRange)
        return attributedString
    }
}
