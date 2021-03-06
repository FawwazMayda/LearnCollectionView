//
//  DataSource.swift
//  RayWenderlichLibrary
//
//  Created by Muhammad Fawwaz Mayda on 23/05/20.
//  Copyright © 2020 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit
class DataSource: NSObject {
    static let shared = DataSource()
    var tutorials = [TutorialCollection]()
    private let decoder = PropertyListDecoder()
    private override init() {
        guard let url = Bundle.main.url(forResource: "Tutorials", withExtension: "plist"),
        let data = try? Data(contentsOf: url),
            let tutorials = try? decoder.decode([TutorialCollection].self, from: data) else {
                self.tutorials = []
                return
        }
        self.tutorials = tutorials
    }
}
