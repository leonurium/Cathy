//
//  MapsViewController.swift
//  Cathy
//
//  Created by Rangga Leo on 26/09/18.
//  Copyright © 2018 Rangga Leo. All rights reserved.
//

import UIKit

class MapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var currentChapter: Int = 0
    var chapter: [Int] = []
    
    @IBOutlet weak var outletViewContainerChapter: UIView!
    @IBOutlet weak var outletTableViewChapterMaps: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...(currentChapter + 1) {
            chapter.append(i)
        }
        
        outletTableViewChapterMaps.delegate = self
        outletTableViewChapterMaps.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = outletTableViewChapterMaps.dequeueReusableCell(withIdentifier: "CellChapterMaps") as! MapsChapterTableViewCell
        
        cell.outletButtonChapter.setTitle("\(chapter[indexPath.row])", for: .normal)
        cell.outletButtonChapter.tag = chapter[indexPath.row]
        
        return cell
    }
    
    @IBAction func actionButtonListChronology(_ sender: UIButton) {
        
    }
    
    @IBAction func actionButtonChooseChapter(_ sender: UIButton) {
        currentChapter = sender.tag - 1
        print(sender.tag)
    }
}
