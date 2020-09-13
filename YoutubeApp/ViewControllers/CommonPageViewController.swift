//
//  CommonPageViewController.swift
//  ZooTube
//
//  Created by user on 2020/09/02.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import SDWebImage
import XLPagerTabStrip
import Alamofire

class CommonPageViewController: UITableViewController {

    //キーワードのインスタンス化 selfのプロパティを当てる
    var keyword: String?

//    init(keyword: String) {
//        self.keyword = keyword
//        // クラスの持つ指定イニシャライザを呼び出す
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        // UIViewControllerを継承したクラスでイニシャライザをカスタムする際に必要となるコード。（自動生成）
//        fatalError("init(coder:) has not been implemented")
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

//    //(XLPagerTabStrip)タブタイトルを返却するコードは共通化
//    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
//        return IndicatorInfo(title: self.keyword!)
//    }

}

