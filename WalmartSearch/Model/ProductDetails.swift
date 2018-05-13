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
    let salePrice: Double?
    let shortDescription: String?
    let longDescription: String?
    let brandName: String?
    let thumbnailUrlString: String?
    let mediumImageUrlString: String?
    let largeImage: String?
    let standardShipRate: Float?
    let size: String?
    let color: String?
    let marketPlace: Bool?
    let shipToStore: Bool?
    let freeShipToStore: Bool?
    let modelNumber: String?
    let stock: String?
    let offerType: String?
    let isTwoDayShippingAvailable: Bool?
    let availableOnline: Bool?
    
    init(itemId: Int?, parentItemId: Int?, name: String?, salePrice: Double?, shortDescription: String?, longDescription: String?, brandName: String?, thumbnailUrlString: String?, mediumImageUrlString: String?, largeImage: String?, standardShipRate: Float?, size: String?, color: String?, marketPlace: Bool?, shipToStore: Bool?, freeShipToStore: Bool?, modelNumber: String?, stock: String?, offerType: String?, isTwoDayShippingAvailable: Bool?, availableOnline: Bool?) {
        self.itemId = itemId
        self.parentItemId = parentItemId
        self.name = name
        self.salePrice = salePrice
        self.shortDescription = shortDescription
        self.longDescription = longDescription
        self.brandName = brandName
        self.thumbnailUrlString = thumbnailUrlString
        self.mediumImageUrlString = mediumImageUrlString
        self.largeImage = largeImage
        self.standardShipRate = standardShipRate
        self.size = size
        self.color = color
        self.marketPlace = marketPlace
        self.shipToStore = shipToStore
        self.freeShipToStore = freeShipToStore
        self.modelNumber = modelNumber
        self.stock = stock
        self.offerType = offerType
        self.isTwoDayShippingAvailable = isTwoDayShippingAvailable
        self.availableOnline = availableOnline
    }
}
