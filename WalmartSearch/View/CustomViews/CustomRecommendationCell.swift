//
//  CustomRecommendationCell.swift
//  WalmartSearch
//
//  Created by Dalton on 5/12/18.
//  Copyright © 2018 Dalton. All rights reserved.
//

import UIKit

class CustomRecommendationCell: UICollectionViewCell {
    @IBOutlet weak var productImageView: UIImageView!
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
        
        if let imageUrl = product.thumbnailUrlString {
            let url:URL = URL(string: imageUrl)!
            productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_image"), options: .continueInBackground, completed: nil)
        }
    }
    
}
