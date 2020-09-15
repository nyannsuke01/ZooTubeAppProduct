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

class SettingViewController: UIViewController {

    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var likeAnimalLabel: UILabel!
    @IBOutlet weak var likeAnimalPicker: UIPickerView!
    

    //PickerViewに格納されるリスト
     let dataList = [
         "ねこ","いぬ","うさぎ","ハムスター",
         "しろくま","きつね","ペンギン","イルカ",
         "あざらし","りす","フェネックギツネ",
         "パンダ","ラッコ"
     ]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        // 表示名を取得してTextFieldに設定する
//        let user = Auth.auth().currentUser
//        if let user = user {
//            displayNameTextField.text = user.displayName
//        }
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

                    // HUDで完了を知らせる
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
                }
            }
        }
        // キーボードを閉じる
        self.view.endEditing(true)
    }

    @IBAction func handleLogoutButton(_ sender: Any) {
        // ログアウトする
        try! Auth.auth().signOut()

        // ログイン画面を表示する
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewController!, animated: true, completion: nil)

        // ログイン画面から戻ってきた時のためにホーム画面（index = 0）を選択している状態にしておく
        tabBarController?.selectedIndex = 0
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
