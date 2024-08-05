//
//  Planet.swift
//  Planetary App
//
//  Created by David Chandra on 22/06/24.
//

import Foundation
import SwiftData

@Model
class Planet {
    var name: String
    var picture: Data?
    
    init(name: String, picture: Data?) {
        self.name = name
        self.picture = picture
    }
}
