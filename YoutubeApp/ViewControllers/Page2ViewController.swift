//
//  Page1ViewController.swift
//  ZooTube
//
//  Created by user on 2020/03/14.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import SDWebImage
import XLPagerTabStrip
import Alamofire

class Page2ViewController: CommonPageViewController, IndicatorInfoProvider{

    override func viewDidLoad() {
        self.keyword = "うさぎ"
        self.view.backgroundColor = UIColor.brown
        super.viewDidLoad()

     }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: self.keyword)
    }
}

