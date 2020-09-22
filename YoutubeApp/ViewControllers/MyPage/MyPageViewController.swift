//
//  MyPageViewController.swift
//  ZooTube
//
//  Created by user on 2020/09/06.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class MyPageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var likeAnimalLabel: UILabel!
    @IBOutlet weak var changeIconButton: UIButton!
    @IBOutlet weak var videoListCollectionView: UICollectionView!


    let atentionCellId = "atentionCellId"
    private var videoItems = [Item]()

    var user: User? {
        //受け取ったuser情報をここで一旦取り出す
        didSet {
            print("user?.name: ", user?.name as Any)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        setupViews()
        //TODO: 好きな動物が入力されていれば、
        fetchYoutubeSerachInfo()
    }

    // アイコンの変更をタップしたときに呼ばれるメソッド
    //TODO: 設定画面に遷移するようにする
    @IBAction func toSettingButton(_ sender: Any) {

        print("設定ボタンがタップされました")
        let storyBoard = UIStoryboard(name: "Setting", bundle: nil)
        let SettingVC = storyBoard.instantiateViewController(identifier: "Setting") as! SettingViewController
        SettingVC.modalPresentationStyle = .fullScreen
        self.present(SettingVC, animated: true, completion: nil)
    }
    
    private func setupViews() {
        videoListCollectionView.delegate = self
        videoListCollectionView.dataSource = self

        guard let name = Auth.auth().currentUser?.displayName else { return }
        userNameLabel.text = name
        likeAnimalLabel.text = user?.favoriteAnimal
        // strageからアイコン画像の表示
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let imageRef = Storage.storage().reference().child(Const.IconImagePath).child(uid + ".jpg")
        iconImageView.sd_setImage(with: imageRef)

        // VideoListCellのコレクションビューを設定
        videoListCollectionView.register(AttentionCell.self, forCellWithReuseIdentifier: atentionCellId)
        //プロフィール写真を円に設定
        iconImageView.layer.cornerRadius = 40

    }
    //Youtube検索情報を取得
    private func fetchYoutubeSerachInfo() {
        //好きな動物データの取得 ログインで好きな動物の登録が終わった後に、登録していた好きな動物を取り出す操作
        // ログインしているユーザーのidを取得
        if let uid = Auth.auth().currentUser?.uid {
            // ユーザー情報は単純に単一ドキュメントからの情報取得
            let userRef = Firestore.firestore().collection(Const.UserPath).document(uid)
            userRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let userDic = document.data()
                    let favoriteAnimal = userDic!["favoriteAnimal"] as? String
                    self.likeAnimalLabel.text = favoriteAnimal
                    let accountName = userDic!["name"] as? String
                    self.userNameLabel.text = accountName
                } else {
                    print("Document does not exist")
                }
            }
        }
        // favoriteAnimalがnilでないならこれを使ってAPIリクエスト
        //TODO: paramを好きな動物に変える
        let params = ["q": self.likeAnimalLabel.text]

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


