//
//  CustomSearchController.swift
//  WalmartSearch
//
//  Created by Dalton on 5/14/18.
//  Copyright © 2018 Dalton. All rights reserved.
//

import UIKit

class CustomSearchController: UISearchController {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.customInit()
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        customInit()
    }
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        customInit()
    }
    
    fileprivate func customInit() {
        addProperties()
    }
    
    func addProperties() {
        if #available(iOS 11.0, *) {
            if let textfield = self.searchBar.value(forKey: "searchField") as? UITextField {
                if let backgroundview = textfield.subviews.first {
                    backgroundview.backgroundColor = UIColor.white
                    backgroundview.layer.cornerRadius = 10
                    backgroundview.clipsToBounds = true
                }
                textfield.clearButtonMode = UITextFieldViewMode.whileEditing
            }
            self.searchBar.tintColor = UIColor.white
            self.searchBar.setImage(UIImage(named: "clear-icon"), for: UISearchBarIcon.clear, state: .normal)
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: Constants.Colors.darkBlue]
        }
    }
}
