//
//  ViewController.swift
//  WalmartSearch
//
//  Created by Dalton on 5/12/18.
//  Copyright © 2018 Dalton. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    let cellReuseId:String = "cell"
    let showDetailsSegueId:String = "showDetailVC"
    
    
    let webService:WebService = WebService()
    var searchResults:[Product] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupNavBar()
        setDynamicCellHeight()
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
        let cell:CustomSearchResultCell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as! CustomSearchResultCell
        
        let product:Product = searchResults[indexPath.row]
        cell.populateCellWithProduct(product: product)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showDetailsSegueId, sender: self)
    }
    
    // MARK: - UI Methods
    func setupNavBar() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
            navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 0/255, green: 150/255, blue: 136/255, alpha: 1.0)
            
            let searchController = UISearchController(searchResultsController: nil)
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.searchController = searchController
            navigationItem.searchController?.searchBar.delegate = self
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
    
    func setDynamicCellHeight() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 250
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
    
    // MARK: - Passing Data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showDetailsSegueId {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let itemId = searchResults[indexPath.row].itemId {
                    let selectedProductId:Int = itemId
                    let detailsVC:ProductDetailViewController = segue.destination as! ProductDetailViewController
                    detailsVC.selectedProductId = selectedProductId
                }
            }
        }
    }
    


}

