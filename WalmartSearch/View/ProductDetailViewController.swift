//
//  ProductDetailViewController.swift
//  WalmartSearch
//
//  Created by Dalton on 5/12/18.
//  Copyright © 2018 Dalton. All rights reserved.
//

import UIKit

class ProductDetailViewController:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemIdLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var availableOnlineLabel: UILabel!
    @IBOutlet weak var standardShipRateLabel: UILabel!
    @IBOutlet weak var marketplaceLabel: UILabel!
    @IBOutlet weak var shipToStoreLabel: UILabel!
    @IBOutlet weak var isTwoDayShippingAvailableLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let webService:WebService = WebService()
    let collectionViewCellReuseId:String = "cell"
    
    var selectedProductId:Int?
    var productDetails:ProductDetails?
    var recommendations:[Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let itemId = selectedProductId {
            getProductDetailsFor(itemId: itemId)
        } else {
            print("No item id")
        }
    }
    
    // MARK: - Api Calls
    func getProductDetailsFor(itemId: Int) {
        webService.getProductDetails(itemId: itemId) { (productDetailsObject, errorMessage) in
            if let productDetailsObj = productDetailsObject {
                self.productDetails = productDetailsObj
                self.populateViewWithProductDetails()
                self.getRecommendationsFor(itemId: itemId)
            }
            if !errorMessage.isEmpty {
                print("Lookup details error: " + errorMessage)
            }
        }
    }
    
    func getRecommendationsFor(itemId: Int) {
        webService.getRecommendations(itemId: itemId) { (recommendationsArray, errorMessage) in
            if let recs = recommendationsArray {
                self.recommendations = recs
                self.collectionView.reloadData()
            }
            if !errorMessage.isEmpty {
                print("Recommendations error: " + errorMessage)
            }

        }
    }
    
    // MARK: - UI Methods
    func populateViewWithProductDetails() {
        if let productDetails = self.productDetails {
            if let name = productDetails.name {
                nameLabel.text = name
                if let brandName = productDetails.brandName, let modelNumber = productDetails.modelNumber {
                    nameLabel.text = "\(name) - \(brandName) - \(modelNumber)"
                }
            }
            
            if let price = productDetails.salePrice {
                priceLabel.text = "$\(price)"
            }
            
            if let itemId = productDetails.itemId {
                itemIdLabel.text = "#\(itemId)"
            }
            
            if let stock = productDetails.stock {
                stockLabel.text = "In Stock: \(stock)"
            }
            
            if let availableOnline = productDetails.availableOnline {
                availableOnlineLabel.text = availableOnline ? "Available Online" : "Not Available Online"
            }
            
            if let standardShipRate = productDetails.standardShipRate {
                standardShipRateLabel.text = "$\(standardShipRate)"
            }
            
            if let marketplace = productDetails.marketPlace {
                marketplaceLabel.text = marketplace ? "Sold by Marketplace Participant" : ""
            }
            
            if let shipToStore = productDetails.shipToStore, let freeShipToStore = productDetails.freeShipToStore {
                if shipToStore == false {
                    shipToStoreLabel.text = "Ship to Store Not Available"
                } else {
                    if freeShipToStore == true {
                        shipToStoreLabel.text = "FREE Ship to Store"
                    } else {
                        shipToStoreLabel.text = "Ship to Store"
                    }
                }
                
                if let imageUrl = productDetails.mediumImageUrlString {
                    let url:URL = URL(string: imageUrl)!
                    productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_image"), options: .continueInBackground, completed: nil)
                }
            }
            
            if let twoDayShipping = productDetails.isTwoDayShippingAvailable {
                isTwoDayShippingAvailableLabel.text = twoDayShipping ? "Two Day Shipping" : ""
            }
            
            if let description = productDetails.longDescription {
                descriptionLabel.text = description
            }
        }
    
    }
    
    // MARK: - CollectionView Delegate & DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CustomRecommendationCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellReuseId, for: indexPath) as! CustomRecommendationCell
        let product:Product = recommendations[indexPath.row]
        cell.populateCellWithProduct(product:product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let itemId = recommendations[indexPath.row].itemId {
            getProductDetailsFor(itemId: itemId)
        }
    }
}
