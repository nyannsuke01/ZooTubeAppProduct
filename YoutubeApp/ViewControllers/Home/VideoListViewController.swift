//
//  ViewController.swift
//  YoutubeApp
//
//  Created by user on 2020/07/05.
//  Copyright © 2020 User. All rights reserved.
//

import UIKit
import SDWebImage
import XLPagerTabStrip
import Alamofire

class VideoListViewController: CommonPageViewController, IndicatorInfoProvider {

    @IBOutlet weak var videoListCollectionView: UICollectionView!

//    let headerViewController = HeaderViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        videoListCollectionView.delegate = self
        videoListCollectionView.dataSource = self

        self.keyword = "ねこ"
        setupViews()
        fetchYoutubeSerachInfo()
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        headerViewController.setupIcon()
//    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
            return IndicatorInfo(title: self.keyword!)
        }

    private func setupViews() {
        // VideoListCellのコレクションビューを設定
        videoListCollectionView.register(UINib(nibName: "VideoListCell", bundle: nil), forCellWithReuseIdentifier: cellId)

    }
    //Youtube検索情報を取得
    private func fetchYoutubeSerachInfo() {
        let params = ["q": "かわいい　ねこ"]

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

            self.videoListCollectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension VideoListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //アイテムが選択された時の動作
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //VideoViewControllerに遷移
        let videoViewController = UIStoryboard(name: "Video", bundle: nil).instantiateViewController(identifier: "VideoViewController") as VideoViewController

        videoViewController.selectedItem = videoItems[indexPath.row]

        self.present(videoViewController, animated: true, completion: nil)
    }
    //アイテムの高さを返す
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width

        return .init(width: width, height: width)

    }
    //アイテムの数を返す
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoItems.count
    }

    //アイテムの中身を返すメソッド
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = videoListCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VideoListCell

        if self.videoItems.count == 0 {
            return cell
        } else {
            cell.videoItem = videoItems[indexPath.row]
        }
        return cell
    }

}
