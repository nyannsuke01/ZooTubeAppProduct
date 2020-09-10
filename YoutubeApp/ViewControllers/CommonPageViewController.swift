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

class CommonPageViewController: UITableViewController, IndicatorInfoProvider {

 //   var youtubeData = YoutubeData()
//    var videoIdArray = [String]()
//    var publishedAtArray = [String]()
//    var titleArray = [String]()
//    var imageURLStringArray = [String]()
//    var youtubeURLArray = [String]()
//    var channelTitleArray = [String]()
//
//    let refresh = UIRefreshControl()


    //キーワードのインスタンス化 selfのプロパティを当てる　それがないと
    var keyword: String?

    init(keyword: String) {
        self.keyword = keyword
        // クラスの持つ指定イニシャライザを呼び出す
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        // UIViewControllerを継承したクラスでイニシャライザをカスタムする際に必要となるコード。（自動生成）
        fatalError("init(coder:) has not been implemented")
    }



    override func viewDidLoad() {
        super.viewDidLoad()
//        update()
    }


//    @objc func update(){
//
//        //api.getData()
//        tableView.reloadData()
//        refresh.endRefreshing()
//
//    }

//    //PageXViewControllerのtableViewの共通処理
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
//
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
//        cell.selectionStyle = .none
//        let profieleImageURL = URL(string: imageURLStringArray[indexPath.row] as String)!
//
//
//        cell.imageView?.sd_setImage(with: profieleImageURL, completed: { (image, error, _, _) in
//            if error == nil{
//
//                cell.setNeedsLayout()
//            }
//        })
//
//        cell.textLabel?.text = titleArray[indexPath.row]
//        cell.textLabel?.adjustsFontSizeToFitWidth = true
//        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
//        cell.textLabel?.numberOfLines = 5
//        cell.detailTextLabel?.numberOfLines = 5
//
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection numberOfRowsInSectionsection: Int) -> Int {
//
//        return titleArray.count
//    }
//
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        return view.frame.size.height/5
//
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let indexNumber = indexPath.row
////let webviewController = WebViewController()
//        let url = youtubeURLArray[indexNumber]
//        UserDefaults.standard.set(url, forKey: "url")
////   present(webviewController, animated: true, completion: nil)
//
//    }
    //(XLPagerTabStrip)タブタイトルを返却するコードは共通化
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: self.keyword!)
    }

}

