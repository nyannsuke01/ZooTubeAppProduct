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

class CommonPageViewController: UIViewController {

    //キーワードのインスタンス化 selfのプロパティを当てる
    var keyword: String?

    let cellId = "cellId"
    var videoItems = [Item]()

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
    // Youtube検索情報を取得
func fetchYoutubeSearchInfo(keyword: String) {
    let params = ["q": keyword]

    API.shared.request(path: .search, params: params, type: Video.self) { [weak self] (video) in
        guard let self = self else { return }
        
        self.videoItems = video.items
        if let id = self.videoItems.first?.snippet.channelId {
            self.fetchYoutubeChannelInfo(id: id)
        }
    }
}
        //Youtubeチャンネル情報を取得
    func fetchYoutubeChannelInfo(id: String) {
        let params = [
            "id": id
        ]

        API.shared.request(path: .channels, params: params, type: Channel.self) { (channel) in
            self.videoItems.forEach { (item) in
                item.channel = channel
            }

            self.videoListCollectionView.reloadData()
        }
    }
}
