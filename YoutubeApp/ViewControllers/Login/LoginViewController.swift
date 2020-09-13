//
//  LoginViewController.swift
//  ZooTube
//
//  Created by user on 2020/09/01.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var likeAnimalPicker: UIPickerView!
    @IBOutlet weak var likeAnimalLabel: UILabel!

    var selectedAnimal = ""

    //PickerViewに格納されるリスト
    let dataList = [
        "ねこ","いぬ","うさぎ","ハムスター",
        "しろくま","きつね","ペンギン","イルカ",
        "あざらし","りす","フェネックギツネ",
        "パンダ","ラッコ"
    ]

    // ログインボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleLoginButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text {

            // アドレスとパスワード名、好きな動物のいずれかでも入力されていない時は何もしない
        if address.isEmpty || password.isEmpty {
                return
            }

            Auth.auth().signIn(withEmail: address, password: password) { authResult, error in
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    return
                }
                print("DEBUG_PRINT: ログインに成功しました。")
                // HUDを消す
                SVProgressHUD.dismiss()

                // 画面を閉じてタブ画面に戻る
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    // アカウント作成ボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {

            // アドレスとパスワードと表示名のいずれかでも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty || displayName.isEmpty || self.selectedAnimal != "" {
                print("DEBUG_PRINT: 何かが空文字です。")
                return
            }

            // HUDで処理中を表示
            SVProgressHUD.show()

            // アドレスとパスワードでユーザー作成。ユーザー作成に成功すると、自動的にログインする
            Auth.auth().createUser(withEmail: address, password: password) { authResult, error in
                if let error = error {
                    // エラーがあったら原因をprintして、returnすることで以降の処理を実行せずに処理を終了する
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    return
                }
                print("DEBUG_PRINT: ユーザー作成に成功しました。")

                // ここで好きな動物の追加のコードを書く　ログインできたことが前提であるため
                let uid = Auth.auth().currentUser?.uid
                // ログインしているユーザーのidをドキュメントのidとして作成するドキュメントを指定
                let userRef = Firestore.firestore().collection(Const.UserPath).document(uid!)
                let userDic = [
                    "favoriteAnimal": self.selectedAnimal // 「好きな動物」欄で選ばれた動物
                ] as [String : Any]
                  userRef.setData(userDic)

                // 表示名を設定する
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            // プロフィールの更新でエラーが発生
                            print("DEBUG_PRINT: " + error.localizedDescription)
                            return
                        }
                        print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")

                        // HUDを消す
                        SVProgressHUD.dismiss()

                        // 画面を閉じてタブ画面に戻る
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension LoginViewController: UIPickerViewDelegate, UIPickerViewDataSource {

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
        var selectLikeAnimal = dataList[row]
        self.selectedAnimal = selectLikeAnimal
        likeAnimalLabel.text = "好きな動物  " + selectLikeAnimal
    }
}

