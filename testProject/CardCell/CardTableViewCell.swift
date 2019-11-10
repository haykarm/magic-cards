//
//  CardTableViewCell.swift
//  testProject
//
//  Created by Hayk Hartynyan on 11/10/19.
//  Copyright © 2019 Hayk Hartynyan. All rights reserved.
//

import Foundation
import UIKit

class CardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var flavorLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    public func setup(_ model: CardModel?) {
        guard let model = model else {
            return
        }
        flavorLabel.text = model.flavorText
        nameLabel.text = model.cardName
        typeLabel.text = model.cardType
        cardImageView.image = model.image ?? UIImage(named: "placeholder")
    }
    
    
}
