//
//  BadgeSupplementaryView.swift
//  RayWenderlichLibrary
//
//  Created by Muhammad Fawwaz Mayda on 24/05/20.
//  Copyright © 2020 Ray Wenderlich. All rights reserved.
//

import UIKit

final class BadgeSupplementaryView : UICollectionReusableView {
    static let reuseIdentifier = String(describing: BadgeSupplementaryView.self)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private func configure() {
        backgroundColor = UIColor(named: "rw-green")
        layer.cornerRadius = bounds.width/2.0
    }
}
