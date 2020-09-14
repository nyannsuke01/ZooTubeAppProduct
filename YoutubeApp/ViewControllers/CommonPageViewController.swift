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

    private let cellId = "cellId"
    private var videoItems = [Item]()

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
    
    //Youtube検索情報を取得
    private func fetchYoutubeSerachInfo() {
        let params = ["q": "犬"]

        API.shared.request(path: .search, params: params, type: Video.self) { (video) in
            self.videoItems = video.items
            let id = self.videoItems[0].snippet.channelId
            self.fetchYoutubeChannelInfo(id: id)
        }
    }

    //Youtubeチャンネル情報を取得
    private func fetchYoutubeChannelInfo(id: String) {
        let params = [
            "id": id
        ]

        API.shared.request(path: .channels, params: params, type: Channel.self) { (channel) in
            self.videoItems.forEach { (item) in
                item.channel = channel
            }

//            self.videoListCollectionView.reloadData()
        }
    }
//    //(XLPagerTabStrip)タブタイトルを返却するコードは共通化
//    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
//        return IndicatorInfo(title: self.keyword!)
//    }

}

