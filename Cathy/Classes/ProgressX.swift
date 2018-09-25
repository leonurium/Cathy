//
//  ProgressX.swift
//  Cathy
//
//  Created by Rangga Leo on 21/09/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

class ProgressX: UIView {
    
    let progressLabel : UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.textColor = UIColor.white
        label.font = UIFont(name: "Helvetica", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let progressBar : UIProgressView = {
        let progress = UIProgressView()
        progress.progress = 0.0
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    init(frame: CGRect, view: UIView) {
        super.init(frame : frame)
        
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        
        addSubview(progressBar)
        progressBar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        progressBar.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        progressBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        addSubview(progressLabel)
        progressLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        progressLabel.bottomAnchor.constraint(equalTo: progressBar.topAnchor, constant: -5).isActive = true
        
        view.isUserInteractionEnabled = false
    }
    
    func dismiss(view: UIView)
    {
        progressBar.isHidden = true
        progressLabel.isHidden = true
        view.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
