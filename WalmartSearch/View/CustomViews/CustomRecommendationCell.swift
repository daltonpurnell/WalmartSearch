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
    @IBOutlet weak var nameLabel: H2Label!
    @IBOutlet weak var priceLabel: H2Label!
    
    func populateCellWithProduct(product:Product) {
        if let name = product.name {
            nameLabel.text = name
        }
        
        if let price = product.salePrice {
            let formattedPrice:String = NumberHelpter.formatDouble(double: price)
            priceLabel.text = "$\(formattedPrice)"
        }
        
        if let imageUrl = product.thumbnailUrlString {
            let url:URL = URL(string: imageUrl)!
            productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder-image"), options: .continueInBackground, completed: nil)
        }
    }
    
}
