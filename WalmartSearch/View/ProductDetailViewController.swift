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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var stockLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var availableOnlineLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var shipRateLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var marketplaceLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var shipToStoreLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var twoDayShippingLabelHeightConstraint: NSLayoutConstraint!
    
    let activityIndicatorManager:ActivityIndicatorManager = ActivityIndicatorManager()
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
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Api Calls
    func getProductDetailsFor(itemId: Int) {
        let loadingIndicator:UIActivityIndicatorView = activityIndicatorManager.showLoadingIndicator(view: self.view)
        WebService.sharedInstance.getProductDetails(itemId: itemId) { (productDetailsObject, errorMessage) in
            if let productDetailsObj = productDetailsObject {
                self.productDetails = productDetailsObj
                self.populateViewWithProductDetails()
                self.getRecommendationsFor(itemId: itemId, loadingIndicator:loadingIndicator)
            }
            if !errorMessage.isEmpty {
                print("Lookup details error: " + errorMessage)
            }
        }
    }
    
    func getRecommendationsFor(itemId: Int, loadingIndicator:UIActivityIndicatorView) {
        WebService.sharedInstance.getRecommendations(itemId: itemId) { (recommendationsArray, errorMessage) in
            if let recs = recommendationsArray {
                self.recommendations = recs
                self.collectionView.reloadData()
                self.collectionViewHeightConstraint.constant = 128.0
                self.collectionView.setContentOffset(.zero, animated: true)
            }
            if !errorMessage.isEmpty {
                print("Recommendations error: " + errorMessage)
                self.collectionViewHeightConstraint.constant = 0.0
                
            }
            loadingIndicator.dismissLoadingIndicator()
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
                let formattedPrice:String = NumberHelpter.formatDouble(double: price)
                priceLabel.text = "$\(formattedPrice)"
            }
            
            if let itemId = productDetails.itemId {
                itemIdLabel.text = "#\(itemId)"
            }
            
            if let stock = productDetails.stock {
                stockLabel.text = "Stock: \(stock)"
            } else {
                stockLabelHeightConstraint.constant = 0.0
            }
            
            if let availableOnline = productDetails.availableOnline {
                
                if availableOnline {
                    availableOnlineLabel.text = "Available Online"
                    availableOnlineLabel.textColor = Constants.Colors.marketGreen
                } else {
                   availableOnlineLabel.text = "Not Available Online"
                   availableOnlineLabel.textColor = Constants.Colors.rollbackRed
                }
            } else {
                availableOnlineLabelHeightConstraint.constant = 0.0
            }
            
            if let standardShipRate = productDetails.standardShipRate {
                let formattedRate:String = NumberHelpter.formatDouble(double: standardShipRate)
                standardShipRateLabel.text = "Standard Shipping Rate: $\(formattedRate)"
            } else {
                shipRateLabelHeightConstraint.constant = 0.0
            }
            
            if let marketplace = productDetails.marketPlace {
                marketplaceLabel.text = marketplace ? "Sold by Marketplace Participant" : "Sold by WalMart"
            } else {
                marketplaceLabelHeightConstraint.constant = 0.0
            }
            
            if let shipToStore = productDetails.shipToStore, let freeShipToStore = productDetails.freeShipToStore {
                if shipToStore == false {
                    shipToStoreLabel.text = "Ship to Store Not Available"
                    shipToStoreLabel.textColor = Constants.Colors.rollbackRed
                } else {
                    if freeShipToStore == true {
                        shipToStoreLabel.text = "FREE Ship to Store"
                        shipToStoreLabel.textColor = Constants.Colors.marketGreen

                    } else {
                        shipToStoreLabel.text = "Ship to Store"
                        shipToStoreLabel.textColor = Constants.Colors.marketGreen
                    }
                }
            } else {
                shipToStoreLabelHeightConstraint.constant = 0.0
            }
            
            
            if let imageUrl = productDetails.mediumImageUrlString {
                let url:URL = URL(string: imageUrl)!
                productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_image"), options: .continueInBackground, completed: nil)
            }
            
            if let twoDayShipping = productDetails.isTwoDayShippingAvailable {
                if twoDayShipping {
                    isTwoDayShippingAvailableLabel.text = "Two Day Shipping"
                } else {
                    twoDayShippingLabelHeightConstraint.constant = 0.0
                }
            } else {
                twoDayShippingLabelHeightConstraint.constant = 0.0
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
