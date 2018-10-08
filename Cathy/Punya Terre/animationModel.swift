//
//  animationModel.swift
//  Cathy
//
//  Created by Terretino on 25/09/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import Foundation
import UIKit

public class animasiIdle: UIViewController {
    //@IBOutlet weak var outletImage: UIImageView!

    //Fungsi masukin gambar animasinya ke array holder
    func buatImageArray(total: Int, imagePrefix: String) -> [UIImage] {
        var arrayImage: [UIImage] = []
        for imageCount in 0..<total{
            let namaImage = "\(imagePrefix)\(imageCount).png"
            let image = UIImage(named: namaImage)!
            arrayImage.append(image)
        }
        return arrayImage
    }
    
    //Fungsi Animasi
    func animasi(imageView: UIImageView, images: [UIImage]) {
        imageView.animationImages = images
        imageView.animationDuration = 0.5
        imageView.startAnimating()
    }
    
}

