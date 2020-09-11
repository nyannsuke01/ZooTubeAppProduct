//
//  MyPageViewController.swift
//  ZooTube
//
//  Created by user on 2020/09/06.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit

class MyPageViewController: UIViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var likeAnimalLabel: UILabel!
    @IBOutlet weak var changeIconButton: UIButton!
    @IBOutlet weak var videoListCollectionView: UICollectionView!


    private let atentionCellId = "atentionCellId"
    private var videoItems = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        fetchYoutubeSerachInfo()
    }


    @IBAction func toSetting(_ sender: Any) {
        print("設定ボタンがタップされました")
        let settingVC = storyboard?.instantiateViewController(identifier: "SettingViewController") as! SettingViewController
        self.present(settingVC, animated: true, completion: nil)
    }
    private func setupViews() {
        videoListCollectionView.delegate = self
        videoListCollectionView.dataSource = self

        // VideoListCellのコレクションビューを設定
        videoListCollectionView.register(AttentionCell.self, forCellWithReuseIdentifier: atentionCellId)
        //プロフィール写真を円に設定
        iconImageView.layer.cornerRadius = 40

    }
    //Youtube検索情報を取得
    private func fetchYoutubeSerachInfo() {
        //TODO: paramを好きな動物に変える
        let params = ["q": "ねこ　かわいい"]

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
extension MyPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //　videoListCollectionViewのCollectionViewの処理

    //アイテムが選択された時の動作
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let videoViewController = UIStoryboard(name: "Video", bundle: nil).instantiateViewController(identifier: "VideoViewController") as VideoViewController

        videoViewController.selectedItem = videoItems[indexPath.row]

        self.present(videoViewController, animated: true, completion: nil)
    }

    //アイテムの高さを返す
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
            return .init(width: width, height: 200)
    }
    //セクションの中のアイテムの数を返す（行）
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    //アイテムの中身を返すメソッド
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            //atentionCellIdのcellのみ返す
            let cell = videoListCollectionView.dequeueReusableCell(withReuseIdentifier: atentionCellId, for: indexPath) as! AttentionCell
            cell.videoItems = self.videoItems

            return cell
    }


}


