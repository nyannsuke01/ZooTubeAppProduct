//
//  VideoViewController.swift
//  YoutubeApp
//
//  Created by user on 2020/08/02.
//  Copyright © 2020 Uske. All rights reserved.
//

import UIKit
import Nuke
import Firebase

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


    // 共通URL
    // youtubeURL = https://www.youtube.com/watch?v=\(videoId!)
    private let baseYouTubeUrl = "https://www.youtube.com/watch?v="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

//        let user = User(dic: [String : Any])
//
//        //userのlikesを取り出す
//        let userData = user.likes
//
//        let videoId = self.selectedItem?.id.videoId
//
//        // likesを更新する
//        if let myid = Auth.auth().currentUser?.uid {
//            // 更新データを作成する　タップした動画のvideoIdがuserのlikesに既に保存されていれば、
//            if userData.isLiked {
//                // すでにいいねをしている場合は、いいね解除のためmyidを取り除く更新データを作成
//                updateValue = FieldValue.arrayRemove([myid])
//
//                let buttonImage = UIImage(named: "like_exist")
//                self.likeButton.setImage(buttonImage, for: .normal)
//            } else {
//                // 今回新たにいいねを押した場合は、myidを追加する更新データを作成
//                updateValue = FieldValue.arrayUnion([myid])
//                let buttonImage = UIImage(named: "like_none")
//                self.likeButton.setImage(buttonImage, for: .normal)
//            }
//            // likesに更新データを書き込む
//            let postRef = Firestore.firestore().collection(Const.PostPath).document(userData.id)
//            postRef.updateData(["likes": updateValue])
//        }
    }

    //　シェアボタンの実装 UIActivityViewControllerが表示され、シェアできる。
    //　UIActivityViewControllerが立ち上がったら、テキスト、URL、videoImageViewを入れる。
    @IBAction func shareButtonTapped(_ sender: Any) {
        let text = commentTextField!.text
        let videoId = self.selectedItem?.id.videoId
        let url = baseYouTubeUrl + videoId!
        let sampleUrl = NSURL(string: url)!
        let image = videoImageView.image

        let items = [text!, sampleUrl, image!] as [Any]


        //　UIActivityViewControllerをインスタンス化
        let activityVc = UIActivityViewController(activityItems: items, applicationActivities: nil)

        //　UIAcitivityViewControllerを表示
        self.present(activityVc, animated: true, completion: nil)
    }

    //　VideListViewControllerに戻る
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
