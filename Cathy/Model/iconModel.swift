//
//  iconModel.swift
//  Cathy
//
//  Created by Victor  Christopher on 29/08/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import UIKit

struct iconData {
    var iconImage: UIImage?
}

var data = [iconData(iconImage: UIImage(named: "gambar-1"))]


func showLoader(view: UIView) -> UIActivityIndicatorView {
    //Customize as per your need
    let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height:40))
    spinner.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    spinner.layer.cornerRadius = 3.0
    spinner.clipsToBounds = true
    spinner.hidesWhenStopped = true
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white;
    spinner.center = view.center
    view.addSubview(spinner)
    spinner.startAnimating()
    UIApplication.shared.beginIgnoringInteractionEvents()
    
    return spinner
}

extension UIActivityIndicatorView {
    func dismissLoader() {
        self.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
