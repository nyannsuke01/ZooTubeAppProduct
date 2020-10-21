//
//  LikeViewController.swift
//  ZooTube
//
//  Created by user on 2020/09/01.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import FirebaseFirestore
import FirebaseUI

class LikeViewController: UIViewController {

    @IBOutlet weak var videoListCollectionView: UICollectionView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var emptyStateImageView: UIView!

    private var prevContentOffset: CGPoint = .init(x: 0, y: 0)
    private let headerMoveHeight: CGFloat = 5

    private let cellId = "cellId"
    private var videoItems = [Item]()


    var userData: User!
    var userArray: [User] = []
    // Firestoreのリスナー
    var listener: ListenerRegistration!


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //前に読み込んでいたcollectitonViewの中身を空にする必要がある
        videoItems = []  // collectitonView に表示しているデータを格納している配列
        videoListCollectionView.reloadData()
        setupViews()
        fetchFirestoreVideoId()
    }

    private func setupViews() {
        videoListCollectionView.delegate = self
        videoListCollectionView.dataSource = self

        // VideoListCellのコレクションビューを設定
        videoListCollectionView.register(UINib(nibName: "VideoListCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        //　プロフィール写真を円に設定
        iconImageView.layer.cornerRadius = 20
        // strageからアイコン画像、エンプティステートの表示
        guard let uid = Auth.auth().currentUser?.uid else {
            self.view.bringSubviewToFront(emptyStateImageView)
            return
        }
        //　認証済であればエンプティステートを消す
        self.emptyStateImageView.isHidden = true
        let imageRef = Storage.storage().reference().child(Const.IconImagePath).child(uid + ".jpg")
        iconImageView.sd_setImage(with: imageRef)

    }

    //取得したvidoIdを呼び出す

    private func fetchFirestoreVideoId(){

        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userRef = Firestore.firestore().collection(Const.UserPath).document(uid)

        userRef.getDocument { [self] (document, error) in
            if let document = document, document.exists {
                let userDic = document.data()
                //documentのdataの中にある"videoId"を配列として取得
                if let videoIds: [String] = userDic!["videoId"] as? [String] {
//                    let videoId = videoIds.joined(separator: ",")
//                  //取得したvideoIdを元にYoutube検索情報を取得
//                    fetchYoutubeSerachInfo(videoId: videoId)
                    // videoIdsがnilでないならこれを使ってAPIリクエスト
                    for videoId in videoIds {
                        print(videoId)
                        //取得したvideoIdを元にYoutube検索情報を取得
                        fetchYoutubeSerachInfo(videoId: videoId)
                    }
                    print(videoIds)
                }
                // DocumentにあるvideoIdを配列に格納したい

            } else {
                print("Document does not exist")
            }
        }
    }


    //Youtube検索情報を取得
    private func fetchYoutubeSerachInfo(videoId: String) {

        // 配列をString型に変換して、１つずつリクエストをしたい
        // videoIdを取得した後、YoutubeAPIリクエストのパラメーターとして取り出したvideoIdを入れたい
        let params = ["q": videoId]

        API.shared.request(path: .search, params: params, type: Video.self) { (video) in

            if video.items.count <= 0 {
                return
            }

            self.videoItems.append(video.items[0])
            let id = self.videoItems[0].snippet.channelId
            print(id)
            self.fetchYoutubeChannelInfo(id: id)
        }
    }

    //Youtubeチャンネル情報を取得
    private func fetchYoutubeChannelInfo(id: String) {
        //TODO: お気に入りで登録したvideoIdを渡してあげる
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

    @IBAction func toSetting(_ sender: Any) {
        //設定ボタンはログインできたことが前提
        guard (Auth.auth().currentUser?.uid) != nil else {
            return
        }
        print("設定ボタンがタップされました")
        let storyBoard = UIStoryboard(name: "Setting", bundle: nil)
        let SettingVC = storyBoard.instantiateViewController(identifier: "Setting") as! SettingViewController
        SettingVC.modalPresentationStyle = .fullScreen
        self.present(SettingVC, animated: true, completion: nil)
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
    //アイテムが選択された時の動作
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //VideoViewControllerに遷移
        let videoViewController = UIStoryboard(name: "Video", bundle: nil).instantiateViewController(identifier: "VideoViewController") as VideoViewController
        //TODO: ここの処理の記述が不明 配列の範囲外になる
        videoViewController.selectedItem = videoItems[indexPath.row]

        self.present(videoViewController, animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width

        return .init(width: width, height: width)

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoItems.count
    }

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

//  　エンプティステート のためのコード
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



