//
//  CreateAccountViewController.swift
//  YoutubeApp
//
//  Created by user on 2020/10/20.
//  Copyright © 2020 user. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupNotificationObserver()
        
        mailAddressTextField.delegate = self
        passwordTextField.delegate = self
        displayNameTextField.delegate = self
    }
    
    // アカウント作成ボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {

            // アドレスとパスワードと表示名、アカウント名のいずれかでも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty || displayName.isEmpty {
                print("DEBUG_PRINT3: 何かが空文字です。")
                SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
                return
            }

            // HUDで処理中を表示
            SVProgressHUD.show()

            // アドレスとパスワードでユーザー作成。ユーザー作成に成功すると、自動的にログインする
            Auth.auth().createUser(withEmail: address, password: password) { authResult, error in
                if let error = error {
                    // エラーがあったら原因をprintして、returnすることで以降の処理を実行せずに処理を終了する
                    print("DEBUG_PRINT4: " + error.localizedDescription)
                    let errorMessage: String = error.localizedDescription
                    SVProgressHUD.showError(withStatus: errorMessage)
                    return
                }
                print("DEBUG_PRINT5: ユーザー作成に成功しました。")

                // 表示名を設定する
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            // プロフィールの更新でエラーが発生
                            print("DEBUG_PRINT6: " + error.localizedDescription)
                            return
                        }
                        print("DEBUG_PRINT7: [displayName = \(user.displayName!)]の設定に成功しました。")

                        // HUDを消す
                        SVProgressHUD.dismiss()

                        // 画面を閉じてタブ画面に戻る
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }

    @IBAction func handleCancelButton(_ sender: Any) {
        // 画面を閉じてタブ画面に戻る
        self.dismiss(animated: true, completion: nil)
    }


    //　画面の初期状態
    private func setupViews() {
        //ログインボタンの状態　非活性 初期化
        createAccountButton.layer.cornerRadius = 6.0
        createAccountButton.backgroundColor = UIColor.rgb(red: 255, green: 230, blue: 244)

    }

    //キーボードの通知の設定
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func showKeyboard(notification: Notification) {
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue

        guard let keyboardMinY = keyboardFrame?.minY else { return }
        let registerButtonMaxY = createAccountButton.frame.maxY
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
}


// MARK: - UITextFieldDelegate
extension CreateAccountViewController: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emaillIsEmpty = mailAddressTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        let displayNameIsEmpty = displayNameTextField.text?.isEmpty ?? true

        //メールアドレス、pw、表示名のいずれかがからの場合、ボタン非活性
        if emaillIsEmpty || passwordIsEmpty || displayNameIsEmpty {
            createAccountButton.isEnabled = false
            createAccountButton.backgroundColor = UIColor.rgb(red: 255, green: 230, blue: 244)
        } else {
            createAccountButton.isEnabled = true
            createAccountButton.backgroundColor = UIColor.rgb(red: 255, green: 128, blue: 177)
        }
    }

}


