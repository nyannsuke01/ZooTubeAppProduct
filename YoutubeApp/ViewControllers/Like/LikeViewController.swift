//
//  LikeViewController.swift
//  ZooTube
//
//  Created by user on 2020/09/01.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Alamofire

class LikeViewController: UIViewController {

        @IBOutlet weak var videoListCollectionView: UICollectionView!
        @IBOutlet weak var profileImageView: UIImageView!
        @IBOutlet weak var headerView: UIView!
        @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
        @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!

        private var prevContentOffset: CGPoint = .init(x: 0, y: 0)
        private let headerMoveHeight: CGFloat = 5

        private let cellId = "cellId"
        private let atentionCellId = "atentionCellId"
        private var videoItems = [Item]()



        override func viewDidLoad() {
            super.viewDidLoad()

            setupViews()
            fetchYoutubeSerachInfo()
        }

        private func setupViews() {
            videoListCollectionView.delegate = self
            videoListCollectionView.dataSource = self

            // VideoListCellのコレクションビューを設定
            videoListCollectionView.register(UINib(nibName: "VideoListCell", bundle: nil), forCellWithReuseIdentifier: cellId)
            videoListCollectionView.register(AttentionCell.self, forCellWithReuseIdentifier: atentionCellId)
            //プロフィール写真を円に設定
            profileImageView.layer.cornerRadius = 20

        }
        //Youtube検索情報を取得
        private func fetchYoutubeSerachInfo() {
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
        //HeaderView消える処理
        private func headerViewEndAnimation() {
            if headerTopConstraint.constant < -headerHeightConstraint.constant / 2 {
                UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: [], animations: {

                    self.headerTopConstraint.constant = -self.headerHeightConstraint.constant
                    self.headerView.alpha = 0
                    self.view.layoutIfNeeded()
                })
            } else {
                //再出現
                UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: [], animations: {

                    self.headerTopConstraint.constant = 0
                    self.headerView.alpha = 1
                    self.view.layoutIfNeeded()
                })
            }
        }

    }

    // MARK: - ScrollViewのDelegateメソッド
    extension LikeViewController {

        // scrollした時に呼ばれるメソッド
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            headerAnimation(scrollView: scrollView)
        }

        private func headerAnimation(scrollView: UIScrollView) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.prevContentOffset = scrollView.contentOffset
            }

            guard let presentIndexPath = videoListCollectionView.indexPathForItem(at: scrollView.contentOffset) else { return }
            if scrollView.contentOffset.y < 0 { return }
            if presentIndexPath.row >= videoItems.count - 2 { return }

            let alphaRatio = 1 / headerHeightConstraint.constant

            if self.prevContentOffset.y < scrollView.contentOffset.y {
                if headerTopConstraint.constant <= -headerHeightConstraint.constant { return }
                headerTopConstraint.constant -= headerMoveHeight
                headerView.alpha -= alphaRatio * headerMoveHeight
            } else if self.prevContentOffset.y > scrollView.contentOffset.y {
                if headerTopConstraint.constant >= 0 { return }
                headerTopConstraint.constant += headerMoveHeight
                headerView.alpha += alphaRatio * headerMoveHeight
            }

        }

        // scrollViewのscrollがピタッと止まった時に呼ばれる
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate {
                headerViewEndAnimation()
            }
        }

        // scrollViewが止まった時に呼ばれる
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            headerViewEndAnimation()
        }

    }

    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
    extension LikeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        //　videoListCollectionViewのCollectionViewの処理

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

            let videoViewController = UIStoryboard(name: "Video", bundle: nil).instantiateViewController(identifier: "VideoViewController") as VideoViewController

            videoViewController.selectedItem = indexPath.row > 2 ? videoItems[indexPath.row - 1] : videoItems[indexPath.row]

            self.present(videoViewController, animated: true, completion: nil)
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = self.view.frame.width

            if indexPath.row == 2 {
                return .init(width: width, height: 200)
            } else {
                return .init(width: width, height: width)
            }
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return videoItems.count + 1
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if indexPath.row == 2 {
                let cell = videoListCollectionView.dequeueReusableCell(withReuseIdentifier: atentionCellId, for: indexPath) as! AttentionCell
                cell.videoItems = self.videoItems

                return cell
            } else {
                let cell = videoListCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VideoListCell

                if self.videoItems.count == 0 { return cell }

                if indexPath.row > 2 {
                    cell.videoItem = videoItems[indexPath.row - 1]
                } else {
                    cell.videoItem = videoItems[indexPath.row]
                }

                return cell
            }
        }
}

//    @IBOutlet weak var likeTableView: UITableView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//}
//extension LikeViewController: UITableViewDataSource, UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = "\(indexPath.row)"
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0 // <= ここを0にしたときに、画像が出現
//    }
//}
//
//extension LikeViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
//    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
//
//        let displayImage = UIImage(named: "Enpty")
//        return displayImage
//    }



