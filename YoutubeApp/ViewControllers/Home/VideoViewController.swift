//
//  VideoViewController.swift
//  YoutubeApp
//
//  Created by user on 2020/08/02.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Nuke
import Firebase
import FirebaseFirestore
import SVProgressHUD

class VideoViewController: TextFieldViewController {
    
    var selectedItem: Item?
    
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var channelImageView: UIImageView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var baseBackGroundView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!

    //　お気に入りフラグ　(未登録:0　登録済:1)
    var likeRegistrationFlag = 0

    let videoIds = [String]()

    // 共通URL
    // youtubeURL = https://www.youtube.com/watch?v=\(videoId!)
    private let baseYouTubeUrl = "https://www.youtube.com/watch?v="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLikedImage()
        setupViews()
        self.commentTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) {
            self.baseBackGroundView.alpha = 1
        }
        //　TextFieldViewControllerを継承して使用
        self.setUpNotificationForTextField()
        
    }

    private func setupViews() {

        channelImageView.layer.cornerRadius = 45 / 2
        
        if let url = URL(string: selectedItem?.snippet.thumbnails.medium.url ?? "") {
            Nuke.loadImage(with: url, into: videoImageView)
        }
        
        if let channelUrl = URL(string: selectedItem?.channel?.items[0].snippet.thumbnails.medium.url ?? "") {
            Nuke.loadImage(with: channelUrl, into: channelImageView)
        }
        
        videoTitleLabel.text = selectedItem?.snippet.title
        channelTitleLabel.text = selectedItem?.channel?.items[0].snippet.title
        
    }

    private func setupLikedImage() {
        // お気に入りに入っている動画なら、ハートマークを表示。そうでないなら、ハートマーク非表示
        // 選択したvideoIdがFirebaseのvideoIdに含まれていれば、likedImage()を呼ぶ

        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userRef = Firestore.firestore().collection(Const.UserPath).document(uid)
        let videoIds = self.selectedItem?.id.videoId

        //ドキュメントEXISTを使うイメージ
        let likeRef = Firestore.firestore().collection(Const.UserPath).document(uid).collection("likes").document(videoIds!)

        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"

                if let videoId = document.data()?["videoId"] as? [String] {
                    if videoId.contains(videoIds!) {
                        print("\(document.documentID) => \(document.data())")
                        print("お気に入りに登録済の動画です")
                        //お気に入りに登録済みであれば、likedImage()を呼び出し、ハートマークを表示する
                        self.likedImage()
                        //　お気に入りフラグ　(未登録:0　登録済:1)
                        self.likeRegistrationFlag = 1

                    } else {
                        // お気に入りじゃない
                    }
                }
                print("Document data: \(dataDescription)")
                print("①ドキュメントはあります！")
            } else {
                print("Document does not exist")
            }
        }
    }

    private func likedImage() {
        //まだお気に入りボタンがお押されていない場合
        let buttonImage = UIImage(named: "like_exist")
        self.likeButton.setImage(buttonImage, for: .normal)

    }
    private func notLikedImage() {
        // 既にお気に入りボタンがお押されている場合
        let buttonImage = UIImage(named: "like_none")
        self.likeButton.setImage(buttonImage, for: .normal)

    }

    //　再生ボタンの実装
    //　UserDefaultsにURLを入れてWebViewControllerに渡す
    //　youtubeURL = "https://www.youtube.com/watch?v=\(videoId!)"
    @IBAction func PlayButtonTapped(_ sender: Any) {

        let playWebviewController = PlayWebViewController()
        let videoId = self.selectedItem?.id.videoId
        let url = baseYouTubeUrl + videoId!
        UserDefaults.standard.set(url, forKey: "url")
        present(playWebviewController, animated: true, completion: nil)

    }

    @IBAction func likeButtonTapped(_ sender: Any) {

        //ここでお気に入り追加　ログインできたことが前提であるため
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // ログインしているユーザーのidをドキュメントのidとして作成するドキュメントを指定
        let userRef = Firestore.firestore().collection(Const.UserPath).document(uid)
        let videoId = self.selectedItem?.id.videoId

        //　お気に入りフラグ　(未登録:0　登録済:1)
        if likeRegistrationFlag == 1 {
            // 既にお気に入りボタンが押されている場合
            notLikedImage()
            // 選択したvideoIdをuserDicに追加する
            let userDic = [
                "videoId": FieldValue.arrayRemove([videoId!])
            ] as [String : Any]
            //　お気に入りフラグ　(未登録:0　登録済:1)
            likeRegistrationFlag = 0
            userRef.updateData(userDic)
            SVProgressHUD.showSuccess(withStatus: "お気に入りを解除しました")

        } else {
            //まだお気に入りボタンがお押されていない場合
            likedImage()
            // 選択したvideoIdをuserDicから取り除く
            let userDic = [
                "videoId": FieldValue.arrayUnion([videoId!])
            ] as [String : Any]
            //　お気に入りフラグ　(未登録:0　登録済:1)
            likeRegistrationFlag = 1
            userRef.updateData(userDic)
            // HUDで完了を知らせる
            SVProgressHUD.showSuccess(withStatus: "お気に入り動画に追加しました")

        }
    }

    //　シェアボタンの実装 UIActivityViewControllerが表示され、シェアできる。
    //　UIActivityViewControllerが立ち上がったら、テキスト、URL、videoImageViewを入れる。
    @IBAction func shareButtonTapped(_ sender: Any) {
        let zooTubeText = "ZooTubeアプリで動物の動画で癒されよう！"
        let commentText = commentTextField!.text
        let videoId = self.selectedItem?.id.videoId
        let url = baseYouTubeUrl + videoId!
        let sampleUrl = NSURL(string: url)!

        let items = [zooTubeText, commentText!, sampleUrl] as [Any]


        //　UIActivityViewControllerをインスタンス化
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)

        //　UIAcitivityViewControllerを表示
        self.present(activityVC, animated: true, completion: nil)
    }

    //　VideListViewControllerに戻る
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
