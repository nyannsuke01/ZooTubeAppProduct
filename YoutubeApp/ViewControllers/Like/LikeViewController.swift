//
//  LikeViewController.swift
//  ZooTube
//
//  Created by user on 2020/09/01.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class LikeViewController: UIViewController {

    @IBOutlet weak var likeTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
extension LikeViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0 // <= ここを0にしたときに、画像が出現
    }
}

extension LikeViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {

        let displayImage = UIImage(named: "Enpty")
        return displayImage
    }
}


