//
//  Person.swift
//  HodHod
//
//  Created by Ahmed Ibrahim on 8/2/18.
//  Copyright © 2018 Ahmed Ibrahim. All rights reserved.
//

import UIKit
import CoreLocation

struct Person {
    let name: String?
    let personID: String?
    let imageData: String?
    let location: String?
    
    func image() -> UIImage? {
        return imageData
            .flatMap({ Data(base64Encoded: $0) })
            .flatMap({ UIImage(data: $0) })
    }
}
