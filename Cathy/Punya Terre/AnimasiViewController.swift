//
//  AnimasiViewController.swift
//  Cathy
//
//  Created by Terretino on 11/10/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import UIKit

class AnimasiViewController: UIViewController {
    
    var kelasAnimasi = animasiIdle()
    var loliArray: [UIImage] = []
    @IBOutlet weak var gambarnya: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loliArray = kelasAnimasi.buatImageArray(total: 53, imagePrefix: "loli")
        kelasAnimasi.animasi(imageView: gambarnya, images: loliArray)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
