//
//  ProductDetails.swift
//  WalmartSearch
//
//  Created by Dalton on 5/12/18.
//  Copyright © 2018 Dalton. All rights reserved.
//

import Foundation

class ProductDetails {
    
    let itemId: Int?
    let parentItemId: Int?
    let name: String?
    let salePrice: Float?
    let shortDescription: String?
    let longDescription: String?
    let thumbnailUrlString: String?
    
    init(itemId: Int?, parentItemId: Int?, name: String?, salePrice: Float?, shortDescription: String?, longDescription: String?, thumbnailUrlString: String?) {
        self.itemId = itemId
        self.parentItemId = parentItemId
        self.name = name
        self.salePrice = salePrice
        self.shortDescription = shortDescription
        self.longDescription = longDescription
        self.thumbnailUrlString = thumbnailUrlString
    }
}
