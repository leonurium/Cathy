//
//  ViewController.swift
//  Cathy
//
//  Created by Rangga Leo on 14/08/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var outletImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let images = UIImage(named: "leo.jpg")
        outletImageView.image = images
        let face = FaceDetectionClass()
        face.detect(image: images!)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

