//
//  TitleSupplementaryView.swift
//  RayWenderlichLibrary
//
//  Created by Muhammad Fawwaz Mayda on 23/05/20.
//  Copyright © 2020 Ray Wenderlich. All rights reserved.
//

import UIKit

class TitleSupplementaryView : UICollectionReusableView {
    static let reuseIdentifier = String(describing: TitleSupplementaryView.self)
    var textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("No Implement")
    }
    
    private func configure() {
        addSubview(textLabel)
        textLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let inset : CGFloat = 4.0
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: inset),
            textLabel.trailingAnchor.constraint(equalToSystemSpacingAfter: trailingAnchor, multiplier: -inset),
            textLabel.bottomAnchor.constraint(equalToSystemSpacingBelow: bottomAnchor, multiplier: -inset),
            textLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: inset)
        ])
    }
}
