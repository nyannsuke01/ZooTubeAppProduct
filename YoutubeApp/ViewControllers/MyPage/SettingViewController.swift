//
//  SettingViewController.swift
//  ZooTube
//
//  Created by user on 2020/09/06.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseAuth
import SVProgressHUD

class SettingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var likeAnimalLabel: UILabel!
    @IBOutlet weak var likeAnimalPicker: UIPickerView!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

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
            // strageからアイコン画像の表示
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let imageRef = Storage.storage().reference().child(Const.IconImagePath).child(uid + ".jpg")
            iconImageView.sd_setImage(with: imageRef)
        }

        //ImageViewのタップ認識をONにする
        iconImageView.isUserInteractionEnabled = true

        //キーボード表示のオブザーバーの設定
        setupNotificationObserver()

        setUpViews()
    }

    private func setUpViews() {
        //プロフィール写真の設定
        iconImageView.layer.cornerRadius = 40
        iconImageView.layer.borderColor = UIColor.gray.cgColor
        iconImageView.layer.borderWidth = 1

        //ボタンの色の設定
        changeButton.backgroundColor = UIColor.rgb(red: 255, green: 141, blue: 0)
        logoutButton.backgroundColor = UIColor.rgb(red: 255, green: 141, blue: 0)
        cancelButton.backgroundColor = UIColor.rgb(red: 255, green: 141, blue: 0)
    }

    //アイコンイメージの設定
    @IBAction func imageSetting(_ sender: Any) {
        print("image Tapped")
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
            //picker閉じる
            picker.dismiss(animated: true, completion: nil)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // ImageSelectViewController画面を閉じてMyPageViewControllerに戻る
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    //キーボード表示のオブザーバーの設定
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func showKeyboard(notification: Notification) {
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue

        guard let keyboardMinY = keyboardFrame?.minY else { return }
        let registerButtonMaxY = changeButton.frame.maxY
        let distance = registerButtonMaxY - keyboardMinY + 20

        let transform = CGAffineTransform(translationX: 0, y: -distance)

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.view.transform = transform
        })
    }

    @objc func hideKeyboard() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.view.transform = .identity
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func handleChangeButton(_ sender: Any) {
        //写真を保存
        handlePostButton()
    }

    func handlePostButton() {
        // 画像をJPEG形式に変換する
        guard let image = iconImageView.image else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.7) else { return }
        // 画像と投稿データの保存場所を定義する
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let imageRef = Storage.storage().reference().child(Const.IconImagePath).child(uid + ".jpg")
        // HUDで投稿処理中の表示を開始
        SVProgressHUD.show()
        // Storageに画像をアップロードする
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            if error != nil {
                // 画像のアップロード失敗
                print(error!)
                SVProgressHUD.showError(withStatus: "画像のアップロードが失敗しました")
                // 画面を閉じてタブ画面に戻る
                self.dismiss(animated: true, completion: nil)
                return
            }
            //画像のアップロード成功時、画像URLをFirestoreに設定する
            imageRef.downloadURL { (url, error) in
                if error != nil {
                    print("Firestorageからのダウンロードに失敗しました。", error!)
                    return
                }

                guard let urlString = url?.absoluteString else { return }
                self.createUserToFirestore(profileImageUrl: urlString)
            }
            // HUDで投稿完了を表示する
            SVProgressHUD.showSuccess(withStatus: "写真を投稿しました")
        }
    }

    private func createUserToFirestore(profileImageUrl: String) {

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
                    guard let name = Auth.auth().currentUser?.displayName else { return }
                    let userDic = [
                        "favoriteAnimal": self.selectedAnimal, // 「好きな動物」欄で選ばれた動物
                        "name": name,
                        "date": FieldValue.serverTimestamp(),
                        "profileImageUrl": profileImageUrl
                    ] as [String : Any]
                      userRef.setData(userDic)
                    // HUDで完了を知らせる
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
                }
            }
        }
        // キーボードを閉じる
        self.view.endEditing(true)
        // 画面を閉じてタブ画面に戻る
        self.dismiss(animated: true, completion: nil)

    }
    

    // ログアウトする
    @IBAction func handleLogoutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            // ログイン画面を表示する
            let storyBoard = UIStoryboard(name: "Login", bundle: nil)
            let loginViewController = storyBoard.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController, animated: true, completion: nil)
        } catch (let err) {
            print("ログアウトに失敗しました: \(err)")
        }
    }
    @IBAction func cancellButtonTapped(_ sender: Any) {
        // 画面を閉じてタブ画面に戻る
        self.dismiss(animated: true, completion: nil)
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
        self.selectedAnimal = selectLikeAnimal
        likeAnimalLabel.text = "好きな動物  " + selectLikeAnimal
    }
}
