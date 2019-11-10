//
//  CardModel.swift
//  testProject
//
//  Created by Hayk Hartynyan on 11/10/19.
//  Copyright © 2019 Hayk Hartynyan. All rights reserved.
//

import Foundation
import UIKit

struct CardModel {
    var cardName: String //name
    var imageURI: String //image_uris["small"]
    var cardType: String //type_line
    var flavorText: String //flavor_text
    var image: UIImage? //flavor_text

    
    init(_ data: [String: Any]) {
        cardName = data["name"] as? String ?? ""
        cardType = data["type_line"] as? String ?? ""
        imageURI = (data["image_uris"] as? Dictionary ?? [:])["small"] as? String ?? ""
        flavorText = data["flavor_text"] as? String ?? ""
    }
}
