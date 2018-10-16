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
        outletViewContainerChapter.isHidden = true
        
        for i in 1...(currentChapter + 1) {
            chapter.append(i)
        }
        chapter.append(2)
        chapter.append(3)
        chapter.append(4)
        chapter.append(5)
        chapter.append(6)
        chapter.append(7)
        
        outletTableViewChapterMaps.delegate = self
        outletTableViewChapterMaps.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = outletTableViewChapterMaps.dequeueReusableCell(withIdentifier: "CellChapterMaps") as! MapsChapterTableViewCell
        
        cell.outletButtonChapter.setTitle("Chapter \(chapter[indexPath.row])", for: .normal)
        cell.outletButtonChapter.tag = chapter[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    @IBAction func actionButtonExit(_ sender: Any) {
        outletViewContainerChapter.isHidden = true
    }
    
    @IBAction func actionButtonListChronology(_ sender: UIButton) {
        outletViewContainerChapter.isHidden = false
    }
    
    @IBAction func actionButtonChooseChapter(_ sender: UIButton) {
        currentChapter = sender.tag - 1
        print(sender.tag)
    }
}
