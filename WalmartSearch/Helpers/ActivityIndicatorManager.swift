//
//  ActivityIndicatorExtension.swift
//  WalmartSearch
//
//  Created by Dalton on 5/14/18.
//  Copyright © 2018 Dalton. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {
    
    func dismissLoadingIndicator() {
        self.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}

class ActivityIndicatorManager {
    func showLoadingIndicator(view: UIView) -> UIActivityIndicatorView {
        
        let spinner = UIActivityIndicatorView(frame: CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height:view.frame.size.height))
        spinner.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        spinner.clipsToBounds = true
        spinner.hidesWhenStopped = true
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        return spinner
    }
}
