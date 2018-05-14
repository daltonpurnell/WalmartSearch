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
    @IBOutlet weak var nameLabel: H1Label!
    @IBOutlet weak var priceLabel: H2Label!
    @IBOutlet weak var itemIdLabel: P1Label!
    @IBOutlet weak var stockLabel: H2Label!
    @IBOutlet weak var availableOnlineLabel: P1Label!
    @IBOutlet weak var standardShipRateLabel: P1Label!
    @IBOutlet weak var marketplaceLabel: P1Label!
    @IBOutlet weak var shipToStoreLabel: H2Label!
    @IBOutlet weak var isTwoDayShippingAvailableLabel: P1Label!
    @IBOutlet weak var descriptionLabel: P1Label!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    let webService:WebService = WebService()
    let collectionViewCellReuseId:String = "cell"
    let collectionViewHeaderReuseId:String = "collectionViewHeader"

    
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
                self.collectionViewHeightConstraint.constant = 128.0
            }
            if !errorMessage.isEmpty {
                print("Recommendations error: " + errorMessage)
                self.collectionViewHeightConstraint.constant = 0.0
                
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
                descriptionLabel.text = description.htmlToString
            }
        }
    
    }
    
    // MARK: - CollectionView Delegate & DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionViewHeaderReuseId, for: indexPath as IndexPath)
        return headerView
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
