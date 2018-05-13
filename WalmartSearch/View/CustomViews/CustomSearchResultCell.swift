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
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: H1Label!
    @IBOutlet weak var priceLabel: H2Label!
    @IBOutlet weak var descriptionLabel: P1Label!
    
    
    func populateCellWithProduct(product:Product) {
        if let name = product.name {
            nameLabel.text = name
        }
        
        if let price = product.salePrice {
            priceLabel.text = "$\(price)"
        }
        if let description = product.shortDescription {
            descriptionLabel.text = description.htmlToString
        }
        
        if let imageUrl = product.thumbnailUrlString {
            let url:URL = URL(string: imageUrl)!
            productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_image"), options: .continueInBackground, completed: nil)
        }
    }
    
}
