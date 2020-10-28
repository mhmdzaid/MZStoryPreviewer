//
//  ZStoryPublisherCell.swift
//  ZStory publisher Demo
//
//  Created by Mohamed Zead on 10/4/20.
//  Copyright © 2020 Spark Cloud. All rights reserved.
//

import Foundation
import UIKit

internal class MZStoryUserCell: UICollectionViewCell {
    
    internal lazy var storyContentView: MZStoryContentView = {
        let contentView_ = MZStoryContentView(frame: frame)
        contentView_.translatesAutoresizingMaskIntoConstraints = false
        return contentView_
    }()
    
    internal var storyColors : [UIColor] = []
    internal var user: MZStoryUser? {
        didSet {
            storyContentView.userNameLabel.text = user?.userName ?? ""
            storyContentView.storyImageView.loadImage(user?.userImageURLPath,completion: {
            })
        }
    }
    
    override var reuseIdentifier: String? {
        return "userCell"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        storyContentView.gradient?.removeAllAnimations()
        storyContentView.gradient?.removeFromSuperlayer()
        storyContentView.shape?.removeAllAnimations()
        storyContentView.shape?.removeFromSuperlayer()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(storyContentView)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(storyContentView)
        setUpConstraints()
    }
    
     func setUpStrokeifAvailable() {
        let isEmpty = user?.userStoryItems.isEmpty ?? true
        DispatchQueue.main.async { [weak self] in
            guard let self = self else{return}
            self.storyContentView.storyImageView.setToCircular()
            guard !isEmpty else { return }
            self.storyContentView.addCircleGradiendBorder(2.0, self.storyColors)
        }
        
    }
    
    fileprivate func setUpConstraints() {
        NSLayoutConstraint.activate([
            // contentView
            storyContentView.topAnchor.constraint(equalTo: topAnchor),
            storyContentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            storyContentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            storyContentView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

