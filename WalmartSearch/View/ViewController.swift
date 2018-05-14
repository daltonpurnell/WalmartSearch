//
//  ViewController.swift
//  WalmartSearch
//
//  Created by Dalton on 5/12/18.
//  Copyright © 2018 Dalton. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var trendingProductsCollectionView: UICollectionView!
    
    let tableViewCellReuseId:String = "cell"
    let collectionViewCellReuseId:String = "cell"
    let showSearchResultDetailsSegueId:String = "showSearchDetailVC"
    let showTrendingProductDetailsSegueId:String = "showTrendingDetailVC"
    let collectionViewHeaderReuseId:String = "collectionViewHeader"

    
    
    let webService:WebService = WebService()
    var searchResults:[Product] = []
    var trendingProducts:[Product] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.getTrendingProducts()
        setupNavBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - TableView Delegate & DataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomSearchResultCell = tableView.dequeueReusableCell(withIdentifier: tableViewCellReuseId, for: indexPath) as! CustomSearchResultCell
        
        let product:Product = searchResults[indexPath.row]
        cell.populateCellWithProduct(product: product)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSearchResultDetailsSegueId, sender: self)
    }
    
    // MARK: - UI Methods
    func setupNavBar() {
        if #available(iOS 11.0, *) {

            navigationController?.navigationBar.barTintColor = Constants.Colors.walmartBlue
            if let image = UIImage(named: "walmart-logo") {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                navigationItem.titleView = imageView
            }

            let searchController = UISearchController(searchResultsController: nil)
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.searchController = searchController
            searchController.searchBar.delegate = self
            
            if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
                if let backgroundview = textfield.subviews.first {
                    backgroundview.backgroundColor = UIColor.white
                    backgroundview.layer.cornerRadius = 10
                    backgroundview.clipsToBounds = true
                }
            }
            searchController.searchBar.tintColor = UIColor.white
            searchController.searchBar.setImage(UIImage(named: "clear-icon"), for: UISearchBarIcon.clear, state: .normal)
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: Constants.Colors.darkBlue]
        }
        
    }
    
    // MARK: - CollectionView Delegate & DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendingProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionViewHeaderReuseId, for: indexPath as IndexPath)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CustomRecommendationCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellReuseId, for: indexPath) as! CustomRecommendationCell
        let product:Product = trendingProducts[indexPath.row]
        cell.populateCellWithProduct(product:product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let itemId = trendingProducts[indexPath.row].itemId {
            performSegue(withIdentifier: showTrendingProductDetailsSegueId, sender: self)
        }
    }
    
    // MARK: - Search Bar Delegate Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            dismiss(animated: true) {
                self.getSearchResults(searchTerm: searchText)
            }
        }
    }
    
    // MARK: - Api Calls
    func getSearchResults(searchTerm:String) {
        webService.getSearchResults(searchTerm: searchTerm) { (results, errorMessage) in
            if let results = results {
                self.searchResults = results
                self.tableView.reloadData()
            }
            if !errorMessage.isEmpty {
                print("Search error: " + errorMessage)
            }
        }
    }
    
    func getTrendingProducts() {
        
        webService.getTrendingProducts { (results, errorMessage) in
            if let results = results {
                self.trendingProducts = results
                self.trendingProductsCollectionView.reloadData()
            }
            if !errorMessage.isEmpty {
                print("Trending products error: " + errorMessage)
            }
        }
    }
    
    // MARK: - Passing Data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSearchResultDetailsSegueId {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                if let searchResultItemId = searchResults[indexPath.row].itemId {
                    let selectedProductId:Int = searchResultItemId
                    let detailsVC:ProductDetailViewController = segue.destination as! ProductDetailViewController
                    detailsVC.selectedProductId = selectedProductId
                }
                
            }
        } else if segue.identifier == showTrendingProductDetailsSegueId {
            
            if let indexPath = trendingProductsCollectionView.indexPathsForSelectedItems?.first {
                if let trendingProductItemId = trendingProducts[indexPath.row].itemId {
                    let selectedProductId:Int = trendingProductItemId
                    let detailsVC:ProductDetailViewController = segue.destination as! ProductDetailViewController
                    detailsVC.selectedProductId = selectedProductId
                }
            }
        }
    }
    


}

