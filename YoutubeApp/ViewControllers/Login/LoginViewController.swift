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
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!

    // ログインボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleLoginButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text {

            // アドレスとパスワード名のいずれかでも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty {
                SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
                return
            }

            // HUDで処理中を表示
            SVProgressHUD.show()

            Auth.auth().signIn(withEmail: address, password: password) { authResult, error in
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "サインインに失敗しました。")
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

            // アドレスとパスワードと表示名、好きな動物のいずれかでも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty || displayName.isEmpty {
                print("DEBUG_PRINT: 何かが空文字です。")
                SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ログインボタンの状態　非活性
        loginButton.layer.cornerRadius = 10
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        //アカウント作成ボタンの状態　非活性
        createAccountButton.layer.cornerRadius = 10
        createAccountButton.isEnabled = false
        createAccountButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)

        mailAddressTextField.delegate = self
        passwordTextField.delegate = self
    }
}


// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emaillIsEmpty = mailAddressTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true

        if emaillIsEmpty || passwordIsEmpty {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
            createAccountButton.isEnabled = false
            createAccountButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        } else {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 255, green: 141, blue: 0)
            createAccountButton.isEnabled = true
            createAccountButton.backgroundColor = UIColor.rgb(red: 255, green: 141, blue: 0)
        }
    }

}
