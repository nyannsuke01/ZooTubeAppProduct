//
//  SettingViewController.swift
//  ZooTube
//
//  Created by user on 2020/09/06.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class SettingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var likeAnimalLabel: UILabel!
    @IBOutlet weak var likeAnimalPicker: UIPickerView!

    var selectedAnimal = ""

    //PickerViewに格納されるリスト
     let dataList = [
         "ねこ","いぬ","うさぎ","ハムスター",
         "しろくま","きつね","ペンギン","イルカ",
         "あざらし","りす","きつね",
         "パンダ","ラッコ"
     ]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 表示名を取得してTextFieldに設定する
        let user = Auth.auth().currentUser
        if let user = user {
            displayNameTextField.text = user.displayName
        }
        //プロフィール写真を円に設定
        iconImageView.layer.cornerRadius = 40
    }

    //アイコンイメージの設定
    @IBAction func imageSetting(_ sender: Any) {
        // ライブラリ（カメラロール）を指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    // 写真を選択したときに呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.originalImage] != nil {
            // 選択された画像を取得する
            let image = info[.originalImage] as! UIImage

            // 選択された画像をiconImageViewに入れる
            iconImageView.image = image

            //画面の再描画
            self.viewWillAppear(true)

        }
    }


    @IBAction func handleChangeButton(_ sender: Any) {

        if let displayName = displayNameTextField.text {

            // 表示名が入力されていない時はHUDを出して何もしない
            if displayName.isEmpty {
                SVProgressHUD.showError(withStatus: "表示名を入力して下さい")
                return
            }

            // 表示名を設定する
            let user = Auth.auth().currentUser
            if let user = user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges { error in
                    if let error = error {
                        SVProgressHUD.showError(withStatus: "表示名の変更に失敗しました。")
                        print("DEBUG_PRINT: " + error.localizedDescription)
                        return
                    }
                    print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")

                    //ここで好きな動物の追加のコードを書く　ログインできたことが前提であるため
                    let uid = Auth.auth().currentUser?.uid
                    // ログインしているユーザーのidをドキュメントのidとして作成するドキュメントを指定
                    let userRef = Firestore.firestore().collection(Const.UserPath).document(uid!)
                    let userDic = [
                        "favoriteAnimal": self.selectedAnimal // 「好きな動物」欄で選ばれた動物
                    ] as [String : Any]
                      userRef.setData(userDic)

                    //プロフィール写真の保存の処理


                    // HUDで完了を知らせる
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
                }
            }
        }
        // キーボードを閉じる
        self.view.endEditing(true)
    }

    //インスタグラムアプリの処理を借りています

    @objc func handlePostButton(_ sender: Any) {
        // 画像をJPEG形式に変換する
        let imageData = iconImageView.image!.jpegData(compressionQuality: 0.75)
        // 画像と投稿データの保存場所を定義する
        let postRef = Firestore.firestore().collection(Const.UserPath).document()
        let imageRef = Storage.storage().reference().child(Const.IconImagePath).child(postRef.documentID + ".jpg")
        // HUDで投稿処理中の表示を開始
        SVProgressHUD.show()
        // Storageに画像をアップロードする
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
            if error != nil {
                // 画像のアップロード失敗
                print(error!)
                SVProgressHUD.showError(withStatus: "画像のアップロードが失敗しました")
                // 投稿処理をキャンセルし、先頭画面に戻る
                UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                return
            }
            // FireStoreに投稿データを保存する
            let name = Auth.auth().currentUser?.displayName

//            let postDic = [
//                "name": name!,
//                "date": FieldValue.serverTimestamp(),
//                ] as [String : Any]
//            postRef.setData(postDic)
            // HUDで投稿完了を表示する
            SVProgressHUD.showSuccess(withStatus: "投稿しました")
            // 投稿処理が完了したので先頭画面に戻る
            UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    // ログアウトする
    @IBAction func handleLogoutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            // ログイン画面を表示する
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
        } catch (let err) {
            print("ログアウトに失敗しました: \(err)")
        }
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension SettingViewController:UIPickerViewDelegate, UIPickerViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Delegate設定
        likeAnimalPicker.delegate = self
        likeAnimalPicker.dataSource = self
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataList[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectLikeAnimal = dataList[row]
        likeAnimalLabel.text = "好きな動物  " + selectLikeAnimal
    }
}
