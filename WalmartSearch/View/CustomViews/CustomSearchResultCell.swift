//
//  CustomSearchResultCell.swift
//  WalmartSearch
//
//  Created by Dalton on 5/12/18.
//  Copyright © 2018 Dalton. All rights reserved.
//

import Foundation
import UIKit

class CustomSearchResultCell:UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    func populateCellWithProduct(product:Product) {
        if let name = product.name {
            nameLabel.text = name
        }
        
        if let price = product.salePrice {
            priceLabel.text = "$\(price)"
        }
        if let description = product.shortDescription {
            descriptionLabel.text = description
        }
    }
    
}
